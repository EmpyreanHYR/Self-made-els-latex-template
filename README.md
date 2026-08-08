**中文** | [English](README_EN.md)

# Self-made-els-latex-template

自制的爱思唯尔期刊Latex双栏版本

## 一、项目说明：

- 本项目基于Elsevier官网Latex模板(els-cas-templates.zip)。
- 针对 `cas-dc-template-main.tex` 文件内容进行了一定的改动以符合国人写作习惯。
- 本项目仅关注模版的优化，追求精简化，仅对必要的内容进行展示，更多排版内容，烦请自行检索网络资料或借助AI工具（强烈推荐)。

## 二、目录结构（由 `tree /F` 命令生成，已省略构建产物与工具目录）：

```text
.
├── .latexmkrc                       # latexmk 自定义规则：编辑器点一次“编译”即生成全部投稿 PDF
├── .gitignore
├── 0.Highlights.tex                 # Highlights 内容（PDF 与 Word 版共用，仅需维护一处）
├── 1.Author.tex                     # 作者、邮箱、单位和 CRediT 信息
├── 2.Abstract.tex                   # 摘要
├── 3.MainText.tex                   # 正文
├── README.md                        # 本文件（中文说明文档）
├── README_EN.md                     # English version of README
├── cas-common.sty                   # 用于格式化的附加宏包
├── cas-dc.cls                       # 双栏格式专用类文件
├── cas-dc-template-main.tex         # 主文件：稿件撰写模板（编译入口，含魔法注释）
├── cas-dc-template-main-*.pdf       # 编译生成的各版本 PDF
├── cas-model2-names.bst             # 参考文献的排版格式
├── cas-refs.bib                     # BibTeX 参考文献数据库
├── clean_latex.bat                  # 清理 LaTeX 编译过程文件
├── compile_all.bat                  # 一键生成 5 个 PDF + Highlights Word（bat 版）
├── doc/                             # 官方模版指南文档
├── ga-figure.pdf                    # 图像摘要示例图（放根目录适配投稿系统同目录编译）
├── make_highlights_docx.ps1         # 生成可编辑 Highlights Word 文件
├── simple-png.png                   # 示例图片
└── thumbnails/                      # 作者联系/社交图标（投稿系统内置，无需上传）
```

> `*.aux/.log/.bbl/.fdb_latexmk/.fls` 等编译中间文件，以及 `cas-dc-template-main-{full,without-abstract,blind,graphical-abstract,highlights}.tex` 版本入口文件，均由 latexmk 自动生成（已加入 `.gitignore`），无需手工维护。

## 三、使用方法：

- **主文件命名约定**：模板主文件须以 `-main` 结尾（如 `cas-dc-template-main.tex`），`compile_all.bat` 会自动扫描当前目录下的 `*-main.tex` 作为编译入口。
- 下载压缩包导入在线Tex编译器（例如：Overleaf，TeXPage），设置 `*-main.tex` 为编译主文件，采用 **pdfLaTeX** 方式编译即可。主文件首行的魔法注释会让大多数编辑器自动选择正确的编译方式：

  ```tex
  % !TEX program = pdflatex          % 编译器：pdfLaTeX
  % !TEX root = cas-dc-template-main.tex   % 主文件（在分文件中编译时自动切回主文件）
  % !BIB program = bibtex            % 参考文献：BibTeX
  ```
- 下载压缩包解压后，通过本地Tex编译器（例如：Tex Studio，配置好插件的VS Code）打开 `*-main.tex`，并将其作为编译主文件，采用 **pdfLaTeX** 方式编译即可。

> 请注意，即使作者信息、摘要、正文等内容是在分文件中进行撰写，但是运行编译还是要切换至 `*-main.tex` 进行编译，否则会报错。

