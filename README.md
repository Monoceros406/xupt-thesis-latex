# 西安邮电大学本科毕业设计（论文）LaTeX 模板

本模板以《附件2：西安邮电大学毕业设计（论文）模板-安全.docx》**第 6 页起**对摘要、目录、正文、图表、结论、参考文献、致谢、附录的格式说明为权威依据，从零搭建，并参考了往届学长模板中成熟的实现细节。

> 范围说明：封面、承诺书、使用授权声明、选题审批表、开题报告、成绩评定表按学院要求自行准备并在前面追加；本模板不含封面，只负责**论文正文本体**（从摘要开始）。

仓库中现有的 `.tex` 正文均为**格式示例**，写自己的论文时请全部替换。

---

## 1. 环境准备

- **TeX 发行版**：TeX Live 2025（本机已验证）或 MiKTeX，需包含 `ctex`、`geometry`、`fancyhdr`、`titletoc`、`caption`、`subcaption`、`booktabs`、`amsmath`、`etoolbox`、`fancyvrb`、`listings`、`algorithm`、`algpseudocode`、`hyperref` 等宏包（TeX Live 完整安装自带）。
- **编译器**：必须使用 **XeLaTeX**，pdfLaTeX 无法编译中文。构建脚本已启用 `-shell-escape`（Mermaid 需要）。
- **Mermaid（可选）**：仅当论文中使用 Mermaid 图时需要 Node.js 和 Mermaid CLI：
  ```bash
  npm install -g @mermaid-js/mermaid-cli --registry=https://registry.npmmirror.com
  ```
  `build.bat` 会自动检测本机 Edge 并设为渲染浏览器；Linux/macOS 需系统装有 Chromium，或自行设置 `PUPPETEER_EXECUTABLE_PATH`。不使用 Mermaid 时无需安装。
- **字体**：工程自带 `fonts/` 目录，优先使用其中的字体，无需在本地安装：
  - 中文：`simsun.ttc`（宋体，正文）、`simhei.ttf`（黑体，标题与表题）。
  - 英文：`times.ttf` / `timesbd.ttf`（Times New Roman 常规/粗体）、`arial.ttf`（Arial）。
  - 若 `fonts/` 被删掉：Windows 自动回退到系统同名 Windows 字体；其他平台回退到 TeX Live 自带的 `fandol` 字体集。
  - 未放入楷体、Arial 粗体等本模板用不到的字体，以减小体积。

---

## 2. 目录结构

```
xupt-thesis-latex/
├── main.tex                  主文档：只做装配，一般不需要改格式
├── xuptthesis.cls            格式类文件：所有版式规则集中在这里
├── fonts/                    自带中英文字体（优先使用，勿随意删减）
├── frontmatter/
│   ├── abstract-cn.tex       中文摘要
│   ├── abstract-en.tex       英文摘要 ABSTRACT
│   └── toc.tex               目录
├── chapters/
│   ├── chapter1/chapter1.tex 第 1 章 绪论
│   ├── chapter2/chapter2.tex 第 2 章
│   └── chapter3/chapter3.tex 第 3 章
├── conclusion/conclusion.tex 结论（单独成页、限一页）
├── references/references.tex 参考文献（GB/T 7714）
├── acknowledgements/
│   └── acknowledgements.tex  致谢（单独成页、限一页）
├── appendix/
│   ├── appendixA.tex         附录 A
│   └── appendixB.tex         附录 B
├── images/                   图片目录（可自行放入 png/jpg/pdf 图片）
├── build.bat                 Windows 构建脚本
├── build.sh                  Linux / macOS 构建脚本
├── .gitignore                Git 忽略规则
└── README.md                 本说明
```

新增正文章节时，建议照此建立 `chapters/chapter4/chapter4.tex`，再在 `main.tex` 中加一行 `\input{chapters/chapter4/chapter4}`；不需要的章节把对应 `\input` 注释或删掉即可。

---

## 3. 编译方法

### Windows

直接双击根目录的 **`build.bat`**，或在终端执行：

```bat
build.bat
```

### Linux / macOS

```bash
chmod +x build.sh
./build.sh
```

### 构建脚本做了什么

