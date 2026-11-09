---
name: brain-new-project
description: 按模板新建一个项目子文件夹 projects/<项目名>/，带项目自己的 CLAUDE.md，并在 wiki/projects/ 建对应知识页。用户说“新建项目”“给 X 建个文件夹”时使用。
disable-model-invocation: true
---

# 新建项目子文件夹

参数：项目名（`$ARGUMENTS`）。没给项目名就先问。

1. 项目文件夹名用小写英文加连字符，例如 `jpm-2027`；中文项目名请用户确认英文文件夹名。
2. 如果 `projects/<项目名>/` 已存在，停止并告诉用户，不覆盖。
3. 复制 `projects/_template/CLAUDE.md` 到 `projects/<项目名>/CLAUDE.md`，建 `drafts/` 和 `final/` 两个空文件夹（各放一个 `.gitkeep`）。
4. 逐题问用户：项目目标和截止时间、当前状态、关键人物和机构、本项目特有的规则。根据回答填 `projects/<项目名>/CLAUDE.md`，用户没回答的项保留占位符。
5. 新建 `wiki/projects/<项目名>.md`（front matter `type: project`），写项目概述，链接到相关人物和概念页（只链接已存在的页面）。
6. 更新 `wiki/index.md`，并在根目录 `CLAUDE.md` 的 Current projects 里给这个项目加一行（先给用户看改动再写）。
7. 告诉用户：在这个项目里工作时，在 Code 标签用 `projects/<项目名>/` 作为工作文件夹打开，项目规则和上层规则都会生效。
