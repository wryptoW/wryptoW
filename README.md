# 第二大脑模板（非 Obsidian 部分）

参照 Ryven 的 X Article《How to Build a Second Brain With Claude and Obsidian That Gets Smarter With Every Source You Save》（https://x.com/imryven/status/2115046979659055476）搭建。这里只做不依赖 Obsidian 的部分：文件夹结构、CLAUDE.md、导入和提问流程、项目模板、skill、两个本地定时任务、权限和备份。Obsidian 安装、图谱视图、mcp-obsidian 和文章里的两个第三方仓库不在这次范围内。wiki 用标准 Markdown 加 `[[双括号]]` 链接，以后直接用 Obsidian 打开同一个文件夹就能看图谱，不需要迁移。

> **本仓库是公开仓库。** 这里只放不含个人信息的模板。访谈填好的 CLAUDE.md、raw/ 资料、wiki 内容都只存在本地的第二大脑文件夹里，不要提交到这里。

## 目录

```
brain-template/                 # 复制到本地后就是第二大脑本体
├── CLAUDE.md                   # 规则：About me / Current projects / How to talk to me / How this folder works / Wiki rules
├── raw/                        # 原始资料，只读
├── wiki/
│   ├── index.md                # 每页一行的目录
│   ├── _ingest-log.md          # 已导入的 raw 文件清单，用来判断“未处理”
│   ├── meetings.md             # 会议记录（日历接入后启用）
│   ├── sources/ concepts/ people/ projects/ answers/
├── output/                     # 成品、daily-log.md、每周检查报告
├── projects/_template/CLAUDE.md
└── .claude/
    ├── settings.json           # 权限放行和拦截规则 + hook
    ├── hooks/protect-raw.ps1   # 拦截通过命令行改动 raw/ 的操作
    └── skills/
        ├── brain-interview/    # 第 4 步：访谈并填写 CLAUDE.md
        ├── brain-ingest/       # 第 5 步：导入
        ├── brain-ask/          # 第 6 步：只基于 wiki 回答，好答案存回
        ├── brain-new-project/  # 第 7 步：项目子文件夹
        └── brain-lint/         # 第 10 步：每周只读检查
scheduled-tasks/
├── nightly-brain/SKILL.md      # 本地定时任务：每晚导入 + 三行 daily-log + git 本地提交
└── weekly-brain-check/SKILL.md # 本地定时任务：每周只读检查
scripts/install.ps1             # 把模板复制到本地并初始化 git
```

## 与原文步骤的对应

| 原文步骤 | 本模板中的实现 |
|---|---|
| 1 到 3：装 Desktop、建文件夹、在 Code 标签打开 | `scripts/install.ps1` 建文件夹，默认 `%USERPROFILE%\brain` |
| 4：访谈后写 CLAUDE.md | `/brain-interview`，逐题访谈四个主题，确认后才写入 |
| 5：导入 | `/brain-ingest`，未处理的判断依据是 `wiki/_ingest-log.md` |
| 6：提问 | `/brain-ask`，只用 wiki，逐条注明出处，单列“wiki 未覆盖” |
| 7：项目子文件夹 | `/brain-new-project`，模板在 `projects/_template/` |
| 8：重复流程做成 skill | 上面五个 skill |
| 9：Google Calendar | **待决定**，见下文 |
| 10：nightly 和每周检查 | `scheduled-tasks/` 下两个任务 |
| 原文提醒：CLAUDE.md 只是上下文 | `settings.json` 拦截修改 raw/ 的操作（deny 规则），hook 补上命令行改动 raw/ 这个缺口 |
| 原文提醒：要备份 | 本地 git 每晚提交；远程备份见下文 |

在原文基础上补了三条规则：矛盾说法不覆盖，改为加“存在分歧”小节；不删页面，只提建议；事实性说法必须标出来源页。

## 部署步骤（在本地电脑上做）

1. **复制模板**：在本仓库根目录运行
   `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\install.ps1`
   默认目标是 `%USERPROFILE%\brain`，用 `-Target` 改路径。目标文件夹已存在且非空时，脚本不复制、直接退出。
2. **访谈**：在 Claude Desktop 的 Code 标签用该文件夹作为工作文件夹打开，输入 `/brain-interview`。
3. **建两个本地定时任务**：Code 标签侧栏 Scheduled → New task：
   - Name：`nightly-brain` / `weekly-brain-check`；Instructions：分别粘贴 `scheduled-tasks/` 下对应 SKILL.md 正文（frontmatter 以下部分）。
   - Working folder：第二大脑根目录（必须是根目录本身，否则读工作目录外的文件会弹确认，无人值守时会卡住）。
   - Advanced settings → General → 勾选 **Only on this computer**（必须是本地任务，云端任务看不到本地文件夹）。
   - 时间：建议 nightly 每天 02:30，weekly 每周日 03:30。**需要和已有的定时任务错开，具体时间请用户确认。**
   - 权限模式：Accept edits。仓库已在 `settings.json` 放行 wiki/、output/ 的编辑和 git add/commit。
4. **预跑一次**：每个任务点一次 Run now，在 History 里打开这次运行，有权限提示就当场批准（会按任务保存），确认之后夜间运行不再卡住。
5. **保持运行条件**：Desktop 要开着，电脑不能睡眠（Settings 里打开 Keep computer awake；合上笔记本盖子仍会睡眠）。错过的运行在唤醒后补跑一次（7 天内）。

## 已知限制与未验证项

- `/skill-name` 写在 Desktop 定时任务指令里能否在无人值守时触发，官方文档没有给出例子，所以两个任务的指令写成“读取 `.claude/skills/.../SKILL.md` 按步骤执行”，不依赖斜杠调用。
- `protect-raw.ps1` 的匹配规则只在 Linux 上用 Python 正则做过 14 个用例的测试，没有在 Windows PowerShell 里实际运行过；部署后建议让 Claude 试着执行一次 `rm raw/test.txt`，确认被拦截。
- hook 是按关键词匹配，不是沙箱，不保证拦住所有间接写法；主防线是 `Edit(/raw/**)` 的 deny 规则。
- 原文作者自己说明没有完整跑过这份教程，本模板同样需要在本机实测后再依赖。

## 待决定

1. **日历**：原文第 9 步走 workspace-mcp + Google Cloud OAuth。如果日常用的是飞书等其他日历，可以改用对应日历的命令行工具或 MCP 写入 `wiki/meetings.md`，免去 Google OAuth 配置。选定后再补 nightly 的第 4 步。
2. **第二大脑放在哪**：默认 `%USERPROFILE%\brain`。
3. **远程备份**：本地 git 只能防误改，防不了硬盘损坏。可选：在 GitHub 新建一个**私有**仓库作为 remote，手动或定期 push；或把文件夹放进 OneDrive 等同步盘。不要 push 到本公开仓库。
4. **nightly 和 weekly 的运行时间**。