1. 连续执行 **两次 `xelatex -shell-escape main.tex`**：第一次生成目录与交叉引用所需信息（同时渲染 Mermaid 图），第二次刷新目录页码和引用编号（即“目录生成两次”）。已验证两次编译结果与第三次完全一致。
2. 编译成功后清理中间文件：`aux`、`toc`、`lof`、`lot`、`out`、`bbl`、`blg`、`fls`、`fdb_latexmk`、`synctex.gz`、`synctex(busy)`、`tmp`，以及 Mermaid 临时文件 `xupt-mermaid-*.mmd` / `xupt-mermaid-*.pdf`。
3. **保留** `*.log`（主要是 `main.log`）和最终产物 `main.pdf`；失败时会在终端打印日志末尾 40 行便于排错。

如果手动编译，也必须运行两遍，并带上 `-shell-escape`；Windows 下还需先设置 Edge 路径：

```powershell
$env:PUPPETEER_EXECUTABLE_PATH='C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe'
xelatex -shell-escape main.tex
xelatex -shell-escape main.tex
```

---

## 4. 格式规则（已由 `xuptthesis.cls` 自动实现，正文不要手写字号行距）

| 项目      | 官方要求                                                                                 | 本模板实现                                                     |
| ------- | ------------------------------------------------------------------------------------ | --------------------------------------------------------- |
| 正文      | 小四（12pt），汉字宋体、英文 Times New Roman，固定行距 20pt，首行缩进 2 字，两端对齐，段前后 0pt                     | `\normalsize` = 12pt/20pt，`\parindent=2em`，`\parskip=0pt` |
| 章标题     | 黑体小三（15pt）居中，段前 40pt、段后 20pt，“第N章 + 1 汉字空 + 标题”                                      | `\chapter{…}` 自动生成“第1章 绪论”                                |
| 一级节标题   | 黑体四号（14pt）居左，段前 24pt、段后 6pt                                                          | `\section{…}`                                             |
| 二级节标题   | 黑体小四（12pt）居左，段前 12pt、段后 6pt                                                          | `\subsection{…}`                                          |
| 中文摘要    | 标题“摘  要”黑体小三居中 40/20；正文宋体小四 20pt；关键词 3~5 个、分号隔开、顶格黑体小四；单独成页、300~500 字、不出现图表          | `frontmatter/abstract-cn.tex`                             |
| 英文摘要    | 标题 Arial 小三居中 40/20；正文 Times New Roman 小四 20pt；Key words 顶格加粗小四；单独成页                 | `frontmatter/abstract-en.tex`                             |
| 目录      | 标题“目  录”黑体小三；章条目黑体小四、行前 6pt、行后 0；其余宋体小四；每下级缩进 2 个汉字；单独成页                             | `frontmatter/toc.tex`，`\titlecontents` 控制                 |
| 图       | 图题在图下方，宋体 11pt 居中，段前 6pt、段后 12pt；“图3.1  标题”按章编号；图内文字 9~10.5pt                        | `caption` 配置 + `\numberwithin{figure}{chapter}`           |
| 表       | 表题在表上方居中，黑体 11pt；表格**全文连续编号**；三线表，上下线 1.5pt、中线 1pt；单元格 11pt 宋体居中、单倍行距、段前后 3pt；表注宋体五号 | `booktabs` + `xuptthesis.cls` 中的表格设置                      |
| 公式      | 按章编号，形如 `(3-5)`                                                                      | `equation` 环境                                             |
| 页眉      | “西安邮电大学毕业设计（论文）”，宋体五号居中                                                              | 正文页自动添加，前置部分无页眉                                           |
| 页码      | 摘要/ABSTRACT/目录用罗马数字居中；正文起用阿拉伯数字从 1 开始居中                                              | `\xuptfrontmatter` / `\xuptmainmatter` 自动切换               |
| 结论 / 致谢 | 标题“结  论”“致  谢”黑体小三居中 40/20；各自单独成页且限一页；正文同正文格式                                        | `conclusion/` 、`acknowledgements/`                        |
| 参考文献    | 标题黑体小三居中；条目五号（10.5pt）宋体/Times，固定行距 16pt、段前 3pt，GB/T 7714 格式                          | `references/references.tex`                               |
| 附录      | “附  录 A + 标题”黑体小三居中 40/20；A、B、C…… 编号，另起页；附录内图 A.1、表 B.2、式 (C-3) 单独编号                 | `\xuptappendixchapter{标题}`                                |

页边距按官方 Word 模板自身的页面设置：A4，左右各 3cm、上下各 2cm。

---

## 5. 正文元素写法

### 标题层级

```latex
\chapter{绪论}              % 自动排成“第1章 绪论”
\section{研究背景与意义}     % 自动排成“1.1 研究背景与意义”
\subsection{研究背景}       % 自动排成“1.1.1 研究背景”
```

