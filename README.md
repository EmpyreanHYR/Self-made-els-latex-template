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
├── .latexmkrc                       # 默认双盲正文；ELS_BUILD_ALL=1 显式构建五版本
├── .gitignore
├── texfiles/                       # 本地辅助 TeX 文件，投稿不上传
│   ├── cas-author-export.tex        # 作者 TXT 导出
│   ├── cas-orcid.tex                # ORCID 图标扩展
│   └── els-local.tex                # 本地配置，自动创建且被 Git 忽略
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
├── compile_all.bat                  # 一键生成五 PDF、Highlights Word、作者 TXT（BAT）
├── compile_all.command              # macOS 双击生成五 PDF、Highlights Word、作者 TXT
├── example-images/                 # 模板示例素材，不作为正式稿件上传
│   ├── simple-png.png               # 示例正文图片
│   ├── ga-figure.pdf                # 示例图像摘要
│   └── README.md
├── doc/                             # 官方模版指南文档
└── thumbnails/                      # CAS 作者联系/社交图标（按环境需求提供）
```

> `*.aux/.log/.bbl/.fdb_latexmk/.fls` 等编译中间文件，以及 `cas-dc-template-main-{full,without-abstract,blind,graphical-abstract,highlights}.tex` 版本入口文件，均由 latexmk 自动生成（版本入口已加入 `.gitignore`），无需手工维护。

## 三、使用方法

首次本地写作，直接双击 `compile_all.command`（macOS）或 `compile_all.bat`（Windows）。如果没有 `texfiles/els-local.tex`，脚本自动创建它，只设置本地 ORCID 图标偏好；如果已有配置，则保持原文件不变。匿名状态统一由主文件控制，旧本地配置中的 `\BLINDtrue` / `\BLINDfalse` 不再覆盖主文件。

旧项目根目录中的 `els-local.tex` 请移至 `texfiles/els-local.tex`，保留原有配置。

仅使用编辑器或在线 TeX 项目时，可以先创建 `texfiles/` 目录，再新建 `texfiles/els-local.tex`，写入以下设置；已有配置不需要重新创建：

```tex
\ORCIDicontrue
```

主文件顶部默认 `\BLINDtrue`，直接编译即为双盲模式：不读取作者文件、不加载 ORCID 增强，隐藏作者、单位、邮箱、资助脚注与 CRediT。即使本地配置仍有旧的 `\BLINDfalse`，也不会把作者重新显示出来。需要作者检查稿时，将这一行改为 `\BLINDfalse`，或使用显式非双盲版本入口及一键构建程序。

主文件顶部的“用户填写区”集中管理标题、页眉短标题、页眉短作者、关键词、资助说明、图像摘要文件名，以及匿名、输出版本和 ORCID 选项。日常填写无需在宏包配置和排版逻辑之间寻找；详细作者、摘要、Highlights、正文仍分别维护在原有分文件中。

输出版本只需修改 `\newcommand{\PaperOutput}{body}` 中的值：

| 值 | 输出内容 |
|---|---|
| `body`（默认） | 正文与文字摘要，无图像摘要和 Highlights |
| `full` | 正文、文字摘要、图像摘要和 Highlights |
| `graphical` | 仅图像摘要 |
| `highlights` | 仅 Highlights |

输出内容与匿名开关独立；`\BLINDtrue` 隐藏作者信息，`\BLINDfalse` 显示作者信息。显式版本入口与一键构建继续覆盖顶部默认设置，保持原有五版本行为。

关键词在 `\PaperKeywords` 中用 `\sep` 分隔；`\PaperFunding` 无资助时设为 `{}`，模板自动省略资助脚注及标记。图像摘要文件名只在 `\PaperGraphicalAbstract` 中填写一次，供完整稿和独立图像摘要共用。ORCID 的顶部默认偏好仍可被本地配置覆盖。

本地配置中的 `\ORCIDicontrue` / `\ORCIDiconfalse` 仅选择图标/原生脚注。该文件在 `\documentclass` 前读取，已被 Git 忽略，投稿不上传。

```bash
# 日常预览
latexmk -pdf cas-dc-template-main.tex

