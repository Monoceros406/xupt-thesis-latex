\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{xuptthesis}[2026/11/16 XUPT undergraduate thesis class]

% 可选参数：tabchapter  表格按章编号（默认按官方要求全文连续编号）
\newif\ifxupt@tabchaptertab
\DeclareOption{tabchapter}{\xupt@tabchaptertabtrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{ctexbook}}
\ProcessOptions\relax

\LoadClass[UTF8,scheme=chinese,punct=kaiming,zihao=-4,openany,oneside]{ctexbook}

\RequirePackage[a4paper,left=3cm,right=3cm,top=2cm,bottom=2cm,
  headheight=14.6pt,headsep=0.6cm,footskip=1.2cm]{geometry}
\RequirePackage{amsmath,amssymb}
\RequirePackage{bm}
\RequirePackage{graphicx}
\RequirePackage{fancyhdr}
\RequirePackage{titletoc}
\RequirePackage{caption}
\RequirePackage{subcaption}
\RequirePackage{booktabs}
\RequirePackage{array,tabularx,multirow,longtable,makecell,threeparttable}
\RequirePackage{enumitem}
\RequirePackage{float}
\RequirePackage{xcolor}
\RequirePackage{etoolbox}
\RequirePackage{fancyvrb}
\RequirePackage{listings}
\RequirePackage{algorithm,algpseudocode}
\RequirePackage{hyperref}

% ------------------------------------------------------------------
% 字体：优先用工程自带 fonts/，其次系统字体，最后保留 ctex 默认字体集
% ------------------------------------------------------------------
\newif\ifxupt@bundledfonts
\IfFileExists{fonts/simsun.ttc}{\xupt@bundledfontstrue}{\xupt@bundledfontsfalse}
\ifxupt@bundledfonts
  \setCJKfamilyfont{zhsong}{simsun.ttc}[Path=fonts/,FontIndex=0,BoldFont=simhei.ttf]
  \setCJKfamilyfont{zhhei}{simhei.ttf}[Path=fonts/]
  \setCJKmainfont{simsun.ttc}[Path=fonts/,FontIndex=0,BoldFont=simhei.ttf]
  \setCJKsansfont{simhei.ttf}[Path=fonts/]
  \setCJKmonofont{simsun.ttc}[Path=fonts/,FontIndex=0]
\else
  \IfFontExistsTF{SimSun}{%
    \setCJKfamilyfont{zhsong}{SimSun}[BoldFont=SimHei]
    \setCJKfamilyfont{zhhei}{SimHei}
    \setCJKmainfont{SimSun}[BoldFont=SimHei]
    \setCJKsansfont{SimHei}
  }{}%
\fi
\providecommand*{\songti}{}\providecommand*{\heiti}{}
\renewcommand*{\songti}{\CJKfamily{zhsong}}
\renewcommand*{\heiti}{\CJKfamily{zhhei}}
\IfFileExists{fonts/times.ttf}%
  {\setmainfont{times.ttf}[Path=fonts/,BoldFont=timesbd.ttf]}%
  {\IfFontExistsTF{Times New Roman}{\setmainfont{Times New Roman}}{}}
\IfFileExists{fonts/arial.ttf}%
  {\setsansfont{arial.ttf}[Path=fonts/]}%
  {\IfFontExistsTF{Arial}{\setsansfont{Arial}}{}}
\xeCJKsetup{CJKecglue={\hskip 0pt plus 0.1em}}

% ------------------------------------------------------------------
% 正文：小四号 12pt、固定行距 20pt、首行缩进 2 字、段前后 0pt
% ------------------------------------------------------------------
\linespread{1}
\renewcommand{\normalsize}{\fontsize{12pt}{20pt}\selectfont}
\AtBeginDocument{%
  \normalsize
  \setlength{\parindent}{2em}%
  \setlength{\parskip}{0pt}%
}

% ctex 默认会在中文与数字之间加空隙，这里压紧
\renewcommand{\bibname}{参考文献}
\renewcommand{\contentsname}{目\hspace{2\ccwd}录}

% ------------------------------------------------------------------
% 标题：章 黑体小三居中 40/20；节 黑体四号居左 24/6；小节 黑体小四 12/6
% ------------------------------------------------------------------
\ctexset{
  chapter={
    name={第,章},
    number=\arabic{chapter},
    aftername=\hspace{1\ccwd},
    format={\centering\heiti\fontsize{15pt}{20pt}\selectfont},
    beforeskip=40pt,
    afterskip=20pt
  },
  section={
    number=\thechapter.\arabic{section},
    aftername=\hspace{1\ccwd},
    format={\raggedright\parindent=0pt\heiti\fontsize{14pt}{20pt}\selectfont},
    beforeskip=24pt,
    afterskip=6pt
  },
  subsection={
    number=\thechapter.\arabic{section}.\arabic{subsection},
    aftername=\hspace{1\ccwd},
    format={\raggedright\parindent=0pt\heiti\fontsize{12pt}{20pt}\selectfont},
    beforeskip=12pt,
    afterskip=6pt
  }
}

