Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ($args.Count -lt 1) {
  throw "Usage: .\fork-tools\start-feature.ps1 <feature-name>"
}

$name = $args[0].Trim()
if ($name -notmatch "^[A-Za-z0-9._-]+$") {
  throw "Feature name may contain only letters, numbers, dots, underscores, and hyphens."
}

$branch = "custom/$name"

git fetch origin custom/main
git switch custom/main
git pull --ff-only origin custom/main
git switch -c $branch

Write-Host "Created $branch from custom/main."

