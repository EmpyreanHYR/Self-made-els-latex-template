@echo off
setlocal EnableExtensions DisableDelayedExpansion

chcp 65001 >nul

set "ELS_BUILD_SCRIPT=%~f0"
set "ELS_BUILD_DIR=%~dp0"

REM Run to completion without requiring a key press.
call :Main
set "BUILD_STATUS=%ERRORLEVEL%"
exit /b %BUILD_STATUS%

:Main

REM ================================================================
REM Auto-detect the main TeX file (any *-main.tex) and generate
REM submission files with pdfLaTeX:
REM
REM PDF output:
REM - {name}-full.pdf                 main + graphical abstract + highlights
REM - {name}-without-abstract.pdf     main (no graphical abstract/highlights)
REM - {name}-blind.pdf                double-blind main manuscript
REM - {name}-graphical-abstract.pdf   graphical abstract only
REM - {name}-highlights.pdf           highlights only
REM
REM Editable output:
REM - {name}-highlights.docx          editable Word highlights file
REM ================================================================

cd /d "%ELS_BUILD_DIR%"

set "MAIN_TEX="
for %%F in (*-main.tex) do (
  if defined MAIN_TEX (
    echo [ERROR] Multiple *-main.tex files found. Please keep only one.
    exit /b 1
  )
  set "MAIN_TEX=%%F"
)

if not defined MAIN_TEX (
  echo [ERROR] No *-main.tex file found in the current directory.
  exit /b 1
)

set "BASE_NAME=%MAIN_TEX:~0,-4%"
set "HIGHLIGHTS_TEX=0.Highlights.tex"
set "HIGHLIGHTS_DOCX=%BASE_NAME%-highlights.docx"

echo ================================================================
echo LaTeX submission build script
echo Main file: %MAIN_TEX%
echo Working dir: %CD%
echo ================================================================

where pdflatex >nul 2>nul
if errorlevel 1 (
  echo [ERROR] pdflatex not found. Please install MiKTeX/TeX Live and ensure pdflatex is in PATH.
  exit /b 1
)

where bibtex >nul 2>nul
if errorlevel 1 (
  echo [ERROR] bibtex not found. Please ensure BibTeX is installed and in PATH.
  exit /b 1
)

where powershell >nul 2>nul
if errorlevel 1 (
  echo [ERROR] powershell not found. It is required to generate the editable highlights Word file.
  exit /b 1
)

REM Create local preview options only when absent; CreateNew never overwrites.
if not exist "els-local.tex" (
  powershell -NoProfile -Command "$ErrorActionPreference='Stop'; $stream=[IO.File]::Open('els-local.tex',[IO.FileMode]::CreateNew,[IO.FileAccess]::Write); try { $writer=[IO.StreamWriter]::new($stream,[Text.UTF8Encoding]::new($false)); try { $writer.WriteLine('%% Local preview options; never upload this file.'); $writer.WriteLine('\ORCIDicontrue') } finally { $writer.Dispose() } } finally { $stream.Dispose() }"
  if errorlevel 1 exit /b 1
  echo Created els-local.tex: ORCID icons preferred; review mode is set in the main file.
)

echo.
echo [1/6] Building FULL ^(main + GA + highlights^)...
call :BuildWithBib "%BASE_NAME%-full" "\def\ELSAuthorsOutput{%BASE_NAME%-authors.txt}\def\ELSExportAuthors{1}\def\ELSShowAuthors{1}\def\FULL{1}\input{%MAIN_TEX%}"
if errorlevel 1 exit /b 1

echo.
echo [2/6] Building main only ^(no GA/highlights^)...
call :BuildWithBib "%BASE_NAME%-without-abstract" "\def\ELSShowAuthors{1}\def\WITHOUTABSTRACT{1}\input{%MAIN_TEX%}"
if errorlevel 1 exit /b 1

