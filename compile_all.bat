@echo off
setlocal EnableExtensions

REM 避免中文输出乱码（Windows 10/11 通常可用）
chcp 65001 >nul

REM ================================================================
REM Auto-detect main TeX file (any *-main.tex) and generate 4 PDFs
REM for submission (pdfLaTeX)
REM
REM Output:
REM - {name}-full.pdf                 main + graphical abstract + highlights
REM - {name}-without-abstract.pdf     main (no graphical abstract/highlights)
REM - {name}-graphical-abstract.pdf   graphical abstract only
REM - {name}-highlights.pdf           highlights only
REM ================================================================

cd /d "%~dp0"

REM ---- Detect the main TeX file ----
set "MAIN_TEX="
for %%F in (*-main.tex) do (
  if defined MAIN_TEX (
    echo [ERROR] Multiple *-main.tex files found. Please keep only one. / 检测到多个 *-main.tex 文件，请只保留一个。
    exit /b 1
  )
  set "MAIN_TEX=%%F"
)

if not defined MAIN_TEX (
  echo [ERROR] No *-main.tex file found in the current directory. / 当前目录未找到 *-main.tex 文件。
  exit /b 1
)

REM Extract base name (without .tex extension)
set "BASE_NAME=%MAIN_TEX:~0,-4%"

echo ================================================================
echo LaTeX PDF build script (4 variants) / LaTeX PDF 编译脚本（4 个版本）
echo Main file: %MAIN_TEX% / 主文件: %MAIN_TEX%
echo Working dir: %CD% / 工作目录: %CD%
echo ================================================================

where pdflatex >nul 2>nul
if errorlevel 1 (
  echo [ERROR] pdflatex not found. Please install MiKTeX/TeX Live and ensure pdflatex is in PATH. / 未找到 pdflatex。请安装 MiKTeX/TeX Live，并确保 pdflatex 已加入 PATH。
  exit /b 1
)

where bibtex >nul 2>nul
if errorlevel 1 (
  echo [ERROR] bibtex not found. Please ensure BibTeX is installed and in PATH. / 未找到 bibtex。请确保已安装 BibTeX 并加入 PATH。
  exit /b 1
)

echo.
echo [1/4] Building FULL (main + GA + highlights)... / 编译 FULL（正文 + 图像摘要 + Highlights）...
call pdflatex -interaction=nonstopmode -jobname=%BASE_NAME%-full "\def\FULL{1}\input{%MAIN_TEX%}" >nul
call bibtex %BASE_NAME%-full >nul
if errorlevel 1 exit /b 1
call pdflatex -interaction=nonstopmode -jobname=%BASE_NAME%-full "\def\FULL{1}\input{%MAIN_TEX%}" >nul
call pdflatex -interaction=nonstopmode -jobname=%BASE_NAME%-full "\def\FULL{1}\input{%MAIN_TEX%}" >nul
if errorlevel 1 exit /b 1

echo.
echo [2/4] Building main only (no GA/highlights)... / 编译正文（不含图像摘要/Highlights）...
call pdflatex -interaction=nonstopmode -jobname=%BASE_NAME%-without-abstract "\def\WITHOUTABSTRACT{1}\input{%MAIN_TEX%}" >nul
call bibtex %BASE_NAME%-without-abstract >nul
if errorlevel 1 exit /b 1
call pdflatex -interaction=nonstopmode -jobname=%BASE_NAME%-without-abstract "\def\WITHOUTABSTRACT{1}\input{%MAIN_TEX%}" >nul
call pdflatex -interaction=nonstopmode -jobname=%BASE_NAME%-without-abstract "\def\WITHOUTABSTRACT{1}\input{%MAIN_TEX%}" >nul
if errorlevel 1 exit /b 1

echo.
echo [3/4] Building graphical abstract only... / 编译仅图像摘要...
call pdflatex -interaction=nonstopmode -jobname=%BASE_NAME%-graphical-abstract "\def\GRAPHICALONLY{1}\input{%MAIN_TEX%}" >nul
call pdflatex -interaction=nonstopmode -jobname=%BASE_NAME%-graphical-abstract "\def\GRAPHICALONLY{1}\input{%MAIN_TEX%}" >nul
if errorlevel 1 exit /b 1

echo.
echo [4/4] Building highlights only... / 编译仅 Highlights...
call pdflatex -interaction=nonstopmode -jobname=%BASE_NAME%-highlights "\def\HIGHLIGHTSONLY{1}\input{%MAIN_TEX%}" >nul
call pdflatex -interaction=nonstopmode -jobname=%BASE_NAME%-highlights "\def\HIGHLIGHTSONLY{1}\input{%MAIN_TEX%}" >nul
if errorlevel 1 exit /b 1

echo.
echo ================================================================
echo Done. Generated PDFs: / 完成，生成 PDF：
echo   - %BASE_NAME%-full.pdf
echo   - %BASE_NAME%-without-abstract.pdf
echo   - %BASE_NAME%-graphical-abstract.pdf
echo   - %BASE_NAME%-highlights.pdf
echo ================================================================

echo.
echo [CLEAN] Removing aux files (keeping PDFs)... / 清理辅助文件（保留 PDF）...
for %%E in (aux bbl blg log out toc lof lot fls fdb_latexmk synctex.gz abs bcf run.xml) do (
  del /q "%BASE_NAME%-*.%%E" 2>nul
  del /q "%BASE_NAME%.%%E" 2>nul
)

echo [CLEAN] Done. / 清理完成。

echo.
echo To see full logs, remove ^>nul at line ends. / 如需查看完整日志，请去掉每行末尾的 ^>nul。

endlocal
exit /b 0
