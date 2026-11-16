@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"

echo ============================================================
echo  西安邮电大学本科毕业设计（论文）LaTeX 模板 - Windows 构建
echo ============================================================

where xelatex >nul 2>nul
if errorlevel 1 (
  echo [错误] 未找到 xelatex，请先安装 TeX Live 或 MiKTeX 并加入 PATH。
  exit /b 1
)

rem 让 Mermaid CLI 使用本机 Edge，避免额外下载 Chromium
if exist "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" (
  set "PUPPETEER_EXECUTABLE_PATH=C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
)
where mmdc >nul 2>nul
if errorlevel 1 echo [提示] 未检测到 mmdc；若正文用了 Mermaid 图请先安装 @mermaid-js/mermaid-cli。

echo [1/2] 第一次编译：生成目录、交叉引用与 Mermaid 图 ...
xelatex -shell-escape -interaction=nonstopmode -halt-on-error -file-line-error main.tex >nul 2>&1
if errorlevel 1 goto :failed

echo [2/2] 第二次编译：刷新目录与引用 ...
xelatex -shell-escape -interaction=nonstopmode -halt-on-error -file-line-error main.tex >nul 2>&1
if errorlevel 1 goto :failed

echo 清理中间文件（保留 *.log 与 main.pdf）...
del /q *.aux *.toc *.lof *.lot *.out *.bbl *.blg *.fls *.fdb_latexmk *.synctex.gz *.tmp 2>nul
del /q xupt-mermaid-*.mmd xupt-mermaid-*.pdf 2>nul
del /q "*.synctex(busy)" 2>nul

if not exist main.pdf (
  echo [错误] main.pdf 未生成，请查看 main.log。
  exit /b 1
)

echo [完成] 已生成 main.pdf。
exit /b 0

:failed
echo [错误] 编译失败！以下是 main.log 末尾内容：
if exist main.log powershell -NoProfile -Command "Get-Content main.log -Tail 40"
exit /b 1