echo.
echo [3/6] Building double-blind main manuscript...
call :BuildWithBib "%BASE_NAME%-blind" "\def\BLIND{1}\def\WITHOUTABSTRACT{1}\input{%MAIN_TEX%}"
if errorlevel 1 exit /b 1

echo.
echo [4/6] Building graphical abstract only...
call :BuildPdf "%BASE_NAME%-graphical-abstract" "\def\ELSShowAuthors{1}\def\GRAPHICALONLY{1}\input{%MAIN_TEX%}"
if errorlevel 1 exit /b 1

echo.
echo [5/6] Building highlights PDF only...
call :BuildPdf "%BASE_NAME%-highlights" "\def\ELSShowAuthors{1}\def\HIGHLIGHTSONLY{1}\input{%MAIN_TEX%}"
if errorlevel 1 exit /b 1

echo.
echo [6/6] Building editable highlights Word file...
REM The complete PowerShell generator is embedded below; no PS1 dependency.
powershell -NoProfile -ExecutionPolicy Bypass -Command "$text=[IO.File]::ReadAllText($env:ELS_BUILD_SCRIPT); $marker='# ELS_HIGHLIGHTS_POWERSHELL'; $index=$text.LastIndexOf($marker); if ($index -lt 0) { throw 'Embedded Word generator missing' }; $code=$text.Substring($index+$marker.Length); & ([scriptblock]::Create($code)) -InputTex $env:HIGHLIGHTS_TEX -OutputDocx $env:HIGHLIGHTS_DOCX -MainTex $env:MAIN_TEX"
if errorlevel 1 exit /b 1

echo.
echo ================================================================
echo Done. Generated files:
echo   - %BASE_NAME%-full.pdf
echo   - %BASE_NAME%-without-abstract.pdf
echo   - %BASE_NAME%-blind.pdf
echo   - %BASE_NAME%-graphical-abstract.pdf
echo   - %BASE_NAME%-highlights.pdf
echo   - %HIGHLIGHTS_DOCX%
echo   - %BASE_NAME%-authors.txt
echo ================================================================

echo.
echo [CLEAN] Removing aux files ^(keeping PDFs and DOCX^)...
for %%V in (full without-abstract blind graphical-abstract highlights) do (
  for %%E in (aux bbl blg log out toc lof lot fls fdb_latexmk synctex.gz abs bcf run.xml) do (
    del /q "%BASE_NAME%-%%V.%%E" 2>nul
  )
  del /q "%BASE_NAME%-%%V-run.log" 2>nul
  del /q "%BASE_NAME%-%%V-bibtex.log" 2>nul
)

echo [CLEAN] Done.
echo.
echo Logs are retained if a build fails.

exit /b 0

:BuildWithBib
set "JOB=%~1"
set "TEX_COMMAND=\def\ELSCleanMetadata{1}%~2"
set "RUN_LOG=%JOB%-run.log"
call pdflatex -interaction=nonstopmode -halt-on-error -jobname="%JOB%" "%TEX_COMMAND%" > "%RUN_LOG%" 2>&1
if errorlevel 1 (
  echo [ERROR] pdflatex ^(1st pass^) failed for %JOB%. Last 15 lines of log:
  powershell -command "Get-Content -LiteralPath $env:RUN_LOG -Tail 15"
  exit /b 1
)
call bibtex "%JOB%" > "%JOB%-bibtex.log" 2>&1
if errorlevel 1 (
  echo [ERROR] bibtex failed for %JOB%. Last 15 lines of log:
  powershell -command "Get-Content -LiteralPath ($env:JOB+'-bibtex.log') -Tail 15"
  exit /b 1
)
call pdflatex -interaction=nonstopmode -halt-on-error -jobname="%JOB%" "%TEX_COMMAND%" > "%RUN_LOG%" 2>&1
if errorlevel 1 (
  echo [ERROR] pdflatex ^(2nd pass^) failed for %JOB%. Last 15 lines of log:
  powershell -command "Get-Content -LiteralPath $env:RUN_LOG -Tail 15"
  exit /b 1
)
call pdflatex -interaction=nonstopmode -halt-on-error -jobname="%JOB%" "%TEX_COMMAND%" > "%RUN_LOG%" 2>&1
if errorlevel 1 (
  echo [ERROR] pdflatex ^(3rd pass^) failed for %JOB%. Last 15 lines of log:
  powershell -command "Get-Content -LiteralPath $env:RUN_LOG -Tail 15"
  exit /b 1
)
exit /b 0

