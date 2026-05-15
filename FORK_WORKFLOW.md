# Molly fork workflow

This fork is set up so local changes can be reapplied onto new Molly releases
with as little manual work as Git allows.

## Branch model

- `main` tracks `mollyim/mollyim-android:main` and should stay clean.
- `custom/main` is your working branch. Put your own changes here.
- Short-lived feature branches should start from `custom/main`.

Keep custom changes as small, focused commits. When upstream changes land, Git
can usually replay those commits automatically. If a conflict happens, resolve it
once; `git rerere` is enabled locally so Git can remember the resolution.

## Daily update path

GitHub Actions runs `.github/workflows/upstream-sync.yml` on a schedule and on
manual dispatch. It fetches `mollyim/mollyim-android:main`, rebases
`custom/main` onto it, and opens or updates an `automation/upstream-sync` pull
request when the rebase succeeds.

If the workflow fails, upstream changed the same area as your customization. In
that case, run the local update script, resolve conflicts, test, and push.

## Local commands

Check whether upstream has moved:

```powershell
.\fork-tools\check-upstream.ps1
```

Update your custom branch:

```powershell
.\fork-tools\update-from-upstream.ps1
```

Start a feature branch:

```powershell
.\fork-tools\start-feature.ps1 my-change-name
```

## Rules that keep updates easy

- Do not edit `main` directly.
- Prefer small custom commits over one large mixed commit.
- Put unrelated ideas on separate branches.
- Rebase feature branches onto `custom/main` before merging them.
- Let CI/open PRs be the place where upstream updates are reviewed.

