@echo off
setlocal EnableExtensions

chcp 65001 >nul

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

cd /d "%~dp0"

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

echo.
echo [1/6] Building FULL (main + GA + highlights)...
call :BuildWithBib "%BASE_NAME%-full" "\def\FULL{1}\input{%MAIN_TEX%}"
if errorlevel 1 exit /b 1

echo.
echo [2/6] Building main only (no GA/highlights)...
call :BuildWithBib "%BASE_NAME%-without-abstract" "\def\WITHOUTABSTRACT{1}\input{%MAIN_TEX%}"
if errorlevel 1 exit /b 1

echo.
echo [3/6] Building double-blind main manuscript...
call :BuildWithBib "%BASE_NAME%-blind" "\def\BLIND{1}\def\WITHOUTABSTRACT{1}\input{%MAIN_TEX%}"
if errorlevel 1 exit /b 1

echo.
echo [4/6] Building graphical abstract only...
call :BuildPdf "%BASE_NAME%-graphical-abstract" "\def\GRAPHICALONLY{1}\input{%MAIN_TEX%}"
if errorlevel 1 exit /b 1

echo.
echo [5/6] Building highlights PDF only...
call :BuildPdf "%BASE_NAME%-highlights" "\def\HIGHLIGHTSONLY{1}\input{%MAIN_TEX%}"
if errorlevel 1 exit /b 1

echo.
echo [6/6] Building editable highlights Word file...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0make_highlights_docx.ps1" -InputTex "%HIGHLIGHTS_TEX%" -OutputDocx "%HIGHLIGHTS_DOCX%" -MainTex "%MAIN_TEX%"
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
echo ================================================================

echo.
echo [CLEAN] Removing aux files (keeping PDFs and DOCX)...
for %%E in (aux bbl blg log out toc lof lot fls fdb_latexmk synctex.gz abs bcf run.xml) do (
  del /q "%BASE_NAME%-*.%%E" 2>nul
  del /q "%BASE_NAME%.%%E" 2>nul
)

echo [CLEAN] Done.
echo.
echo To see full LaTeX logs, remove ^>nul at command line ends inside compile_all.bat.

endlocal
exit /b 0

:BuildWithBib
set "JOB=%~1"
set "TEX_COMMAND=%~2"
call pdflatex -interaction=nonstopmode -jobname=%JOB% "%TEX_COMMAND%" >nul
if errorlevel 1 exit /b 1
call bibtex %JOB% >nul
if errorlevel 1 exit /b 1
call pdflatex -interaction=nonstopmode -jobname=%JOB% "%TEX_COMMAND%" >nul
if errorlevel 1 exit /b 1
call pdflatex -interaction=nonstopmode -jobname=%JOB% "%TEX_COMMAND%" >nul
if errorlevel 1 exit /b 1
exit /b 0

:BuildPdf
set "JOB=%~1"
set "TEX_COMMAND=%~2"
call pdflatex -interaction=nonstopmode -jobname=%JOB% "%TEX_COMMAND%" >nul
if errorlevel 1 exit /b 1
call pdflatex -interaction=nonstopmode -jobname=%JOB% "%TEX_COMMAND%" >nul
if errorlevel 1 exit /b 1
exit /b 0