- 投稿系统所需的文件（图像摘要/Highlights分离，支持双盲稿）

  Elsevier 投稿系统通常要求将“图像摘要（Graphical Abstract）”和“高光点（Highlights）”单独上传，部分期刊还要求双盲稿。本仓库通过**同一个主文件**配合编译规则实现一次生成5个 PDF（和1个可编辑 Word 文件）：

  - `{name}-full.pdf`：正文 + 图像摘要 + Highlights（完整版）
  - `{name}-without-abstract.pdf`：正文（不含图像摘要/Highlights）
  - `{name}-blind.pdf`：双盲正文（隐藏作者、单位、作者脚注、页脚作者名和 CRediT 信息）
  - `{name}-graphical-abstract.pdf`：仅图像摘要（独立文件，不含正文）
  - `{name}-highlights.pdf`：仅 Highlights（独立文件，不含正文）
  - `{name}-highlights.docx`：可编辑的 Word 版 Highlights（包含论文标题）

  Highlights 内容统一写在根目录的 `0.Highlights.tex` 中，PDF 和 Word 文件都会从这里读取，避免重复维护。作者、摘要、正文和图片也都放在根目录，方便投稿系统默认在同一目录下重新编译。

  **方式一（推荐）：latexmk 一键编译（在编辑器里点一次“编译”即可）**

  根目录的 `.latexmkrc` 利用 latexmk 的自定义规则处理多版本 PDF 生成：把编译工具配置为 latexmk（TeXstudio / VS Code LaTeX Workshop / TeXworks 均默认支持），打开 `*-main.tex` 按一次“编译”，即可**增量**生成上述 5 个 PDF：

  ```bat
  latexmk -pdf cas-dc-template-main.tex
  ```

  说明：`-main.tex` 会在项目根目录被自动识别（与 `compile_all.bat` 一致）；每次编译只有内容发生变化的版本会被重建，其余版本直接跳过；日常写作时建议在编辑器里直接编译 `*-main.tex` 的“正文版”。

  **方式二：compile_all.bat（Windows 一键脚本，额外生成 Highlights Word）**

  推荐用法（Windows，PowerShell 或 CMD 均可）：

  1) 确保已安装并配置好 LaTeX（MiKTeX/TeX Live），且 `pdflatex` 可在命令行直接运行。
  2) 将主文件命名为 `*-main.tex`（如 `my-paper-main.tex`），脚本会自动检测。
  3) 在项目根目录双击或运行：

  ```bat
  compile_all.bat
  ```

  说明：脚本会对每个版本运行两到三次 pdfLaTeX + BibTeX（避免交叉引用/目录等不完整），并额外调用 `make_highlights_docx.ps1` 生成可编辑的 Highlights Word 文件。

  如需排查编译错误：打开 `compile_all.bat`，把每行命令末尾的 `>nul` 去掉即可看到完整日志。

- **投稿系统（Editorial Manager 等）上传清单**：投稿系统只保留你上传的文件，请把下面“必传”内容全部上传（其余辅助文件无需上传）：

  **必传（源文件）**：

  - `cas-dc-template-main.tex` — 主文件（投稿系统以此为编译入口）
  - `0.Highlights.tex`、`1.Author.tex`、`2.Abstract.tex`、`3.MainText.tex` — 分文件
  - `cas-refs.bib` — 参考文献数据库

  **必传（图像）**：

  - `ga-figure.pdf` — 图像摘要（完整版/图像摘要版需要）
  - `simple-png.png` — 正文插图

  **投稿系统已内置、无需上传**：`cas-dc.cls`、`cas-common.sty`、`cas-model2-names.bst`、`thumbnails/` 图标文件夹（`cas-email.jpeg` 等）。

  **无需上传**：`.latexmkrc`、`compile_all.bat`、`make_highlights_docx.ps1`、`clean_latex.bat`、`README.md`、`README_EN.md`、`doc/`、已编译的 PDF、`cas-dc-template-main-{version}.tex` 版本入口文件。

  > 投稿系统一般会自动对主文件运行 pdfLaTeX + BibTeX 多遍编译；上传后请检查编译日志，确认无 `File '...' not found` 类错误。

## 四、注意事项：

> 主文件须以 `-main` 结尾命名（如 `cas-dc-template-main.tex`），`compile_all.bat` 与 `.latexmkrc` 都会自动识别 `*-main.tex` 作为编译入口。主文件首行三条魔法注释确保编辑器使用 pdfLaTeX 编译、在主文件生成参考文献，并在分文件中编译时自动切回主文件：
>
> ```tex
> % !TEX program = pdflatex
> % !TEX root = cas-dc-template-main.tex
> % !BIB program = bibtex
> ```

> TeXstudio 4.8.9 (git 4.8.9)实测，选择 `*-main.tex` 构建PDF的过程中，不要切换到分文件，不然有可能导致编译失败。

> 当前文稿考虑写作实际习惯和编译运行开销，默认输出**正文（不含图像摘要/Highlights）**。模板使用 LaTeX 内核 `\newif` 标准布尔变量作为版本开关，共五个：`\ifFULL`、`\ifWITHOUTABSTRACT`、`\ifGRAPHICALONLY`、`\ifHIGHLIGHTSONLY`、`\ifBLIND`（正文中配合 `\if...\else...\fi` 判断，无组副作用）。如需默认输出完整版，在 `*-main.tex` 顶部的“条件编译开关”处修改即可：
>
> ```tex
> \FULLtrue                   % 完整版（包含图像摘要和高光点）
> % \WITHOUTABSTRACTtrue      % 默认：正文版（无图像摘要/Highlights，日常写作更快）
> ```
>
> 脚本与命令行通过 `\def\XXX{1}\input{...}` 传参覆盖默认值（如 `compile_all.bat`、`.latexmkrc`），模板会自动将其翻译为对应布尔开关，因此无需修改源文件即可指定版本。
>
> 注意：`\ifBLIND` 双盲开关在 `\documentclass` 之前生效（用于选择 `doubleblind` 类选项），请通过命令行传入 `\def\BLIND{1}`（`compile_all.bat` / `.latexmkrc` 的 blind 版本即如此），或修改 `*-main.tex` 文件顶部第 4–6 行，不要在正文下方的开关块中设置。

> 使用 `\cref{}`索引图片，表格，公式，自动添加类型。

> 使用 `\cite{}`引用参考文献。

> 使用 `\lipsum[1-3]`能随机生成3段文本内容，可用于占位。

