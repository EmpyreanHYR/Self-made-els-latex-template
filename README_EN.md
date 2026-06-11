[中文](README.md) | **English**

# Self-made-els-latex-template

A customized two-column LaTeX template for Elsevier journals.

## 1. About This Project

- Based on the official Elsevier LaTeX template (`els-cas-templates.zip`).
- Modifications have been made to `cas-dc-template.tex` to better suit the writing habits of Chinese authors.
- This project focuses on template optimization and minimalism, showcasing only essential content. For advanced typesetting needs, please search the web or use AI tools (highly recommended).

## 2. File Directory

- `README.md` — This document (Chinese version)
- `README_EN.md` — This document (English version)
- `clean_latex.bat` — Batch script for cleaning up LaTeX intermediate/build files
- `compile_all.bat` — One-click generation of the 4 PDFs required for submission (XeLaTeX)
- `cas-dc.cls` — Document class file for two-column format
- `cas-dc-template.tex` — Main two-column TeX template for manuscript writing
- `cas-dc-template.pdf` — Pre-compiled PDF of the template
- `cas-refs.bib` — BibTeX bibliography file
- `cas-model2-names.bst` — Bibliography style file
- `cas-common.sty` — Additional style package for formatting
- `thumbnails\` — Thumbnail directory, containing thumbnail images to be embedded in the compiled PDF
- `figs\` — Figures directory, containing images to be embedded in the compiled PDF
- `texfiles\` — TeX sub-file directory, containing files to be included during typesetting
- `doc\` — Documentation directory, containing the official template guide

## 3. Usage

- **Main file naming convention**: The main TeX file must end with `-main` (e.g. `cas-dc-template-main.tex`). `compile_all.bat` automatically scans for `*-main.tex` in the current directory as the compilation entry point.
- Download the archive and import it into an online TeX compiler (e.g., Overleaf, TeXPage). Set the `*-main.tex` file as the main compilation file and compile using **pdfLaTeX**. The magic comment `% !TEX program = pdflatex` on the first line lets most editors auto-select the correct compiler.
- Download and extract the archive, then open the `*-main.tex` file in a local TeX compiler (e.g., TeX Studio, or VS Code with the LaTeX plugin). Set it as the main file and compile using **pdfLaTeX**.

> **Note:** Even if author info, abstract, body text, etc. are written in separate sub-files, you must still switch to the `*-main.tex` file for compilation. Otherwise, errors will occur.

- **Generating the 4 PDFs required by the submission system (Graphical Abstract / Highlights separated)**

  The Elsevier submission system typically requires "Graphical Abstract" and "Highlights" to be uploaded as separate files. This repository uses the **same main file** along with a script to generate all 4 PDFs in one go (all using pdfLaTeX):

  - `{name}-full.pdf` — Body + Graphical Abstract + Highlights (full version)
  - `{name}-without-abstract.pdf` — Body only (no Graphical Abstract / Highlights)
  - `{name}-graphical-abstract.pdf` — Graphical Abstract only (standalone, no body)
  - `{name}-highlights.pdf` — Highlights only (standalone, no body)

  Recommended workflow (Windows, PowerShell or CMD):

  1. Ensure LaTeX (MiKTeX / TeX Live) is installed and configured, and that `pdflatex` can be run from the command line.
  2. Name your main file with the `-main` suffix (e.g. `my-paper-main.tex`) — the script detects it automatically.
  3. In the project root directory, double-click or run:

  ```bat
  compile_all.bat
  ```

  Note: The script runs pdfLaTeX + BibTeX two to three times for each version to ensure cross-references, tables of contents, etc. are complete.

  To troubleshoot compilation errors: open `compile_all.bat` and remove `>nul` from the end of each command line to see the full log.

## 4. Important Notes

> The main file must be named with the `-main` suffix (e.g. `cas-dc-template-main.tex`). `compile_all.bat` automatically detects `*-main.tex` as the compilation entry. The first line `% !TEX program = pdflatex` is a magic comment that ensures editors use pdfLaTeX.

> Tested with TeXstudio 4.8.9 (git 4.8.9): while building the PDF with the `*-main.tex` file, do **not** switch to a sub-file, as this may cause the compilation to fail.

> For daily writing convenience and faster compilation, the template defaults to outputting **body-only (without Graphical Abstract / Highlights)**. To output the full version instead, uncomment the full-version option and comment out the default:

> ```tex
> \def\FULL{1}                % Full version (includes Graphical Abstract and Highlights)
> % \def\WITHOUTABSTRACT{1}      % Default: body-only (no Graphical Abstract / Highlights, faster for daily writing)
> ```

> Use `\cref{}` to reference figures, tables, and equations — the type is automatically added.

> Use `\cite{}` to cite references.

> Use `\lipsum[1-3]` to generate 3 random paragraphs of placeholder text.

> **CRediT** (Contributor Roles Taxonomy) must be provided at submission time and will appear before the "Acknowledgment" section upon publication.

> | English Term              | Definition                                                                                                                                                                                                     | Chinese Translation                                                                                                            |
> | ------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
> | Conceptualization         | Ideas; formulation or evolution of overarching research goals and aims                                                                                                                                         | 概念构思；总体研究目标与宗旨的提出或完善                                                                                       |
> | Methodology               | Development or design of methodology; creation of models                                                                                                                                                       | 方法学；研究方法的开发或设计、模型构建                                                                                         |
> | Software                  | Programming, software development; designing computer programs; implementation of the computer code and supporting algorithms; testing of existing code components                                             | 软件；编程与软件开发、计算机程序设计、代码及配套算法的实现、现有代码组件的测试                                                 |
> | Validation                | Verification, whether as a part of the activity or separate, of the overall replication/reproducibility of results/experiments and other research outputs                                                      | 验证；（作为研究活动的一部分或独立环节）对研究结果 / 实验及其他产出的可重复性进行核实                                          |
> | Formal analysis           | Application of statistical, mathematical, computational, or other formal techniques to analyze or synthesize study data                                                                                        | 正式分析；运用统计、数学、计算或其他正式技术对研究数据进行分析或综合                                                           |
> | Investigation             | Conducting a research and investigation process, specifically performing the experiments, or data/evidence collection                                                                                           | 研究实施；开展研究与调查过程，特指实验操作或数据 / 证据收集                                                                    |
> | Resources                 | Provision of study materials, reagents, materials, patients, laboratory samples, animals, instrumentation, computing resources, or other analysis tools                                                        | 资源支持；提供研究材料、试剂、样本、受试者、实验室样品、实验动物、仪器设备、计算资源或其他分析工具                             |
> | Data Curation             | Management activities to annotate (produce metadata), scrub data and maintain research data (including software code, where it is necessary for interpreting the data itself) for initial use and later reuse  | 数据管理；为初始使用及后续复用而开展的注释（生成元数据）、数据清洗及研究数据（含解读数据所需的软件代码）维护等管理工作         |
> | Writing - Original Draft  | Preparation, creation and/or presentation of the published work, specifically writing the initial draft (including substantive translation)                                                                    | 撰写 - 初稿；已发表成果的准备、创作和 / 或呈现，特指初稿撰写（含实质性翻译）                                                   |
> | Writing - Review & Editing| Preparation, creation and/or presentation of the published work by those from the original research group, specifically critical review, commentary or revision – including pre- or post-publication stages   | 撰写 - 审阅与编辑；由原研究团队成员完成的已发表成果的准备、创作和 / 或呈现，特指批判性审阅、评论或修订（含出版前及出版后阶段） |
> | Visualization             | Preparation, creation and/or presentation of the published work, specifically visualization/data presentation                                                                                                  | 可视化；已发表成果的准备、创作和 / 或呈现，特指数据可视化 / 结果呈现                                                           |
> | Supervision               | Oversight and leadership responsibility for the research activity planning and execution, including mentorship external to the core team                                                                       | 监督指导；对研究活动的规划与执行承担监督及领导职责，包括核心团队之外的指导工作                                                 |
> | Project administration    | Management and coordination responsibility for the research activity planning and execution                                                                                                                     | 项目管理；对研究活动的规划与执行承担管理及协调职责                                                                             |
> | Funding acquisition       | Acquisition of the financial support for the project leading to this publication                                                                                                                               | 资金获取；为促成本研究成果发表的项目争取财务支持                                                                               |

## Contributors

Sincere thanks to all collaborators who have helped optimize and improve this template!

<a href="https://github.com/EmpyreanHYR/Self-made-els-latex-template">
  <img src="https://contrib.rocks/image?repo=EmpyreanHYR/Self-made-els-latex-template" />
</a>

More collaborators are warmly welcomed to contribute suggestions for improving this template!

Thank you all!
