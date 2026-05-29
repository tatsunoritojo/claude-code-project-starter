#requires -Version 5.1
<#
.SYNOPSIS
  開発スタイルパックのアンインストール（Windows / PowerShell）。

.DESCRIPTION
  インストール時に記録したマニフェスト（~/.claude/.stylepack-manifest）に載っている
  ものだけを取り除く。ユーザー自前の同名スキルや手で置いたファイルには触らない。
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

$target       = Join-Path $env:USERPROFILE '.claude'
$manifestPath = Join-Path $target '.stylepack-manifest'

Write-Host "アンインストール対象: $target"

if (-not (Test-Path $manifestPath)) {
  Write-Host ""
  Write-Host "マニフェスト（$manifestPath）が見つかりません。"
  Write-Host "このパックの導入記録がないため、自動削除は行いません。"
  Write-Host "手動で確認する場合は $target\skills と $target\hooks\session-greeting.sh を見てください。"
  exit 0
}

if (-not $Yes) { Write-Host "(ドライラン。実際に削除するには -Yes を付けて実行)" }
Write-Host ""

$removedAny = $false
foreach ($rel in Get-Content -Path $manifestPath -Encoding UTF8) {
  $rel = $rel.Trim()
  if (-not $rel) { continue }
  $path = Join-Path $target ($rel -replace '/', '\')
  if (-not (Test-Path $path)) { continue }
  if ($Yes) {
    Remove-Item -Path $path -Recurse -Force
    Write-Host "  削除: $rel"
  } else {
    Write-Host "  削除予定: $rel"
  }
  $removedAny = $true
}

if (-not $removedAny) { Write-Host "  （マニフェストに記載の項目は既に存在しません）" }

if ($Yes) {
  Remove-Item -Path $manifestPath -Force
  Write-Host "  削除: .stylepack-manifest"
}

Write-Host ""
Write-Host "手動で確認してください（自動では触りません）:"
Write-Host "  - $target\settings.json の hooks.SessionStart から session-greeting の登録を外す"
Write-Host "  - $target\CLAUDE.md は編集済みの可能性があるため残しています。不要なら手動削除、または .stylepack-backup-* から復元"