> 模板已预配置 `algorithm2e` 伪代码宏包（`[ruled,vlined]` 样式），`3.MainText.tex` 中包含完整使用示例供参考。

> CRediT（Contributor Roles Taxonomy，贡献者角色分类法），需在投稿时提供，发表后将置于论文的 “致谢（Acknowledgment）” 部分之前。
>
> | 英文术语                   | 英文定义                                                                                                                                                                                                      | 中文翻译                                                                                                                       |
> | -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
> | Conceptualization          | Ideas; formulation or evolution of overarching research goals and aims                                                                                                                                        | 概念构思；总体研究目标与宗旨的提出或完善                                                                                       |
> | Methodology                | Development or design of methodology; creation of models                                                                                                                                                      | 方法学；研究方法的开发或设计、模型构建                                                                                         |
> | Software                   | Programming, software development; designing computer programs; implementation of the computer code and supporting algorithms; testing of existing code components                                            | 软件；编程与软件开发、计算机程序设计、代码及配套算法的实现、现有代码组件的测试                                                 |
> | Validation                 | Verification, whether as a part of the activity or separate, of the overall replication/reproducibility of results/experiments and other research outputs                                                     | 验证；（作为研究活动的一部分或独立环节）对研究结果 / 实验及其他产出的可重复性进行核实                                          |
> | Formal analysis            | Application of statistical, mathematical, computational, or other formal techniques to analyze or synthesize study data                                                                                       | 正式分析；运用统计、数学、计算或其他正式技术对研究数据进行分析或综合                                                           |
> | Investigation              | Conducting a research and investigation process, specifically performing the experiments, or data/evidence collection                                                                                         | 研究实施；开展研究与调查过程，特指实验操作或数据 / 证据收集                                                                    |
> | Resources                  | Provision of study materials, reagents, materials, patients, laboratory samples, animals, instrumentation, computing resources, or other analysis tools                                                       | 资源支持；提供研究材料、试剂、样本、受试者、实验室样品、实验动物、仪器设备、计算资源或其他分析工具                             |
> | Data Curation              | Management activities to annotate (produce metadata), scrub data and maintain research data (including software code, where it is necessary for interpreting the data itself) for initial use and later reuse | 数据管理；为初始使用及后续复用而开展的注释（生成元数据）、数据清洗及研究数据（含解读数据所需的软件代码）维护等管理工作         |
> | Writing - Original Draft   | Preparation, creation and/or presentation of the published work, specifically writing the initial draft (including substantive translation)                                                                   | 撰写 - 初稿；已发表成果的准备、创作和 / 或呈现，特指初稿撰写（含实质性翻译）                                                   |
> | Writing - Review & Editing | Preparation, creation and/or presentation of the published work by those from the original research group, specifically critical review, commentary or revision – including pre- or post-publication stages  | 撰写 - 审阅与编辑；由原研究团队成员完成的已发表成果的准备、创作和 / 或呈现，特指批判性审阅、评论或修订（含出版前及出版后阶段） |
> | Visualization              | Preparation, creation and/or presentation of the published work, specifically visualization/data presentation                                                                                                 | 可视化；已发表成果的准备、创作和 / 或呈现，特指数据可视化 / 结果呈现                                                           |
> | Supervision                | Oversight and leadership responsibility for the research activity planning and execution, including mentorship external to the core team                                                                      | 监督指导；对研究活动的规划与执行承担监督及领导职责，包括核心团队之外的指导工作                                                 |
> | Project administration     | Management and coordination responsibility for the research activity planning and execution                                                                                                                   | 项目管理；对研究活动的规划与执行承担管理及协调职责                                                                             |
> | Funding acquisition        | Acquisition of the financial support for the project leading to this publication                                                                                                                              | 资金获取；为促成本研究成果发表的项目争取财务支持                                                                               |

> **ORCID 显示模式切换**：模板支持两种 ORCID 展示方式，在 `*-main.tex` 中改一行即可切换：
>
> ```tex
> \newif\ifORCIDicon
> \ORCIDicontrue    % 图标模式：ORCID 绿色图标显示在作者姓名旁（默认，推荐投稿使用）
> % \ORCIDiconfalse % 脚注模式：传统脚注模式（页面底部显示 ORCID(s): ...）
> ```
>
> - **图标模式**（默认）：ORCID 绿色矢量图标紧跟在每位作者姓名之后、单位上标之前。图标可点击跳转至 `https://orcid.org/`。处于图标模式时，页面底部不会出现脚注形式的 ORCID(s)。
> - **脚注模式**：与传统 Elsevier 模板一致，在首页底部以 `ORCID(s): 0000-... (Author Name)` 形式列出所有作者的 ORCID。切换方式：注释 `\ORCIDicontrue`，取消注释 `\ORCIDiconfalse`。

## 贡献者

衷心感谢为该模版优化改进的协作者！！！

<a href="https://github.com/EmpyreanHYR/Self-made-els-latex-template">
  <img src="https://contrib.rocks/image?repo=EmpyreanHYR/Self-made-els-latex-template" />
</a>

热烈欢迎更多协作者为模板的优化改进提出建议！

谢谢大家
