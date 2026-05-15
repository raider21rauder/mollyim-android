Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$workflow = ".github/workflows/upstream-sync.yml"

if (-not (Test-Path $workflow)) {
  throw "$workflow is missing."
}

$status = git status --porcelain
$allowed = "?? $workflow"
$unexpected = @(
  $status -split "`n" |
    Where-Object { $_.Trim() } |
    Where-Object { $_.Trim().Replace("\", "/") -ne $allowed }
)

if ($unexpected.Count -gt 0) {
  throw "Commit or stash unrelated changes before enabling the workflow."
}

Write-Host "GitHub requires the workflow OAuth scope before workflow files can be pushed."
Write-Host "If this opens an interactive browser prompt, complete it and rerun this script if needed."
gh auth refresh -h github.com -s workflow

git add $workflow
git commit -m "Enable automated upstream sync"
git push origin custom/main

Write-Host "GitHub Actions upstream sync is enabled."
