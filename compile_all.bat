@echo off
setlocal EnableExtensions

REM 避免中文输出乱码（Windows 10/11 通常可用）
chcp 65001 >nul

REM ================================================================
REM Generate 4 PDFs for submission (XeLaTeX)
REM - cas-dc-template-full.pdf                 main + graphical abstract + highlights
REM - cas-dc-template-without-abstract.pdf     main (no graphical abstract/highlights)
REM - cas-dc-template-graphical-abstract.pdf   graphical abstract only
REM - cas-dc-template-highlights.pdf           highlights only
REM ================================================================

cd /d "%~dp0"

where xelatex >nul 2>nul
if errorlevel 1 (
  echo [ERROR] xelatex not found. Please install MiKTeX/TeX Live and ensure xelatex is in PATH. / 未找到 xelatex。请安装 MiKTeX/TeX Live，并确保 xelatex 已加入 PATH。
  exit /b 1
)

where bibtex >nul 2>nul
if errorlevel 1 (
  echo [ERROR] bibtex not found. Please ensure BibTeX is installed and in PATH. / 未找到 bibtex。请确保已安装 BibTeX 并加入 PATH。
  exit /b 1
)

echo ================================================================
echo LaTeX PDF build script (4 variants) / LaTeX PDF 编译脚本（4 个版本）
echo Working dir: %CD% / 工作目录: %CD%
echo ================================================================

echo.
echo [1/4] Building FULL (main + GA + highlights)... / 编译 FULL（正文 + 图像摘要 + Highlights）...
call xelatex -interaction=nonstopmode -jobname=cas-dc-template-full "\def\FULL{1}\input{cas-dc-template.tex}" >nul
call bibtex cas-dc-template-full >nul
if errorlevel 1 exit /b 1
call xelatex -interaction=nonstopmode -jobname=cas-dc-template-full "\def\FULL{1}\input{cas-dc-template.tex}" >nul
call xelatex -interaction=nonstopmode -jobname=cas-dc-template-full "\def\FULL{1}\input{cas-dc-template.tex}" >nul
if errorlevel 1 exit /b 1

echo.
echo [2/4] Building main only (no GA/highlights)... / 编译正文（不含图像摘要/Highlights）...
call xelatex -interaction=nonstopmode -jobname=cas-dc-template-without-abstract "\def\WITHOUTABSTRACT{1}\input{cas-dc-template.tex}" >nul
call bibtex cas-dc-template-without-abstract >nul
if errorlevel 1 exit /b 1
call xelatex -interaction=nonstopmode -jobname=cas-dc-template-without-abstract "\def\WITHOUTABSTRACT{1}\input{cas-dc-template.tex}" >nul
call xelatex -interaction=nonstopmode -jobname=cas-dc-template-without-abstract "\def\WITHOUTABSTRACT{1}\input{cas-dc-template.tex}" >nul
if errorlevel 1 exit /b 1

echo.
echo [3/4] Building graphical abstract only... / 编译仅图像摘要...
call xelatex -interaction=nonstopmode -jobname=cas-dc-template-graphical-abstract "\def\GRAPHICALONLY{1}\input{cas-dc-template.tex}" >nul
call xelatex -interaction=nonstopmode -jobname=cas-dc-template-graphical-abstract "\def\GRAPHICALONLY{1}\input{cas-dc-template.tex}" >nul
if errorlevel 1 exit /b 1

echo.
echo [4/4] Building highlights only... / 编译仅 Highlights...
call xelatex -interaction=nonstopmode -jobname=cas-dc-template-highlights "\def\HIGHLIGHTSONLY{1}\input{cas-dc-template.tex}" >nul
call xelatex -interaction=nonstopmode -jobname=cas-dc-template-highlights "\def\HIGHLIGHTSONLY{1}\input{cas-dc-template.tex}" >nul
if errorlevel 1 exit /b 1

echo.
echo ================================================================
echo Done. Generated PDFs: / 完成，生成 PDF：
echo   - cas-dc-template-full.pdf
echo   - cas-dc-template-without-abstract.pdf
echo   - cas-dc-template-graphical-abstract.pdf
echo   - cas-dc-template-highlights.pdf
echo ================================================================

echo.
echo [CLEAN] Removing aux files (keeping PDFs)... / 清理辅助文件（保留 PDF）...
for %%E in (aux bbl blg log out toc lof lot fls fdb_latexmk synctex.gz abs bcf run.xml) do (
  del /q "cas-dc-template-*.%%E" 2>nul
  del /q "cas-dc-template.%%E" 2>nul
)

echo [CLEAN] Done. / 清理完成。

echo.
echo To see full logs, remove ^>nul at line ends. / 如需查看完整日志，请去掉每行末尾的 ^>nul。

endlocal
exit /b 0