目录、页眉、编号全部自动生成；**不要在标题里手写“1.1”或“第1章”**。

### 图

图片放在 `images/`，建议文件名用英文：

```latex
\begin{figure}[htbp]
  \centering
  \includegraphics[width=0.75\linewidth]{images/arch.png}
  \caption{系统总体架构}
  \label{fig:arch}
\end{figure}

正文引用：如图~\ref{fig:arch} 所示。
```

### 表（三线表）

列格式用 `c`，单元格居中：

```latex
\begin{table}[htbp]
  \centering
  \caption{实验结果对比}
  \label{tab:result}
  \begin{tabular}{@{}ccc@{}}
    \toprule
    方法 & 准确率 & 召回率 \\
    \midrule
    方法 A & 90.1 & 88.5 \\
    \bottomrule
  \end{tabular}
\end{table}
```

需要表注时用 `threeparttable` 包裹 `tabular`，注文写在 `\begin{tablenotes}...\end{tablenotes}` 中。

### 公式

```latex
\begin{equation}
  E = mc^2
  \label{eq:mass}
\end{equation}
引用：式~\eqref{eq:mass}。
```

### 文献引用

```latex
深度学习方法已被广泛应用\cite{yuan2001}。
```

### 无编号一级标题

```latex
\xuptheading[结论]{结\hspace{2\ccwd}论}   % 进目录，带页眉
\xuptheading[致谢]{致\hspace{2\ccwd}谢}   % 进目录，带页眉
\xuptheadingnotoc{摘\hspace{2\ccwd}要}     % 不进目录、无页眉（前置部分）
```

`\xuptheading[目录标题]{显示标题}` 省略可选参数时，目录标题与显示标题相同。

### 附录

```latex
\xuptappendixchapter{核心配置参数}
```

每调用一次生成一个新附录（A、B、C……），自动另起页、进目录，并把附录内的图、表、公式编号重置为 `A.1`、`B.1`、`(C-3)` 形式。

---

## 6. 流程图、代码与伪代码

### Mermaid 流程图

Mermaid 图**当作图片使用**：在标准 `figure` 环境里写 `xuptmermaid` 环境，题注、编号、交叉引用与普通图片完全一致。源码直接写在 `.tex` 中，文本形式可 diff、可版本管理。

```latex
\begin{figure}[htbp]
  \centering
  \begin{xuptmermaid}[0.85\linewidth]
flowchart TD
  A[流量采集] --> B{重构误差大于阈值}
  B -->|是| C[触发告警]
  B -->|否| D[记录正常日志]
  \end{xuptmermaid}
  \caption{异常检测流程图}
  \label{fig:flow}
\end{figure}
```

- 可选参数是图片宽度（默认 `0.9\linewidth`），例如 `[0.7\textwidth]`。
- 也支持外部 `.mmd` 源文件：`\xuptmermaidfile[0.8\linewidth]{figures/flow.mmd}`。
- 中文标签可正常渲染；由 `mmdc` 输出矢量 PDF 后以 `\includegraphics` 插入，放大不失真。
- 需要 Node.js + `@mermaid-js/mermaid-cli`（见第 1 节），且必须用 `-shell-escape` 编译（构建脚本已处理）。Windows 下 `build.bat` 自动使用 Edge 作为渲染浏览器；Linux/macOS 需有 Chromium。
- 编译时生成的 `xupt-mermaid-*.mmd` / `*.pdf` 会在构建结束后自动删除；若 `mmdc` 不可用会给出明确错误提示。
- 未采用 CTAN 的 `ltmermaid` 包，因为它的shell脚本依赖 Unix 命令，在 Windows 下不能工作。

### 代码框（语法高亮）

基于 `listings`，提供等宽字体、行号、关键字/字符串/注释着色、浅灰底框与自动换行，按章编号“代码3-1”，题注在下方：

```latex
\begin{xuptcode}[language=Python,caption={异常检测核心逻辑},label={code:detect}]
def detect_anomaly(features, model, threshold):
    # 计算重构误差并判定异常
    reconstructed = model.predict(features)
    error = mean(abs(features - reconstructed))
    return error > threshold
\end{xuptcode}
```

正文引用：如代码 \ref{code:detect} 所示。

