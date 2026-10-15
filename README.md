**中文** | [English](README_EN.md)

# Self-made-els-latex-template

基于 Elsevier 官方 `els-cas-templates` 的双栏 LaTeX 模板，提供集中填写区、双盲模式和一键多版本构建。

## 目录结构

```text
.
├── cas-dc-template-main.tex   # 编译入口；顶部填写稿件信息和编译选项
├── 0.Highlights.tex          # Highlights
├── 1.Author.tex              # 作者、邮箱、单位和 CRediT
├── 2.Abstract.tex            # 文字摘要
├── 3.MainText.tex            # 正文
├── cas-refs.bib              # 参考文献
├── cas-dc.cls                # 双栏文档类
├── cas-common.sty            # CAS 排版宏包
├── cas-model2-names.bst      # 可选参考文献样式
├── compile_all.command      # macOS 一键构建
├── compile_all.bat           # Windows 一键构建
├── clean_latex.bat           # Windows 编译缓存清理
├── .latexmkrc                # latexmk 构建配置
├── texfiles/                 # 本地配置、ORCID 增强及作者导出
├── example-images/           # 模板示例图片
├── thumbnails/               # CAS 联系与社交图标
└── doc/                      # 官方模板指南
```

## 填写稿件

在 `cas-dc-template-main.tex` 顶部的“用户填写区”设置：

| 配置 | 用途 |
|---|---|
| `\PaperTitle` | 文章标题 |
| `\PaperShortTitle` | 页眉短标题 |
| `\PaperShortAuthors` | 页眉短作者 |
| `\PaperKeywords` | 关键词，用 `\sep` 分隔 |
| `\PaperFunding` | 资助说明；无资助时留空 `{}` |
| `\PaperGraphicalAbstract` | 图像摘要文件名 |
| `\PaperOutput` | 输出内容，见下表 |

详细作者、摘要、Highlights 和正文分别在对应分文件中填写。自己的图片放在主文件所在目录，正文使用 `\includegraphics{文件名}` 引用。

### 双盲与输出版本

默认 `\BLINDtrue`：隐藏作者、单位、邮箱、资助脚注和 CRediT。需要显示作者时改为 `\BLINDfalse`。

输出内容独立于双盲开关，在 `\newcommand{\PaperOutput}{body}` 中选择：

| 值 | 输出内容 |
|---|---|
| `body`（默认） | 正文与文字摘要 |
| `full` | 正文、文字摘要、图像摘要和 Highlights |
| `graphical` | 仅图像摘要 |
| `highlights` | 仅 Highlights |

非双盲模式下，`\ORCIDicontrue` 显示 ORCID 图标，`\ORCIDiconfalse` 使用原生脚注；缺少图标依赖时自动使用脚注。本地偏好可写入 `texfiles/els-local.tex`，覆盖顶部 ORCID 设置。一键构建会自动创建该配置文件。

## 编译

### 一键构建

| 平台 | 运行要求 | 操作 |
|---|---|---|
| macOS | MacTeX、Python 3.8+ | 双击 `compile_all.command` |
| Windows | pdfLaTeX、BibTeX、Windows PowerShell | 双击 `compile_all.bat` |

两端均已完成实机验证。一键构建生成五种 PDF、Highlights Word 和作者 TXT，保存在项目目录。

macOS 若无法直接运行，可在终端执行：

```bash
bash compile_all.command
```

### 编辑器或命令行

编辑器选择 pdfLaTeX 编译主文件；使用 latexmk 时：

```bash
# 按主文件顶部设置生成一份 PDF
latexmk -pdf cas-dc-template-main.tex

# 仅生成双盲正文
latexmk -pdf cas-dc-template-main-blind.tex
```

命令行构建全部五种 PDF：

```bash
# macOS / Linux
ELS_BUILD_ALL=1 latexmk -pdf cas-dc-template-main.tex
```

```bat
:: Windows CMD
set ELS_BUILD_ALL=1
latexmk -pdf cas-dc-template-main.tex
set ELS_BUILD_ALL=
```

```powershell
# Windows PowerShell
$env:ELS_BUILD_ALL = '1'
latexmk -pdf cas-dc-template-main.tex
Remove-Item Env:ELS_BUILD_ALL
```

项目目录中只保留一个以 `-main.tex` 结尾的主文件。latexmk 自动生成的各版本 `.tex` 入口无需编辑，删除后可重新生成。

## 编译产物

下表中的 `{base}` 为主文件名，不含 `.tex`。

| 文件 | 内容 |
|---|---|
| `{base}.pdf` | 直接编译主文件的结果，由顶部设置决定 |
| `{base}-full.pdf` | 显示作者的完整稿，含图像摘要和 Highlights |
| `{base}-without-abstract.pdf` | 显示作者的正文稿，**含文字摘要**，无图像摘要和 Highlights |
| `{base}-blind.pdf` | 双盲正文稿，含文字摘要 |
| `{base}-graphical-abstract.pdf` | 独立图像摘要 |
| `{base}-highlights.pdf` | 独立 Highlights |
| `{base}-highlights.docx` | 可编辑的 Highlights Word，一键构建生成 |
| `{base}-authors.txt` | 作者信息汇总，供填写投稿表单，一键构建生成 |

