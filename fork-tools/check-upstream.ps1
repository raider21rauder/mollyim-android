Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$upstreamRemote = "upstream"
$upstreamBranch = "main"
$customBranch = "custom/main"

git fetch $upstreamRemote $upstreamBranch
git fetch origin $customBranch

$upstreamRef = "$upstreamRemote/$upstreamBranch"
$customRef = "origin/$customBranch"

$base = git merge-base $customRef $upstreamRef
$upstreamHead = git rev-parse $upstreamRef
$customHead = git rev-parse $customRef

Write-Host "Custom branch:   $customRef $customHead"
Write-Host "Upstream branch: $upstreamRef $upstreamHead"
Write-Host "Merge base:      $base"

if ($base -eq $upstreamHead) {
  Write-Host "custom/main already contains the latest upstream main."
  exit 0
}

Write-Host "Upstream has new commits. Run .\fork-tools\update-from-upstream.ps1"
git log --oneline "$customRef..$upstreamRef" --max-count=20

