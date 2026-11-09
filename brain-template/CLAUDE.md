# 第二大脑：工作规则

> 本文件由 brain-interview skill 访谈后填写。带 `{{ }}` 的地方是待填内容，填完删掉占位符。
> 全局 `~/.claude/CLAUDE.md` 每次会话都会加载，本文件不重复全局规则，只写这个文件夹特有的内容。
> 本文件控制在 200 行以内。CLAUDE.md 只是上下文，不是硬约束；真正的拦截靠 `.claude/settings.json` 里的权限规则。

## About me

{{身份、机构、职位、主要工作领域，3 到 6 行}}

## Current projects

{{今年在推进的项目，每个一行：项目名 | 目标 | 当前阶段 | 对应 projects/ 子文件夹}}

## How to talk to me

{{沟通偏好：语言、详略、格式、哪些说法不要用。与全局 CLAUDE.md 一致的部分写“见全局规则”即可}}

## How this folder works

文件夹结构：

- `raw/`：原始资料（文章、PDF、会议记录、聊天导出、早报存档等）。**只读**，Claude 不新建、不修改、不删除、不移动 raw/ 里的任何文件。
- `wiki/`：Claude 维护的知识库。
  - `wiki/index.md`：全部 wiki 页面的目录，每页一行。
  - `wiki/_ingest-log.md`：已导入的 raw 文件清单。不在清单里的 raw 文件就是“未处理”。
  - `wiki/sources/`：每个 raw 文件一页摘要。
  - `wiki/concepts/`：概念、技术、方法论页。
  - `wiki/people/`：人物、机构页。
  - `wiki/projects/`：项目知识页（与 `projects/` 工作文件夹对应）。
  - `wiki/answers/`：存回 wiki 的高质量问答。
  - `wiki/meetings.md`：会议记录汇总（日历接入后使用）。
- `output/`：基于 wiki 产出的成品，以及 `daily-log.md`、每周检查报告。
- `projects/<项目名>/`：每个项目一个工作文件夹，带自己的 CLAUDE.md。

常用操作（都已做成 skill，直接调用）：

- `/brain-ingest`：导入 raw/ 中未处理的文件。
- `/brain-ask <问题>`：只基于 wiki 回答，并注明出处页面。
- `/brain-lint`：每周只读检查，输出报告到 output/。
- `/brain-new-project <项目名>`：按模板建项目子文件夹。
- `/brain-interview`：重新访谈并更新本文件前三节。

## Wiki rules

1. **出处**：wiki 中每一条事实性说法都要能追溯到 `wiki/sources/` 的某一页，用 `[[sources/页面名]]` 标注。没有来源的判断写成“我的判断：……”，与事实分开。
2. **链接**：页面之间用 `[[双括号]]` 互链，链接写相对 wiki/ 的路径，不带 `.md`，例如 `[[concepts/senolytics]]`。新建页面时，至少链接到一个已有页面，并在相关页面上加回链。
3. **文件名**：小写英文、连字符分隔，例如 `concepts/partial-reprogramming.md`。来源摘要页用 `sources/YYYY-MM-DD-简短标识.md`，日期为资料本身的日期，不知道就用导入日期。
4. **页面头部**：每页以 YAML front matter 开头：
   ```yaml
   ---
   type: source | concept | person | org | project | answer
   sources: [sources/xxx, sources/yyy]
   updated: YYYY-MM-DD
   ---
   ```
5. **矛盾处理**：新资料与已有页面说法不一致时，不覆盖旧说法。在该页加 `## 存在分歧` 小节，列出各方说法和各自来源，并在当天 daily-log 的“待决定”里记一条。
6. **index**：每新建、改名或删除一个 wiki 页面，同步更新 `wiki/index.md`，格式：`- [[路径]]：一句话说明（类型，更新日期）`。
7. **不确定就标注**：数字、日期、人名拿不准时，原样保留 raw 里的写法并标“待核实”，不自行修正。
8. **不删页面**：需要合并或删除页面时，只在 daily-log 的“待决定”里提出，由我确认后再做。
9. **改动可追溯**：每次导入或修改 wiki 后，在回复末尾列出新建和修改的页面清单。