一键构建的各版本按上表输出，不受主文件顶部默认开关影响。Highlights PDF 和 Word 共用 `0.Highlights.tex`，Word 标题读取 `\PaperTitle`。Highlights 每行写一条 `\item`；Word 支持简单文本格式，复杂公式和 LaTeX 命令请检查转换结果。

一键构建及 latexmk 的全版本、独立版本构建会清理输出文件的身份与编译元数据。成功后自动清理编译中间文件；失败时保留日志，可查看 `*-run.log` 和 `*-bibtex.log`。

## 投稿准备

双盲正文使用 `\BLINDtrue` 和 `\PaperOutput` 为 `body`。若提交源文件，准备：

- `cas-dc-template-main.tex`、`2.Abstract.tex`、`3.MainText.tex`。
- 参考文献数据库 `cas-refs.bib` 和正文实际引用的图片。
- 期刊系统需要的文档类、宏包及参考文献样式文件。当前使用 `elsarticle-num.bst`。

显示作者的稿件另加 `1.Author.tex`；完整稿件另加 `0.Highlights.tex` 和自己的图像摘要。图像摘要与 Highlights 独立附件按期刊要求提交。仅提交双盲 PDF 时，选择 `*-blind.pdf`。

`texfiles/`、`example-images/`、构建脚本、自动生成的版本入口、日志和作者 TXT 用于本地写作，不作为投稿附件。自己的图片放在源文件同一目录，投稿前替换示例图片并核对系统生成的 PDF。

## 排版提示

- `\cref{}` 自动添加图、表、公式等引用类型；`\cite{}` 引用文献。
- `3.MainText.tex` 包含图表和 `algorithm2e` 伪代码示例。
- 在 `1.Author.tex` 的 `\credit{...}` 中填写作者贡献。

<details>
<summary>CRediT 角色参考</summary>

| 英文术语                   | 英文定义                                                                                                                                                                                                      | 中文翻译                                                                                                                       |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| Conceptualization          | Ideas; formulation or evolution of overarching research goals and aims                                                                                                                                        | 概念构思；总体研究目标与宗旨的提出或完善                                                                                       |
| Methodology                | Development or design of methodology; creation of models                                                                                                                                                      | 方法学；研究方法的开发或设计、模型构建                                                                                         |
| Software                   | Programming, software development; designing computer programs; implementation of the computer code and supporting algorithms; testing of existing code components                                            | 软件；编程与软件开发、计算机程序设计、代码及配套算法的实现、现有代码组件的测试                                                 |
| Validation                 | Verification, whether as a part of the activity or separate, of the overall replication/reproducibility of results/experiments and other research outputs                                                     | 验证；（作为研究活动的一部分或独立环节）对研究结果 / 实验及其他产出的可重复性进行核实                                          |
| Formal analysis            | Application of statistical, mathematical, computational, or other formal techniques to analyze or synthesize study data                                                                                       | 正式分析；运用统计、数学、计算或其他正式技术对研究数据进行分析或综合                                                           |
| Investigation              | Conducting a research and investigation process, specifically performing the experiments, or data/evidence collection                                                                                         | 研究实施；开展研究与调查过程，特指实验操作或数据 / 证据收集                                                                    |
| Resources                  | Provision of study materials, reagents, materials, patients, laboratory samples, animals, instrumentation, computing resources, or other analysis tools                                                       | 资源支持；提供研究材料、试剂、样本、受试者、实验室样品、实验动物、仪器设备、计算资源或其他分析工具                             |
| Data Curation              | Management activities to annotate (produce metadata), scrub data and maintain research data (including software code, where it is necessary for interpreting the data itself) for initial use and later reuse | 数据管理；为初始使用及后续复用而开展的注释（生成元数据）、数据清洗及研究数据（含解读数据所需的软件代码）维护等管理工作         |
| Writing - Original Draft   | Preparation, creation and/or presentation of the published work, specifically writing the initial draft (including substantive translation)                                                                   | 撰写 - 初稿；已发表成果的准备、创作和 / 或呈现，特指初稿撰写（含实质性翻译）                                                   |
| Writing - Review & Editing | Preparation, creation and/or presentation of the published work by those from the original research group, specifically critical review, commentary or revision – including pre- or post-publication stages  | 撰写 - 审阅与编辑；由原研究团队成员完成的已发表成果的准备、创作和 / 或呈现，特指批判性审阅、评论或修订（含出版前及出版后阶段） |
| Visualization              | Preparation, creation and/or presentation of the published work, specifically visualization/data presentation                                                                                                 | 可视化；已发表成果的准备、创作和 / 或呈现，特指数据可视化 / 结果呈现                                                           |
| Supervision                | Oversight and leadership responsibility for the research activity planning and execution, including mentorship external to the core team                                                                      | 监督指导；对研究活动的规划与执行承担监督及领导职责，包括核心团队之外的指导工作                                                 |
| Project administration     | Management and coordination responsibility for the research activity planning and execution                                                                                                                   | 项目管理；对研究活动的规划与执行承担管理及协调职责                                                                             |
| Funding acquisition        | Acquisition of the financial support for the project leading to this publication                                                                                                                              | 资金获取；为促成本研究成果发表的项目争取财务支持                                                                               |

</details>

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
