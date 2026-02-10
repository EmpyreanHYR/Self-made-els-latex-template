# Self-made-els-latex-template

自制的爱思唯尔期刊Latex双栏版本

## 一、项目说明：

- 本项目基于Elsevier官网Latex模板(els-cas-templates.zip)。
- 针对 `cas-dc-template.tex` 文件内容进行了一定的改动以符合国人写作习惯。
- 本项目仅关注模版的优化，追求精简化，仅对必要的内容进行展示，更多排版内容，烦请自行检索网络资料或借助AI工具（强烈推荐)。

## 二、文件目录：

- `README.md`：本文件（说明文档）
- `clean_latex.bat`：批量处理脚本，用于清理Latex的编译过程文件
- `compile_all.bat`：一键生成投稿所需4个PDF（XeLaTeX）
- `cas-dc.cls`：双栏格式专用类文件
- `cas-dc-template.tex`：稿件撰写专用双栏格式 TeX 模板（主文件）
- `cas-dc-templates.pdf`：编译好的pdf文件
- `cas-refs.bib`：BibTeX 样式文件
- `cas-model2-names.bst`：参考文献的排版格式
- `cas-common.sty`：用于格式化的附加宏包
- `thumbnails\`：缩略图目录，包含将嵌入排版后 PDF 中的缩略图图像
- `figs\`：图片目录，包含将嵌入排版后PDF 中的图像
- `texfiles\`：Tex分文件目录，包含将嵌入排版的文件
- `doc\`：文档目录，包含官方模版指南说明

## 三、使用方法：

- 下载压缩包导入在线Tex编译器（例如：Overleaf，TeXPage），设置 `cas-dc-template.tex`为编译主文件，采用XeLaTex方式编译文件即可正常编译。
- 下载压缩包解压后，通过本地Tex编译器（例如：Tex Studio，配置好插件的VS Code）打开 `cas-dc-template.tex`，并将其作为编译主文件，采用XeLaTex方式编译文件即可正常编译。

> 请注意，即使作者信息、摘要、正文等内容是在分文件中进行撰写，但是运行编译还是要切换至 `cas-dc-template.tex`进行编译，否则会报错。

- 投稿系统所需的4个PDF（图像摘要/Highlights分离）

  Elsevier 投稿系统通常要求将“图像摘要（Graphical Abstract）”和“高光点（Highlights）”单独上传。本仓库通过**同一个主文件**配合脚本实现一次生成4个 PDF（均使用 XeLaTeX）：

  - `cas-dc-template-full.pdf`：正文 + 图像摘要 + Highlights（完整版）
  - `cas-dc-template-without-abstract.pdf`：正文（不含图像摘要/Highlights）
  - `cas-dc-template-graphical-abstract.pdf`：仅图像摘要（独立文件，不含正文）
  - `cas-dc-template-highlights.pdf`：仅 Highlights（独立文件，不含正文）

  推荐用法（Windows，PowerShell 或 CMD 均可）：

  1) 确保已安装并配置好 LaTeX（MiKTeX/TeX Live），且 `xelatex` 可在命令行直接运行。
  2) 在项目根目录双击或运行：

  ```bat
  compile_all.bat
  ```

  说明：脚本会对每个版本运行两次 XeLaTeX（避免交叉引用/目录等不完整）。

  如需排查编译错误：打开 `compile_all.bat`，把每行命令末尾的 `>nul` 去掉即可看到完整日志。

## 四、注意事项：

> `cas-dc-template.tex`为编译主文件，无论采用何种编译方式和修改了哪里哪些内容，构建PDF要选择 `cas-dc-template.tex`为编译主文件。

> TeXstudio 4.8.9 (git 4.8.9)实测，选择 `cas-dc-template.tex`构建PDF的过程中，不要切换到分文件，不然有可能导致编译失败。

> 当前文稿考虑写作实际习惯和编译运行开销，默认输出**正文（不含图像摘要/Highlights）**，如果需要默认输出完整版，可以取消原有的完整版注释，并注释默认选项:
>
> ```
> \def\FULL{1}                % 完整版（包含图像摘要和高光点）
> % \def\WITHOUTABSTRACT{1}      % 默认：正文版（无图像摘要/Highlights，日常写作更快）
> ```

> 使用 `\cref{}`索引图片，表格，公式，自动添加类型。

> 使用 `\cite{}`引用参考文献。

> 使用 `\lipsum[1-3]`能随机生成3段文本内容，可用于占位。

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

## 贡献者

衷心感谢为该模版优化改进的协作者！！！

<a href="https://github.com/EmpyreanHYR/Self-made-els-latex-template">
  <img src="https://contrib.rocks/image?repo=EmpyreanHYR/Self-made-els-latex-template" />
</a>

热烈欢迎更多协作者为模板的优化改进提出建议！

谢谢大家
