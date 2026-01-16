@echo off
setlocal EnableExtensions

REM 避免中文输出乱码（Windows 10/11 通常可用）
chcp 65001 >nul

REM ================================================================
REM 生成投稿所需 4 个 PDF（XeLaTeX）
REM - cas-dc-template-full.pdf                 正文 + 图像摘要 + Highlights
REM - cas-dc-template-without-abstract.pdf     正文（不含图像摘要/Highlights）
REM - cas-dc-template-graphical-abstract.pdf   仅图像摘要
REM - cas-dc-template-highlights.pdf           仅 Highlights
REM ================================================================

cd /d "%~dp0"

where xelatex >nul 2>nul
if errorlevel 1 (
  echo [ERROR] 找不到 xelatex。请先安装 MiKTeX/TeX Live，并确保 xelatex 在 PATH 中。
  exit /b 1
)

echo ================================================================
echo LaTeX 投稿 PDF 生成脚本（4 个版本）
echo 工作目录: %CD%
echo ================================================================

echo.
echo [1/4] 编译完整版 (FULL)...
call xelatex -interaction=nonstopmode -jobname=cas-dc-template-full "\def\FULL{1}\input{cas-dc-template.tex}" >nul
call xelatex -interaction=nonstopmode -jobname=cas-dc-template-full "\def\FULL{1}\input{cas-dc-template.tex}" >nul
if errorlevel 1 exit /b 1

echo.
echo [2/4] 编译正文版（无图像摘要/Highlights）...
call xelatex -interaction=nonstopmode -jobname=cas-dc-template-without-abstract "\def\WITHOUTABSTRACT{1}\input{cas-dc-template.tex}" >nul
call xelatex -interaction=nonstopmode -jobname=cas-dc-template-without-abstract "\def\WITHOUTABSTRACT{1}\input{cas-dc-template.tex}" >nul
if errorlevel 1 exit /b 1

echo.
echo [3/4] 编译仅图像摘要 (GRAPHICALONLY)...
call xelatex -interaction=nonstopmode -jobname=cas-dc-template-graphical-abstract "\def\GRAPHICALONLY{1}\input{cas-dc-template.tex}" >nul
call xelatex -interaction=nonstopmode -jobname=cas-dc-template-graphical-abstract "\def\GRAPHICALONLY{1}\input{cas-dc-template.tex}" >nul
if errorlevel 1 exit /b 1

echo.
echo [4/4] 编译仅 Highlights (HIGHLIGHTSONLY)...
call xelatex -interaction=nonstopmode -jobname=cas-dc-template-highlights "\def\HIGHLIGHTSONLY{1}\input{cas-dc-template.tex}" >nul
call xelatex -interaction=nonstopmode -jobname=cas-dc-template-highlights "\def\HIGHLIGHTSONLY{1}\input{cas-dc-template.tex}" >nul
if errorlevel 1 exit /b 1

echo.
echo ================================================================
echo 完成！生成的 PDF：
echo   - cas-dc-template-full.pdf
echo   - cas-dc-template-without-abstract.pdf
echo   - cas-dc-template-graphical-abstract.pdf
echo   - cas-dc-template-highlights.pdf
echo ================================================================

echo.
echo 如需查看错误日志，请去掉本脚本中每行命令末尾的 ^>nul。

endlocal
exit /b 0