% ------------------------------------------------------------------
% 目录：章 黑体小四 + 行前 6pt；其余宋体小四；每级缩进 2 个汉字
% ------------------------------------------------------------------
\setcounter{tocdepth}{2}
\setcounter{secnumdepth}{2}
\titlecontents{chapter}[0pt]
  {\addvspace{6pt}\heiti\fontsize{12pt}{20pt}\selectfont}
  {\thecontentslabel\hspace{1\ccwd}}{}
  {\titlerule*[6pt]{.}\contentspage}
\titlecontents{section}[2\ccwd]
  {\songti\fontsize{12pt}{20pt}\selectfont}
  {\thecontentslabel\hspace{1\ccwd}}{}
  {\titlerule*[6pt]{.}\contentspage}
\titlecontents{subsection}[4\ccwd]
  {\songti\fontsize{12pt}{20pt}\selectfont}
  {\thecontentslabel\hspace{1\ccwd}}{}
  {\titlerule*[6pt]{.}\contentspage}

% ------------------------------------------------------------------
% 图 / 表 / 公式编号与题注
% ------------------------------------------------------------------
\numberwithin{figure}{chapter}
\renewcommand{\thefigure}{\thechapter.\arabic{figure}}
\counterwithout{table}{chapter}
\renewcommand{\thetable}{\arabic{table}}
\numberwithin{equation}{chapter}
\renewcommand{\theequation}{\thechapter-\arabic{equation}}

