---
title: 用 Pandoc 将 Markdown 转换为 PDF 文档
author: 谭淞宸
date: \today
documentclass: ctexart
---

# Pandoc 的基本使用

对于我们的使用目标而言，在编写文档时使用 Markdown 这一易读易写的语言，然后用 Pandoc 翻译成 \LaTeX 源码并进而生成 PDF 是一个兼顾效率和效果的选择。

在官方网站 [Pandoc](https://pandoc.org/installing.html) 上根据不同的系统选择相应的安装方式并完成安装。然后，打开终端，转到 `Quantum Chemistry` 这一目录下，输入：

```bash
pandoc meta.md 1.md 2.md 3.md 4.md 5.md final.md --pdf-engine 
xelatex -N -o 量子化学讲义.pdf
```

这一指令的含义是：将 `meta.md`, `1.md`, …, `5.md`, `final.md` 等文本顺次连接，然后用 `xelatex` 引擎转换为 PDF 文件，输出（`-o`）文件为 `量子化学讲义.pdf`，并且输出的时候各级标题要加上相应的序号（`-N`）。

之所以分不同的 `.md` 文件存储源信息，是因为笔记总计约 6 万字符，若使用一般的 Markdown 编辑器极易卡顿，分开存储便于更新维护。

# YAML Front Matter 配置

Markdown 文件本身并不包含任何元信息，也即 Markdown 文件的第一行就对应着 \LaTeX 文档中 `\begin{document}` 之后的内容。为了能在标题页中显示作者等信息，需要在 Markdown 文件中加入 YAML Front Matter（`meta.md` 中已经加好了），其内容为：

```YAML
---
title: 量子化学讲义
author: 
- 蒋鸿\quad 编
- 谭淞宸\quad 整理
date: \today
documentclass: ctexrep
header-includes: |
  \usepackage{booktabs}
---
```

前三个条目对应于标题、作者、日期（`\today` 是生成当前日期的命令）。

第四个条目表明该文档使用 `ctexrep` 文档类。`rep` 的意思是它对应于 \LaTeX 标准文档类中的 `report`，适用于几十至百余页的中型文档排版。

第五个条目指定了其他需要在 `\begin{document}` 之前写的内容，比如调用宏包。一些常用的宏包（如 `amsmath`）在 Pandoc 转换的过程中就会自动加上，只有不是 Pandoc 自带的宏包（如 `booktabs`）需要在这里写明。

# 其他说明

Markdown 的一级标题对应于 \LaTeX 的 `section` 层级，二级标题对应于 `subsection` 层级，所以为了添加 `report` 文档类的 `chapter` 层级（例：第二章-多电子问题概论），需要在 `markdown` 中内嵌 \LaTeX 源码，即写成

```latex
\chapter{多电子问题概论}
```

类似地，遇到其余的 \LaTeX 支持但 Markdown 不支持的语法都可以用内嵌源码的方式实现。

另外，值得注意的是，这些 `.md` 文件的原意是作为笔记存在的，因此它包含的小标题的数目不同寻常地多，呈现一种碎片化的结构。如果作为讲义，则需要重新梳理其结构。

如有其他使用上的问题，可以联系 tansongchen@pku.edu.cn 或在方正 313 室中间的过道旁从外往内数第五个办公桌处找到我。