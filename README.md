
# Self-made-els-latex-template
自制的爱思唯尔期刊Latex双栏版本

## 一、项目说明：
- 本项目基于Elsevier官网Latex模板(els-cas-templates.zip)。
- 针对`cas-dc-template.tex` 文件内容进行了一定的改动以符合国人写作习惯。
- 本项目仅关注模版的优化，追求精简化，仅对必要的内容进行展示，更多排版内容，烦请自行检索网络资料或借助AI工具（强烈推荐)。


## 二、文件目录：
- `README.md`：本文件（说明文档）
- `clean_latex.bat`：批量处理脚本，用于清理Latex的编译过程文件
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
- 下载压缩包导入在线Tex编译器（例如：Overleaf，Texpage），设置`cas-dc-template.tex`为编译主文件，采用XeLaTex方式编译文件即可正常编译。

- 下载压缩包解压后，通过本地Tex编译器（例如：Tex Studio，配置好插件的VS Code）打开`cas-dc-template.tex`，并将其作为编译主文件，采用XeLaTex方式编译文件即可正常编译。

> 请注意，即使作者信息、摘要、正文等内容是在分文件中进行撰写，但是运行编译还是要切换至`cas-dc-template.tex`进行编译，否则会报错。

##  四、注意事项：

> `cas-dc-template.tex`为编译主文件，无论采用何种编译方式和修改了哪里哪些内容，构建PDF要选择`cas-dc-template.tex`为编译主文件。
>
> TeXstudio 4.8.9 (git 4.8.9)实测，选择`cas-dc-template.tex`构建PDF的过程中，不要切换到分文件，不然有可能导致编译失败。

## 贡献者
衷心感谢为该模版优化改进的协作者！

<a href="https://github.com/EmpyreanHYR/Self-made-els-latex-template">
  <img src="https://contrib.rocks/image?repo=EmpyreanHYR/Self-made-els-latex-template" />
</a>

热烈欢迎更多协作者为模板的优化改进提出建议！