\DeclareCaptionFont{xupthei}{\heiti\fontsize{11pt}{13.2pt}\selectfont}
\DeclareCaptionFont{xuptsong}{\songti\fontsize{11pt}{13.2pt}\selectfont}
\DeclareCaptionLabelFormat{xuptgap}{#1#2}
\captionsetup{labelformat=xuptgap,labelsep=quad,justification=centering,skip=0pt}
\captionsetup[figure]{position=bottom,aboveskip=6pt,belowskip=12pt,
  font={xuptsong},labelfont={xuptsong}}
\captionsetup[table]{position=top,aboveskip=6pt,belowskip=6pt,
  font={xupthei},labelfont={xupthei}}

% 三线表：上下线 1.5pt、中线 1pt；表内 11pt 宋体居中、单倍行距
\setlength{\heavyrulewidth}{1.5pt}
\setlength{\lightrulewidth}{1pt}
\setlength{\cmidrulewidth}{1pt}
\setlength{\extrarowheight}{3pt}
\AtBeginEnvironment{tabular}{\songti\fontsize{11pt}{13.2pt}\selectfont}
\AtBeginEnvironment{tabularx}{\songti\fontsize{11pt}{13.2pt}\selectfont}
\AtBeginEnvironment{longtable}{\songti\fontsize{11pt}{13.2pt}\selectfont}

% ------------------------------------------------------------------
% 页眉页脚：正文页眉宋体五号居中、页码居中；前置部分无页眉罗马页码
% ------------------------------------------------------------------
\fancypagestyle{plain}{%
  \fancyhf{}%
  \fancyhead[C]{\songti\zihao{5}西安邮电大学毕业设计（论文）}%
  \fancyfoot[C]{\zihao{-5}\thepage}%
  \renewcommand{\headrulewidth}{0pt}%
  \renewcommand{\footrulewidth}{0pt}%
}
\fancypagestyle{xuptfront}{%
  \fancyhf{}%
  \fancyfoot[C]{\zihao{-5}\thepage}%
  \renewcommand{\headrulewidth}{0pt}%
  \renewcommand{\footrulewidth}{0pt}%
}
\pagestyle{plain}

\newcommand{\xuptfrontmatter}{%
  \cleardoublepage
  \pagenumbering{Roman}%
  \pagestyle{xuptfront}%
}
\newcommand{\xuptmainmatter}{%
  \cleardoublepage
  \pagenumbering{arabic}%
  \setcounter{page}{1}%
  \pagestyle{plain}%
}

% ------------------------------------------------------------------
% 参考文献：五号 10.5pt、固定行距 16pt、段前 3pt
% ------------------------------------------------------------------
\AtBeginEnvironment{thebibliography}{%
  \songti\fontsize{10.5pt}{16pt}\selectfont
  \setlength{\parindent}{0pt}%
}
\apptocmd{\thebibliography}{%
  \setlength{\itemsep}{3pt}%
  \setlength{\parsep}{0pt}%
  \setlength{\parskip}{0pt}%
  \setlength{\topsep}{0pt}%
  \setlength{\labelsep}{0pt}%
}{}{}

% ------------------------------------------------------------------
% 常用命令：无编号一级标题、附录
% \xuptheading[目录标题]{显示标题}  目录标题省略时与显示标题相同
% \xuptheadingnotoc{显示标题}       不进目录（摘要、ABSTRACT、目录）
% ------------------------------------------------------------------
\newcommand{\xuptheading}[2][]{%
  \cleardoublepage
  \chapter*{#2}%
  \ifblank{#1}{\addcontentsline{toc}{chapter}{#2}}{\addcontentsline{toc}{chapter}{#1}}%
}
\newcommand{\xuptheadingnotoc}[1]{%
  \cleardoublepage
  \chapter*{#1}%
  \thispagestyle{xuptfront}%
}

\newcommand{\xuptappendixstart}{%
  \appendix
  \counterwithin{table}{chapter}%
  \renewcommand{\thetable}{\thechapter.\arabic{table}}%
}
\newcommand{\xuptappendixchapter}[1]{%
  \cleardoublepage
  \refstepcounter{chapter}%
  \chapter*{附\hspace{2\ccwd}录\hspace{1\ccwd}\Alph{chapter}\hspace{1\ccwd}#1}%
  \addcontentsline{toc}{chapter}{附录\hspace{1\ccwd}\Alph{chapter}\hspace{1\ccwd}#1}%
}

% ------------------------------------------------------------------
% 代码框：listings 语法高亮，按章编号“代码 3-1”
% ------------------------------------------------------------------
\lstdefinestyle{xupt-code}{
  basicstyle=\ttfamily\fontsize{9.5pt}{13pt}\selectfont,
  keywordstyle=\color{blue!70!black}\bfseries,
  commentstyle=\color{gray!90}\itshape,
  stringstyle=\color{red!70!black},
  numberstyle=\tiny\color{gray!80},
  numbers=left,numbersep=7pt,
  frame=single,rulecolor=\color{gray!65},
  backgroundcolor=\color{gray!3},
  xleftmargin=1.6em,framexleftmargin=1.1em,
  captionpos=b,breaklines=true,tabsize=4,
  extendedchars=true,showstringspaces=false,
  aboveskip=8pt,belowskip=8pt
}
\lstset{style=xupt-code}
\lstnewenvironment{xuptcode}[1][]{\lstset{style=xupt-code,#1}}{}
\renewcommand{\lstlistingname}{代码}
\AtBeginDocument{%
  \@ifundefined{c@lstlisting}{\newcounter{lstlisting}}{}%
  \renewcommand{\thelstlisting}{\thechapter-\arabic{lstlisting}}%
}

% ------------------------------------------------------------------
% 伪代码：algorithm + algpseudocode，按章编号“算法 3-1”
% ------------------------------------------------------------------
\floatname{algorithm}{算法}
\numberwithin{algorithm}{chapter}
\renewcommand{\thealgorithm}{\thechapter-\arabic{algorithm}}
\renewcommand{\algorithmicrequire}{\textbf{输入：}}
\renewcommand{\algorithmicensure}{\textbf{输出：}}
\renewcommand{\algorithmicreturn}{\textbf{返回}}
\captionsetup[algorithm]{position=above,labelsep=quad}

% ------------------------------------------------------------------
% Mermaid：环境内写 mermaid 源码，调用 mmdc 渲染为 PDF 后当作图片插入
% 需要 xelatex -shell-escape，以及可执行的 mmdc
% ------------------------------------------------------------------
\newcounter{xuptmermaid}
\newcommand{\xuptmermaid@runner}[3]{%
  \immediate\write18{mmdc -i "#1" -o "#2.pdf" -b transparent #3}%
  \IfFileExists{#2.pdf}{}{%
    \PackageError{xuptthesis}{Mermaid 渲染失败：未生成 #2.pdf}{%
      请用 xelatex -shell-escape 编译，并确认 mmdc 可用；详见 README。}%
  }%
}
\newenvironment{xuptmermaid}[1][0.9\linewidth]{%
  \def\xuptmermaid@width{#1}%
  \stepcounter{xuptmermaid}%
  \edef\xuptmermaid@base{xupt-mermaid-\arabic{xuptmermaid}}%
  \edef\xuptmermaid@in{\xuptmermaid@base.mmd}%
  \VerbatimOut{\xuptmermaid@in}%
}{%
  \endVerbatimOut
  \xuptmermaid@runner{\xuptmermaid@in}{\xuptmermaid@base}{}%
  \begin{center}%
    \includegraphics[width=\xuptmermaid@width]{\xuptmermaid@base.pdf}%
  \end{center}%
}
\newcommand{\xuptmermaidfile}[2][0.9\linewidth]{%
  \stepcounter{xuptmermaid}%
  \edef\xuptmermaid@base{xupt-mermaid-\arabic{xuptmermaid}}%
  \xuptmermaid@runner{\detokenize{#2}}{\xuptmermaid@base}{}%
  \begin{center}%
    \includegraphics[width=#1]{\xuptmermaid@base.pdf}%
  \end{center}%
}

% 首次编译时把未定义引用显示为等宽的数字占位符，避免因 “??” 比真实编号宽
% 而导致浮动体位置在第二次编译时变化（保证两遍编译即可收敛）
\makeatletter
\patchcmd{\@setref}{\reset@font\bfseries ??}{\reset@font\bfseries 0}{}{}
\makeatother

\hypersetup{colorlinks=false,hidelinks,bookmarksnumbered,pdfusetitle}

\endinput