- `language=` 可用 `Python`、`C`、`C++`、`Java`、`JavaScript`、`LaTeX`、`Bash`、`SQL` 等 `listings` 支持的语言。
- 代码中的中文注释可正常显示；`caption` 与 `label` 可省略。
- 可选参数还可直接写 `listings` 键值，例如 `xleftmargin=2em`、`numbers=none`。
- 字体、颜色、边框等统一在 `xuptthesis.cls` 的 `xupt-code` 样式中修改。

### 伪代码

基于 `algorithm` + `algpseudocode`，自带“输入 / 输出 / 返回”中文标签与行号，按章编号“算法3-1”，题注在上方：

```latex
\begin{algorithm}[htbp]
  \caption{基于自编码器的异常检测算法}
  \label{alg:detect}
  \begin{algorithmic}[1]
    \Require 流量特征矩阵 $X$，判定阈值 $\theta$
    \Ensure 异常标签向量 $y$
    \For{$i = 1$ to $n$}
      \State $\hat{x}_i \gets \mathrm{Decoder}(\mathrm{Encoder}(x_i))$
      \If{$\|x_i - \hat{x}_i\|_2 > \theta$}
        \State $y_i \gets 1$
      \Else
        \State $y_i \gets 0$
      \EndIf
    \EndFor
    \State \Return $y$
  \end{algorithmic}
\end{algorithm}
```

如需把 `if` / `for` / `while` 等关键字也改成中文，在 `xuptthesis.cls` 中重定义对应的 `\algorithmicif`、`\algorithmicfor`、`\algorithmicwhile` 即可。

---

## 7. 参考文献怎么改

`references/references.tex` 中使用标准 `thebibliography` + `\bibitem`，条目按 GB/T 7714—2015 书写：

```latex
\begin{thebibliography}{99}
\bibitem{key1} 作者. 题名[J]. 期刊, 年, 卷(期): 起止页码.
\end{thebibliography}
```

`\bibitem{key1}` 中的 `key1` 与正文 `\cite{key1}` 对应，编号 `[1]` 自动生成。模板示例直接取自附件 2 给出的文献样例。

本模板**默认不启用 biber/bibtex**，这样 `build.bat` 只需 XeLaTeX 两遍即可完成构建；如果确实要用 `.bib` 文件，可自行在类文件中接入 `biblatex`，并相应修改构建脚本加入 `biber` 步骤。

---

## 8. 常见问题

- **目录或引用显示 `??`**：说明只编译了一遍，重新运行 `build.bat` / `build.sh`。
- **Mermaid 图不显示 / 报 `Mermaid 渲染失败`**：确认用 `-shell-escape` 编译、已安装 `mmdc`，且浏览器可用（Windows 下 `build.bat` 自动设 Edge；Linux 下可设置 `PUPPETEER_EXECUTABLE_PATH`）。查看 `main.log` 中 `runsystem(mmdc ...)` 一行。
- **`-shell-escape` 安全说明**：它允许 LaTeX 执行外部命令，请只编译自己信任的 `.tex` 源文件。
- **编译失败**：终端会显示 `main.log` 末尾 40 行，完整信息见 `main.log`；最常见的是图片路径写错或数学环境未闭合。
- **`Overfull \hbox` 警告**：多为目录点线或长英文单词导致，轻微溢出可忽略。
- **表格想按章编号**（官方默认全文连续，不推荐改）：把 `main.tex` 中的 `\documentclass[…]{xuptthesis}` 加上 `tabchapter` 选项。
- **想调整页边距 / 字号 / 行距**：统一修改 `xuptthesis.cls` 顶部的 `geometry`、`\normalsize`、`\ctexset` 等设置，不要在正文里局部手写 `\fontsize`。
- **在线平台编译**：必须以 XeLaTeX 编译；把整个工程打包 zip，保证 `main.tex` 位于 zip 最外层；工程已自带 `fonts/`，无需再复制字体，注意不要把 `fonts/` 从 zip 中漏掉。
- **结论、致谢超过一页**：官方要求限一页，请精简内容，模板不会自动截断。

---

## 9. 构建已验证

在本机 Windows + TeX Live 2025 + XeLaTeX 环境下，`build.bat` 已实测通过：两次编译成功，生成 13 页 `main.pdf`（不含封面）；日志确认宋体、黑体、Times New Roman、Arial 均从工程自带 `fonts/` 加载，无缺字警告；Mermaid 流程图、语法高亮代码框、伪代码均正常渲染，中文标签与注释无乱码；清理后根目录只保留 `main.log` 与 `main.pdf` 等构建产物和源文件。第 2 次与第 3 次编译的 PDF 文本完全一致，说明两次编译足够。