# macOS / Linux：显式构建原有五种 PDF
ELS_BUILD_ALL=1 latexmk -pdf cas-dc-template-main.tex

# 只编译双盲版本；版本入口由 .latexmkrc 自动生成
latexmk -pdf cas-dc-template-main-blind.tex
```

Windows CMD 全量构建（此设置在当前终端持续生效，用 `set ELS_BUILD_ALL=` 清除）：

```bat
set ELS_BUILD_ALL=1 && latexmk -pdf cas-dc-template-main.tex
```

Windows PowerShell：

```powershell
$env:ELS_BUILD_ALL = '1'
latexmk -pdf cas-dc-template-main.tex
Remove-Item Env:ELS_BUILD_ALL
```

主文件命名仍须为 `*-main.tex`，目录中只能有一个这样的主文件。版本入口的旧内容会自动更新；内容相同时不重写。生成入口不能手工编辑；检测到没有生成标记的同名文件时会停止，保护手写内容。

| 产物（`{base}` 为不含扩展名的主文件名） | 内容与匿名状态 |
|---|---|
| `{base}.pdf` | 默认双盲正文（含文字摘要，无 GA/Highlights）；主文件开关控制匿名和内容 |
| `{base}-full.pdf` | 强制显示作者；正文、文字摘要、GA、Highlights |
| `{base}-without-abstract.pdf` | 强制显示作者；正文与文字摘要，无 GA/Highlights |
| `{base}-blind.pdf` | 强制双盲；正文与文字摘要，无 GA/Highlights |
| `{base}-graphical-abstract.pdf` | 仅 GA；构建明确使用非匿名模式 |
| `{base}-highlights.pdf` | 仅 Highlights；构建明确使用非匿名模式 |

历史名称 `without-abstract` 保持兼容，**仍有文字摘要**。匿名优先级为：显式 `\BLIND` 标志 > 构建器 `\ELSShowAuthors` > 主文件顶部开关；本地配置不控制匿名。full/without-abstract 始终显示作者，blind 始终匿名，其余输出版本的内容保持不变。

### 双击一键生成五 PDF、Highlights Word 和作者 TXT

**macOS**：安装 MacTeX（提供 pdfLaTeX / BibTeX）和 Python 3.8 或更新版本，在 Finder 双击 `compile_all.command`。它会在 Terminal 中进入脚本所在目录，生成原有五种 PDF、`{base}-highlights.docx` 和 `{base}-authors.txt`。不依赖独立 PS1、Python 脚本、Word 或额外 Python 包；即使 Finder 的 PATH 不包含 MacTeX，也会补充 `/Library/TeX/texbin`。

脚本已经设置可执行权限。若下载 ZIP 后权限丢失，首次运行：

```bash
chmod +x compile_all.command
```

若 macOS 阻止运行，请在 Finder 中右键选择“打开”，按系统提示允许；仍受系统策略阻止时，可在 Terminal 运行 `bash compile_all.command`。

**Windows**：安装并配置好 pdfLaTeX、BibTeX 和 Windows PowerShell，双击 `compile_all.bat`。Word 生成代码已完整内嵌 BAT，不需要外部 `make_highlights_docx.ps1`，也不需要 Python 或 Microsoft Word。独立 PS1 文件已移除，只需双击 BAT。

两个入口均无需设置 `ELS_BUILD_ALL`，双击后会自动完成，不要求额外按键，也无需传入 `--no-pause`。

每次一键编译都会重新生成 Highlights PDF 和 Word：二者共用 `0.Highlights.tex`，Word 标题从主文件填写区的 `\newcommand{\PaperTitle}{...}` 提取（兼容旧版直接填写 `\title{...}`）。Word 支持每行一条 `\item`、简单 `\textbf` / `\emph` / `\textit`、转义符号和 UTF-8 文本；它是简单文本转换器，复杂 LaTeX 命令和数学公式不保证原样排版。

失败会停止构建并保留日志，旧 Word 在新 DOCX 写完前不会被替换。PDF 失败时检查 `*-run.log` / `*-bibtex.log`；成功后清理五个构建产物的中间文件与日志，保留 PDF / DOCX。

### 输出元数据与作者信息 TXT

`.command` / `.bat` 一键构建，以及 `ELS_BUILD_ALL=1` 或显式版本入口的 latexmk 构建，会清理 PDF 内部的 Author/Title/Subject/Keywords 元数据、Creator/Producer、编译日期、PTEX 版本信息与 trailer ID。Word 不写入作者、路径等属性，ZIP 内部时间固定。成功时删除五个作业的中间文件与日志；失败时保留日志用于排错。普通直接编译主文件不启用这项一键元数据清理。

清理针对输出文件内部元数据，不删除正文中可见的作者信息，也不改变操作系统的文件写入时间。非双盲 PDF 仍显示真实作者；双盲 PDF 不读取作者文件。上传源文件时不要选择本地配置、日志和生成的 TXT。

作者 TXT 导出实现位于可选的 `texfiles/cas-author-export.tex`，仅在定义 `\ELSExportAuthors` 且为非双盲模式时加载；普通编译和双盲投稿不依赖此文件。一键程序会启用该模块，从 `1.Author.tex` 导出 `{base}-authors.txt`，按 `\author` 的声明顺序分块呈现：姓名、完整单位地址、邮箱、ORCID、通讯作者状态，以及已填写的头衔、角色、学位、CRediT 和个人 URL。多个单位、多个邮箱用分号分隔，单位按该作者引用的标签顺序排列。支持 `\address` 与 `\affiliation`，宏、换行和注释由 LaTeX 本身处理，无需独立解析脚本。

缺失字段写为 `Not provided`，找不到的单位标签标为 `UNRESOLVED affiliation [...]`，不会凭空补全。TXT 已加入 Git 忽略，仅用于填写投稿系统表单，**不要作为双盲稿件附件上传**。直接启用作者导出标志但处于双盲模式时，不生成作者 TXT，也不读取作者文件。

### 示例素材与自己的图片

模板示例正文图片和图像摘要已集中在 `example-images/`，不再混放在稿件根目录。该文件夹只用于预览示例，**正式投稿不要上传它或把示例图误当作自己的素材**。`thumbnails/` 保留 CAS 联系/社交图标，不是正文示例素材。

写自己的论文时，把自己的正文图片和图像摘要放在主文件所在目录，并在对应 `\includegraphics{...}` 中填写自己的文件名，例如 `my-figure.png`、`my-ga.pdf`。主文件的图片搜索顺序为根目录优先、示例文件夹其次，所以本地编译与投稿系统的同目录编译都能找到根目录中的真实图片，投稿前无需重新调整路径。保留原示例正文时，仍会读取原示例图片；请在写作时替换正文和素材引用。

若只是验证模板示例的投稿编译，单独把 `example-images/simple-png.png` 复制到上传目录根部，保持引用文件名不变；选择双盲正文模式时无需示例 GA。只有测试 full / GA-only 时，才需要同样复制 `example-images/ga-figure.pdf`。这是示例测试说明，不是正式稿件上传清单。

### 投稿上传清单

主文件默认已设置 `\BLINDtrue` 和 `\PaperOutput` 为 `body`，可直接作为双盲正文入口上传，无需投稿前修改开关。若曾为作者检查稿改为 `\BLINDfalse`，投稿前请恢复 `\BLINDtrue`。无需合并源文件，也无需提交本地增强或作者导出模块。

双盲正文源文件清单：

- `cas-dc-template-main.tex`（默认双盲正文模式）。
- `2.Abstract.tex`、`3.MainText.tex`。
- `cas-refs.bib`（系统支持/需要 BibTeX 源文件时）。
- 自己的正文图片和实际引用资源，与 TeX 文件放在同一目录。

此模式不需要 `1.Author.tex`、`0.Highlights.tex` 或 GA 图片。非双盲源稿设置 `\BLINDfalse`，增加 `1.Author.tex`；完整稿件另需 Highlights 内容与真实 GA 素材。不上传 ORCID 扩展时，非双盲稿退回官方 ORCID 脚注。若只上传 PDF，可直接选择一键生成的 `*-blind.pdf`。

Graphical Abstract / Highlights 仅在期刊要求独立附件或构建 full / GA-only / Highlights-only 时需要自己的图像摘要图片、`0.Highlights.tex` 等资源，按期刊要求上传对应 PDF/Word 附件。

**本地辅助文件与示例，不上传**：`example-images/`、`texfiles/`、`.latexmkrc`、`compile_all.bat`、`compile_all.command`、生成的 `*-authors.txt`、版本入口、测试脚本、日志及其他工具文件。

不能假定所有投稿系统都内置相同 CAS 版本、所需宏包、图标资源或支持 `.bib`。确认系统提供 `cas-dc.cls` / `cas-common.sty` 及正文依赖；否则按期刊要求提供。当前主文件使用 `elsarticle-num.bst`，仓库另附 `cas-model2-names.bst` 供选择。系统若只接受 `.tex` 而不接受引用数据库或图片，需另按期刊规定准备交付方案。本改造保证缺少自定义本地增强文件不会阻止基础编译。上传后仍应核对系统构建结果。

本地开发测试与验收记录保留在 `tests/`，已加入 `.gitignore`，不随仓库发布。macOS 已实际验证五 PDF 与 Word 生成；Windows 的 BAT 内嵌代码已静态核查，仍需 Windows 实机验证。

## 四、注意事项：

> 主文件须以 `-main` 结尾命名（如 `cas-dc-template-main.tex`），`compile_all.bat` 与 `.latexmkrc` 都会自动识别 `*-main.tex` 作为编译入口。主文件首行三条魔法注释确保编辑器使用 pdfLaTeX 编译、在主文件生成参考文献，并在分文件中编译时自动切回主文件：
>
> ```tex
> % !TEX program = pdflatex
> % !TEX root = cas-dc-template-main.tex
> % !BIB program = bibtex
> ```

> TeXstudio 4.8.9 (git 4.8.9)实测，选择 `*-main.tex` 构建PDF的过程中，不要切换到分文件，不然有可能导致编译失败。

> 匿名状态在 `\documentclass` 前确定；主文件顶部控制匿名，`texfiles/els-local.tex` 仅控制本地 ORCID 偏好；主文件默认双盲正文，直接编译无需作者文件，投稿按期刊要求选择审稿模式。

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

> **ORCID 可选增强**：在 `texfiles/els-local.tex` 设置 `\ORCIDicontrue` / `\ORCIDiconfalse`。非双盲且 `texfiles/cas-orcid.tex` 与 `orcidlink.sty` 均可用时，姓名旁显示可点击图标，不重复输出脚注。关闭图标或缺少任一依赖时回退官方 `ORCID(s)` 脚注；双盲不加载增强，也不读取作者文件。增强代码保留原作者算法，依赖 CAS 内部实现，升级 CAS 时应运行兼容性测试。

## 贡献者

衷心感谢为该模版优化改进的协作者！！！

<a href="https://github.com/EmpyreanHYR/Self-made-els-latex-template">
  <img src="https://contrib.rocks/image?repo=EmpyreanHYR/Self-made-els-latex-template" />
</a>

热烈欢迎更多协作者为模板的优化改进提出建议！

谢谢大家

## 📜 版权与使用说明

本仓库基于 Elsevier 官方 els-cas-templates 修改，官方核心模板文件（.cls / .sty）的版权归 Elsevier B.V. 所有，请遵循 Elsevier 的投稿指南使用。

作者原创的自动化脚本（.bat / .command）及排版控制逻辑，免费提供给科研人员进行个人学习和学术投稿使用。

代码按"原样"提供，不含任何明示或暗示的保证。因使用本脚本产生的任何投稿格式问题，请最终以期刊官方要求为准。
