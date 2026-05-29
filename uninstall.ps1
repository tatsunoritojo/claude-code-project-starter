#requires -Version 5.1
<#
.SYNOPSIS
  開発スタイルパックのアンインストール（Windows / PowerShell）。

.DESCRIPTION
  パックが入れたスキルと起動グリーティングフックを ~/.claude から取り除く。
  既定はドライラン（削除内容の表示のみ）。実際に削除するには -Yes を付ける。
  settings.json と CLAUDE.md は自分で編集している可能性があるため、自動では触らない。

.EXAMPLE
  .\uninstall.ps1        # 何が消えるか表示するだけ
  .\uninstall.ps1 -Yes   # 実際に削除
#>
[CmdletBinding()]
param(
  [switch]$Yes
)

$ErrorActionPreference = 'Stop'

$srcRoot   = Split-Path -Parent $MyInvocation.MyCommand.Path
$srcSkills = Join-Path $srcRoot 'home-claude\skills'
$target    = Join-Path $env:USERPROFILE '.claude'

Write-Host "アンインストール対象: $target"
if (-not $Yes) { Write-Host "(ドライラン。実際に削除するには -Yes を付けて実行)" }
Write-Host ""

function Remove-Item-IfExists([string]$path, [string]$label) {
  if (-not (Test-Path $path)) { return }
  if ($Yes) {
    Remove-Item -Path $path -Recurse -Force
    Write-Host "  削除: $label"
  } else {
    Write-Host "  削除予定: $label"
  }
}

# パックが配布したスキルだけを対象にする
if (Test-Path $srcSkills) {
  foreach ($skill in Get-ChildItem -Path $srcSkills -Directory) {
    Remove-Item-IfExists (Join-Path $target "skills\$($skill.Name)") "skills/$($skill.Name)"
  }
}

# 起動グリーティングフック
Remove-Item-IfExists (Join-Path $target 'hooks\session-greeting.sh') "hooks/session-greeting.sh"

Write-Host ""
Write-Host "手動で確認してください（自動では触りません）:"
Write-Host "  - $target\settings.json の hooks.SessionStart から session-greeting の登録を外す"
Write-Host "  - $target\CLAUDE.md は編集済みの可能性があるため残しています。不要なら手動削除、または .stylepack-backup-* から復元"
