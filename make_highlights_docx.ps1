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

  if (Test-Path -LiteralPath $OutputDocx) {
    Remove-Item -LiteralPath $OutputDocx -Force
  }

  Add-Type -AssemblyName System.IO.Compression
  Add-Type -AssemblyName System.IO.Compression.FileSystem
  $archive = [System.IO.Compression.ZipFile]::Open($OutputDocx, [System.IO.Compression.ZipArchiveMode]::Create)
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
      [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $source, $entry[1]) | Out-Null
    }
  }
  finally {
    $archive.Dispose()
  }
}
finally {
  if (Test-Path -LiteralPath $tempDir) {
    Remove-Item -LiteralPath $tempDir -Recurse -Force
  }
}