:BuildPdf
set "JOB=%~1"
set "TEX_COMMAND=\def\ELSCleanMetadata{1}%~2"
set "RUN_LOG=%JOB%-run.log"
call pdflatex -interaction=nonstopmode -halt-on-error -jobname="%JOB%" "%TEX_COMMAND%" > "%RUN_LOG%" 2>&1
if errorlevel 1 (
  echo [ERROR] pdflatex ^(1st pass^) failed for %JOB%. Last 15 lines of log:
  powershell -command "Get-Content -LiteralPath $env:RUN_LOG -Tail 15"
  exit /b 1
)
call pdflatex -interaction=nonstopmode -halt-on-error -jobname="%JOB%" "%TEX_COMMAND%" > "%RUN_LOG%" 2>&1
if errorlevel 1 (
  echo [ERROR] pdflatex ^(2nd pass^) failed for %JOB%. Last 15 lines of log:
  powershell -command "Get-Content -LiteralPath $env:RUN_LOG -Tail 15"
  exit /b 1
)
exit /b 0

# ELS_HIGHLIGHTS_POWERSHELL
param(
  [Parameter(Mandatory = $true)]
  [string]$InputTex,

  [Parameter(Mandatory = $true)]
  [string]$OutputDocx,

  [string]$MainTex = ""
)

$ErrorActionPreference = "Stop"

function Escape-XmlText {
  param([string]$Text)
  return [System.Security.SecurityElement]::Escape($Text)
}

function Convert-SimpleLatexText {
  param([string]$Text)
  $value = $Text.Trim()
  $value = $value -replace '\\&', '&'
  $value = $value -replace '\\%', '%'
  $value = $value -replace '\\_', '_'
  $value = $value -replace '\\#', '#'
  $value = $value -replace '\\textbf\{([^{}]*)\}', '$1'
  $value = $value -replace '\\emph\{([^{}]*)\}', '$1'
  $value = $value -replace '\\textit\{([^{}]*)\}', '$1'
  $value = $value -replace '\$([^$]*)\$', '$1'
  return $value.Trim()
}

function Get-PaperTitle {
  param([string]$MainTexPath)

  if (-not $MainTexPath -or -not (Test-Path -LiteralPath $MainTexPath)) {
    return "Paper Title"
  }

  $tex = Get-Content -LiteralPath $MainTexPath -Raw -Encoding UTF8
  $match = [regex]::Match($tex, '\\title(?:\[[^\]]*\])?\{([^{}]+)\}', [System.Text.RegularExpressions.RegexOptions]::Singleline)
  if (-not $match.Success) {
    return "Paper Title"
  }

  return (Convert-SimpleLatexText $match.Groups[1].Value)
}

if (-not (Test-Path -LiteralPath $InputTex)) {
  throw "Highlights source not found: $InputTex"
}

$items = New-Object System.Collections.Generic.List[string]
foreach ($line in Get-Content -LiteralPath $InputTex -Encoding UTF8) {
  if ($line -match '^\s*\\item\s*(.+?)\s*$') {
    $items.Add((Convert-SimpleLatexText $Matches[1]))
  }
}

if ($items.Count -eq 0) {
  throw "No \item lines found in $InputTex"
}

$paperTitle = Get-PaperTitle $MainTex

$outDir = Split-Path -Parent $OutputDocx
if ($outDir -and -not (Test-Path -LiteralPath $outDir)) {
  New-Item -ItemType Directory -Path $outDir | Out-Null
}

$tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ("highlights-docx-" + [System.Guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $tempDir | Out-Null

try {
  New-Item -ItemType Directory -Path (Join-Path $tempDir "_rels") | Out-Null
  New-Item -ItemType Directory -Path (Join-Path $tempDir "word") | Out-Null
  New-Item -ItemType Directory -Path (Join-Path $tempDir "word\_rels") | Out-Null

  Set-Content -LiteralPath (Join-Path $tempDir "[Content_Types].xml") -Encoding UTF8 -Value @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
  <Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/>
</Types>
'@

  Set-Content -LiteralPath (Join-Path $tempDir "_rels\.rels") -Encoding UTF8 -Value @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>
'@

  Set-Content -LiteralPath (Join-Path $tempDir "word\styles.xml") -Encoding UTF8 -Value @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:style w:type="paragraph" w:default="1" w:styleId="Normal">
    <w:name w:val="Normal"/>
    <w:qFormat/>
  </w:style>
  <w:style w:type="paragraph" w:styleId="Title">
    <w:name w:val="Title"/>
    <w:basedOn w:val="Normal"/>
    <w:qFormat/>
    <w:rPr><w:b/><w:sz w:val="32"/></w:rPr>
  </w:style>
</w:styles>
'@

  Set-Content -LiteralPath (Join-Path $tempDir "word\_rels\document.xml.rels") -Encoding UTF8 -Value @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
</Relationships>
'@

  $paragraphs = New-Object System.Text.StringBuilder
  [void]$paragraphs.AppendLine('<w:p><w:pPr><w:pStyle w:val="Title"/></w:pPr><w:r><w:t>' + (Escape-XmlText $paperTitle) + '</w:t></w:r></w:p>')
  [void]$paragraphs.AppendLine('<w:p><w:r><w:rPr><w:b/></w:rPr><w:t>Highlights</w:t></w:r></w:p>')
  foreach ($item in $items) {
    $escaped = Escape-XmlText $item
    [void]$paragraphs.AppendLine('<w:p><w:r><w:t>- ' + $escaped + '</w:t></w:r></w:p>')
  }

  $documentXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>
$paragraphs
    <w:sectPr>
      <w:pgSz w:w="11906" w:h="16838"/>
      <w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440" w:header="720" w:footer="720" w:gutter="0"/>
    </w:sectPr>
  </w:body>
</w:document>
"@
  Set-Content -LiteralPath (Join-Path $tempDir "word\document.xml") -Encoding UTF8 -Value $documentXml

  # Write completely before replacing an existing Word file.
  $stagedDocx = Join-Path $tempDir "highlights.docx"

  Add-Type -AssemblyName System.IO.Compression
  Add-Type -AssemblyName System.IO.Compression.FileSystem
  $archive = [System.IO.Compression.ZipFile]::Open($stagedDocx, [System.IO.Compression.ZipArchiveMode]::Create)
  try {
    $entries = @(
      @("[Content_Types].xml", "[Content_Types].xml"),
      @("_rels\.rels", "_rels/.rels"),
      @("word\document.xml", "word/document.xml"),
      @("word\styles.xml", "word/styles.xml"),
      @("word\_rels\document.xml.rels", "word/_rels/document.xml.rels")
    )

    foreach ($entry in $entries) {
      $source = Join-Path $tempDir $entry[0]
      $createdEntry = [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $source, $entry[1])
      $createdEntry.LastWriteTime = [DateTimeOffset]'1980-01-01T00:00:00+00:00'
    }
  }
  finally {
    $archive.Dispose()
  }
  Move-Item -LiteralPath $stagedDocx -Destination $OutputDocx -Force
  Write-Host "Word generated: $OutputDocx"
}
finally {
  if (Test-Path -LiteralPath $tempDir) {
    Remove-Item -LiteralPath $tempDir -Recurse -Force
  }
}
