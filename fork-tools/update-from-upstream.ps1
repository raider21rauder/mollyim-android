Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$upstreamRemote = "upstream"
$upstreamBranch = "main"
$customBranch = "custom/main"

$status = git status --porcelain
if ($status) {
  throw "Working tree is not clean. Commit or stash your changes before updating."
}

git config rerere.enabled true
git fetch $upstreamRemote $upstreamBranch
git fetch origin $customBranch

git switch $customBranch
git pull --ff-only origin $customBranch

$upstreamRef = "$upstreamRemote/$upstreamBranch"
if (git merge-base --is-ancestor $upstreamRef HEAD) {
  Write-Host "$customBranch already contains $upstreamRef."
  exit 0
}

Write-Host "Rebasing $customBranch onto $upstreamRef..."
git rebase $upstreamRef

Write-Host "Rebase complete. Run your build/tests, then push with:"
Write-Host "  git push --force-with-lease origin $customBranch"

