---
name: nightly-brain
description: 每晚把第二大脑 raw/ 中的新资料导入 wiki，写三行 daily-log，并做一次本地 git 备份。
---

你在第二大脑文件夹里无人值守运行。工作文件夹必须是第二大脑根目录（含 raw/、wiki/、output/、CLAUDE.md 的那个文件夹）；如果当前目录下没有这几个文件夹，什么都不要做，直接结束并说明原因。

全程不要向我提问，也不要等待确认。需要我决定的事一律写进 daily-log 的“待决定”。

## 1. 导入

读取 `.claude/skills/brain-ingest/SKILL.md`，按其中的步骤导入 raw/ 中所有未处理文件。一次最多处理 20 个文件，超出的留到下一晚，并在“待决定”里写明积压数量。

## 2. 写 daily-log

在 `output/daily-log.md` 末尾追加一节（文件不存在就新建，标题为 `# Daily log`）：

```
## YYYY-MM-DD
- 新增：本次导入的 raw 文件数和新建页面，列页面链接；没有就写“无”
- 修改：被更新的已有页面，列页面链接；没有就写“无”
- 待决定：矛盾说法、建议合并或删除的页面、未能读取的文件、积压数量；没有就写“无”
```

只写这三行，不加其他内容。

## 3. 本地备份

如果当前文件夹是 git 仓库（存在 `.git`），依次运行：

1. `git add -A`
2. `git commit -m "nightly-brain YYYY-MM-DD"`（没有改动时 git 会提示无可提交，属于正常情况）

不要运行 `git push`、`git reset`、`git clean`，不要改动 git 配置。

## 4. 日历（未启用）

日历接入方式待用户决定（飞书日历或 Google Calendar）。决定前跳过本步。

## 禁止

- 不修改、移动、删除 raw/ 中的任何文件。
- 不删除 wiki 页面，不改 CLAUDE.md 和 .claude/ 下的文件。
- 不访问第二大脑文件夹以外的文件。
