# PreToolUse hook: block shell commands that would modify files under raw/.
# The Edit/Write tools are already blocked by the deny rule "Edit(/raw/**)" in settings.json.
# This hook covers the gap: shell commands (rm, mv, del, Remove-Item, redirection, etc.) touching raw/.
# Exit 2 = block the tool call; stderr is shown to Claude as the reason.
# Kept ASCII-only so Windows PowerShell 5.1 reads it correctly without a BOM.

$ErrorActionPreference = 'Stop'

try {
    $payload = [Console]::In.ReadToEnd() | ConvertFrom-Json
} catch {
    # Cannot parse input: do not block, let normal permission flow handle it.
    exit 0
}

$cmd = $payload.tool_input.command
if (-not $cmd) { exit 0 }

# Only care about commands that mention the raw folder.
if ($cmd -notmatch '(^|[\s"''/\\=])raw([/\\]|\s|"|''|$)') { exit 0 }

$writeVerbs = @(
    '\brm\b', '\brmdir\b', '\bmv\b', '\bcp\b', '\bdel\b', '\berase\b', '\bmove\b', '\bren\b', '\brename\b',
    '\bRemove-Item\b', '\bMove-Item\b', '\bRename-Item\b', '\bCopy-Item\b', '\bSet-Content\b',
    '\bAdd-Content\b', '\bOut-File\b', '\bClear-Content\b', '\bNew-Item\b',
    '\bsed\s+-i', '\btruncate\b', '\btouch\b', '\bchmod\b', '\bgit\s+(rm|mv|checkout|restore)\b',
    '>>?\s*["'']?[^\s"'']*raw[/\\]'
)

foreach ($v in $writeVerbs) {
    if ($cmd -match $v) {
        [Console]::Error.WriteLine("Blocked: raw/ is read-only in this folder. Do not modify, move, rename or delete files under raw/. Write to wiki/ or output/ instead.")
        exit 2
    }
}

exit 0
