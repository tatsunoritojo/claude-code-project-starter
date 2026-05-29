#requires -Version 5.1
<#
.SYNOPSIS
  開発スタイルパックを ~/.claude へ展開するインストーラ（Windows / PowerShell）。

.DESCRIPTION
  home-claude/ 配下のグローバルルール・スキル・設定を、ユーザーの ~/.claude/ に展開する。
  既存ファイルは破壊せず、衝突時はバックアップを取るか .stylepack 退避ファイルとして書き出す。

.PARAMETER UserName
  グローバル CLAUDE.md の {{USER_NAME}} を埋める。省略時はプレースホルダのまま残す。

.PARAMETER UserRole
  {{USER_ROLE}} を埋める。省略可。

.PARAMETER Force
  既存の CLAUDE.md / settings.json / 同名スキルを、バックアップを取った上で上書きする。

.EXAMPLE
  .\install.ps1
  .\install.ps1 -UserName "山田太郎" -UserRole "バックエンドエンジニア"
  .\install.ps1 -Force
#>
[CmdletBinding()]
param(
  [string]$UserName,
  [string]$UserRole,
  [switch]$Force
)

$ErrorActionPreference = 'Stop'

$srcRoot    = Split-Path -Parent $MyInvocation.MyCommand.Path
$srcClaude  = Join-Path $srcRoot 'home-claude'
$target     = Join-Path $env:USERPROFILE '.claude'
$stamp      = Get-Date -Format 'yyyyMMdd-HHmmss'
$backupRoot = Join-Path $target ".stylepack-backup-$stamp"

if (-not (Test-Path $srcClaude)) {
  throw "home-claude/ が見つかりません: $srcClaude"
}

Write-Host "開発スタイルパックを展開します -> $target"
New-Item -ItemType Directory -Force -Path $target | Out-Null

function Backup-IfExists([string]$path) {
  if (Test-Path $path) {
    New-Item -ItemType Directory -Force -Path $backupRoot | Out-Null
    $name = Split-Path -Leaf $path
    Copy-Item -Path $path -Destination (Join-Path $backupRoot $name) -Recurse -Force
    Write-Host "  バックアップ: $name -> $backupRoot"
  }
}

# --- CLAUDE.md ---
# UTF-8(BOMなし)で読み書きする。Windows PowerShell 5.1 は既定が ANSI のため、
# Get-Content/Set-Content の既定だと日本語が文字化けする。.NET 経由で明示する。
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$srcMd = Join-Path $srcClaude 'CLAUDE.md'
$dstMd = Join-Path $target 'CLAUDE.md'
$content = [System.IO.File]::ReadAllText($srcMd, [System.Text.Encoding]::UTF8)
if ($UserName) { $content = $content.Replace('{{USER_NAME}}', $UserName) }
if ($UserRole) { $content = $content.Replace('{{USER_ROLE}}', $UserRole) }

if ((Test-Path $dstMd) -and -not $Force) {
  $side = "$dstMd.stylepack"
  [System.IO.File]::WriteAllText($side, $content, $utf8NoBom)
  Write-Host "  既存 CLAUDE.md を温存。新ルールは $side に書き出しました（手動マージするか -Force で上書き）"
} else {
  Backup-IfExists $dstMd
  [System.IO.File]::WriteAllText($dstMd, $content, $utf8NoBom)
  Write-Host "  CLAUDE.md を配置しました"
}

# --- settings.json ---
$srcSettings = Join-Path $srcClaude 'settings.json'
$dstSettings = Join-Path $target 'settings.json'
if ((Test-Path $dstSettings) -and -not $Force) {
  Copy-Item -Path $srcSettings -Destination "$dstSettings.stylepack" -Force
  Write-Host "  既存 settings.json を温存。推奨設定は settings.json.stylepack に書き出しました（permissions を手動マージ推奨）"
} else {
  Backup-IfExists $dstSettings
  Copy-Item -Path $srcSettings -Destination $dstSettings -Force
  Write-Host "  settings.json を配置しました"
}

# --- skills ---
$srcSkills = Join-Path $srcClaude 'skills'
$dstSkills = Join-Path $target 'skills'
New-Item -ItemType Directory -Force -Path $dstSkills | Out-Null
foreach ($skill in Get-ChildItem -Path $srcSkills -Directory) {
  $dstSkill = Join-Path $dstSkills $skill.Name
  if ((Test-Path $dstSkill) -and -not $Force) {
    Write-Host "  スキップ（既存）: skills/$($skill.Name)  ※上書きするには -Force"
    continue
  }
  if (Test-Path $dstSkill) {
    Backup-IfExists $dstSkill
    Remove-Item -Path $dstSkill -Recurse -Force
  }
  Copy-Item -Path $skill.FullName -Destination $dstSkill -Recurse -Force
  Write-Host "  スキル配置: skills/$($skill.Name)"
}

# --- hooks（session-greeting は settings.json 経由で既定有効。無効化は README 参照） ---
$srcHooks = Join-Path $srcClaude 'hooks'
if (Test-Path $srcHooks) {
  $dstHooks = Join-Path $target 'hooks'
  New-Item -ItemType Directory -Force -Path $dstHooks | Out-Null
  foreach ($h in Get-ChildItem -Path $srcHooks -File) {
    Copy-Item -Path $h.FullName -Destination (Join-Path $dstHooks $h.Name) -Force
    Write-Host "  フック配置: hooks/$($h.Name)"
  }
}

Write-Host ""
Write-Host "完了しました。次の手順:"
Write-Host "  1. ~/.claude/CLAUDE.md の「ユーザープロフィール」のプレースホルダ（{{USER_NAME}} 等）を自分の情報に書き換える"
Write-Host "  2. Claude Code を再起動して設定を読み込む"
Write-Host "  3. 'What Skills are available?' で同梱スキルの読み込みを確認する"
if (Test-Path $backupRoot) {
  Write-Host "  （上書きしたファイルのバックアップ: $backupRoot）"
}
