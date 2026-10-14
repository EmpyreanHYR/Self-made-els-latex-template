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
├── .latexmkrc                       # 日常预览；ELS_BUILD_ALL=1 显式构建五版本
├── .gitignore
├── cas-orcid.tex                    # 可选 ORCID 图标扩展，不上传
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
├── compile_all.command              # macOS 双击生成五 PDF + Highlights Word
├── example-images/                 # 模板示例素材，不作为正式稿件上传
│   ├── simple-png.png               # 示例正文图片
│   ├── ga-figure.pdf                # 示例图像摘要
│   └── README.md
├── doc/                             # 官方模版指南文档
└── thumbnails/                      # CAS 作者联系/社交图标（按环境需求提供）
```

> `*.aux/.log/.bbl/.fdb_latexmk/.fls` 等编译中间文件，以及 `cas-dc-template-main-{full,without-abstract,blind,graphical-abstract,highlights}.tex` 版本入口文件，均由 latexmk 自动生成（版本入口已加入 `.gitignore`），无需手工维护。

## 三、使用方法

首次本地写作，直接双击 `compile_all.command`（macOS）或 `compile_all.bat`（Windows）。如果没有 `els-local.tex`，脚本自动创建它，默认 `\BLINDfalse`、`\ORCIDicontrue`；如果已有配置，则保持原文件不变，不覆盖你的设置。此后编辑器直接编译主文件也能读取这份配置。

仅使用编辑器或在线 TeX 项目时，可以自行新建 `els-local.tex`，写入以下两行；已有配置不需要重新创建：

```tex
\BLINDfalse
\ORCIDicontrue
```

配置中 `\BLINDfalse` 显示作者，`\ORCIDicontrue` 优先使用可点击图标。该文件在 `\documentclass` 前读取，仅放布尔开关，已被 Git 忽略。查看双盲时将其改为 `\BLINDtrue`，或直接构建 blind 版本。不要把 `els-local.tex` 上传到投稿系统。

日常打开 `cas-dc-template-main.tex`，将编辑器构建工具设为 latexmk。普通构建只生成一份正文预览 `cas-dc-template-main.pdf`，保留文字摘要，不含图像摘要或 Highlights。匿名状态由本地配置控制；无本地配置时默认双盲。

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
| `{base}.pdf` | 日常正文预览；本地配置控制匿名 |
| `{base}-full.pdf` | 强制显示作者；正文、文字摘要、GA、Highlights |
| `{base}-without-abstract.pdf` | 强制显示作者；正文与文字摘要，无 GA/Highlights |
| `{base}-blind.pdf` | 强制双盲；正文与文字摘要，无 GA/Highlights |
| `{base}-graphical-abstract.pdf` | 仅 GA；构建明确使用非匿名模式 |
| `{base}-highlights.pdf` | 仅 Highlights；构建明确使用非匿名模式 |

历史名称 `without-abstract` 保持兼容，实际省略的是图像摘要和 Highlights，**仍有文字摘要**。匿名、输出版本与 ORCID 状态相互独立。优先级为：命令行 `\BLIND`（强制双盲） > 构建器 `\ELSShowAuthors`（显示作者） > 本地配置 > 无配置默认双盲。full 与 without-abstract 即使本地设置双盲也显示作者。

### 双击一键生成五 PDF 和 Highlights Word

**macOS**：安装 MacTeX（提供 pdfLaTeX / BibTeX）和 Python 3.8 或更新版本，在 Finder 双击 `compile_all.command`。它会在 Terminal 中进入脚本所在目录，生成原有五种 PDF 和 `{base}-highlights.docx`。不依赖独立 PS1、Python 脚本、Word 或额外 Python 包；即使 Finder 的 PATH 不包含 MacTeX，也会补充 `/Library/TeX/texbin`。

脚本已经设置可执行权限。若下载 ZIP 后权限丢失，首次运行：

```bash
chmod +x compile_all.command
```

若 macOS 阻止运行，请在 Finder 中右键选择“打开”，按系统提示允许；仍受系统策略阻止时，可在 Terminal 运行 `bash compile_all.command`。

**Windows**：安装并配置好 pdfLaTeX、BibTeX 和 Windows PowerShell，双击 `compile_all.bat`。Word 生成代码已完整内嵌 BAT，不需要外部 `make_highlights_docx.ps1`，也不需要 Python 或 Microsoft Word。独立 PS1 文件已移除，只需双击 BAT。

两个入口均无需设置 `ELS_BUILD_ALL`，双击后会自动完成，不要求额外按键，也无需传入 `--no-pause`。

每次一键编译都会重新生成 Highlights PDF 和 Word：二者共用 `0.Highlights.tex`，Word 标题从主文件的 `\title[mode = title]{...}` 提取。Word 支持每行一条 `\item`、简单 `\textbf` / `\emph` / `\textit`、转义符号和 UTF-8 文本；它是简单文本转换器，复杂 LaTeX 命令和数学公式不保证原样排版。

失败会停止构建并保留日志，旧 Word 在新 DOCX 写完前不会被替换。PDF 失败时检查 `*-run.log` / `*-bibtex.log`；成功后清理五个构建产物的中间文件与日志，保留 PDF / DOCX。

### 示例素材与自己的图片

模板示例正文图片和图像摘要已集中在 `example-images/`，不再混放在稿件根目录。该文件夹只用于预览示例，**正式投稿不要上传它或把示例图误当作自己的素材**。`thumbnails/` 保留 CAS 联系/社交图标，不是正文示例素材。

写自己的论文时，把自己的正文图片和图像摘要放在主文件所在目录，并在对应 `\includegraphics{...}` 中填写自己的文件名，例如 `my-figure.png`、`my-ga.pdf`。主文件的图片搜索顺序为根目录优先、示例文件夹其次，所以本地编译与投稿系统的同目录编译都能找到根目录中的真实图片，投稿前无需重新调整路径。保留原示例正文时，仍会读取原示例图片；请在写作时替换正文和素材引用。

若只是验证模板示例的投稿编译，单独把 `example-images/simple-png.png` 复制到上传目录根部，保持引用文件名不变；默认双盲正文无需示例 GA。只有测试 full / GA-only 时，才需要同样复制 `example-images/ga-figure.pdf`。这是示例测试说明，不是正式稿件上传清单。

### 投稿上传清单

向双盲期刊投稿时**不改主文件、不合并源文件**，不上传本地增强与配置。提供以下稿件源文件与自己的实际素材：

- `cas-dc-template-main.tex`（编译入口）。
- `2.Abstract.tex`、`3.MainText.tex`。
- `cas-refs.bib`（系统支持/需要 BibTeX 源文件时）。
- 自己的正文图片和其他实际引用资源，与 TeX 文件放在同一目录。

不提供 `1.Author.tex`、`0.Highlights.tex`、GA 图片也能编译默认双盲正文。对于**非双盲期刊**，在建立该期刊项目时一次性将主文件顶部默认值设为 `\BLINDfalse`，上传清单增加 `1.Author.tex`；省略本地配置不能自动推断期刊政策。非双盲投稿不带增强模块时使用 CAS 原生 ORCID 脚注。

Graphical Abstract / Highlights 仅在期刊要求独立附件或构建 full / GA-only / Highlights-only 时需要自己的图像摘要图片、`0.Highlights.tex` 等资源，按期刊要求上传对应 PDF/Word 附件。

**本地辅助文件与示例，不上传**：`example-images/`、`els-local.tex`、`cas-orcid.tex`、`.latexmkrc`、`compile_all.bat`、`compile_all.command`、生成的版本入口、测试脚本、日志及其他工具文件。

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

> 匿名状态在 `\documentclass` 前确定；日常设置放在 `els-local.tex`，版本输出通过上述构建入口选择，投稿主文件保持默认双盲正文。

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

> **ORCID 可选增强**：在 `els-local.tex` 设置 `\ORCIDicontrue` / `\ORCIDiconfalse`。非双盲且 `cas-orcid.tex` 与 `orcidlink.sty` 均可用时，姓名旁显示可点击图标，不重复输出脚注。关闭图标或缺少任一依赖时回退官方 `ORCID(s)` 脚注；双盲不加载增强，也不读取作者文件。增强代码保留原作者算法，依赖 CAS 内部实现，升级 CAS 时应运行兼容性测试。

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
