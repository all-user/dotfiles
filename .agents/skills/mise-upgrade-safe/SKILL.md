---
name: mise-upgrade-safe
description: Project-local procedure for safely reviewing and applying updates for tools declared in mise.toml. Use only when the user explicitly invokes this skill.
disable-model-invocation: true
---

# Safe Mise Upgrade

Use this procedure only after the user explicitly invokes this skill. Review and apply only qualifying updates for the current project. Keep a release-age safety window of 3 days by default, and allow the caller to override it explicitly (for example, `--release-age 7d` or `--release-age 0d`). Always perform and report a dry run before changing files or installing anything.

## Workflow

### 1. Inspect the project

- Work from the repository containing `mise.toml`.
- Read `[tools]` and `mise.lock`; preserve unrelated user changes.
- Check the worktree before editing with `git status --short`.
- Treat `[tools]` entries as the primary managed tool set. Inspect bootstrap packages separately, but do not upgrade Homebrew packages unless the request explicitly includes them.

### 2. Determine candidates and release age

Use the configured version expression and the lockfile's current version. Obtain the latest stable version and its publication time from the authoritative backend:

- GitHub-backed tools: inspect the repository's stable Releases API/page; exclude drafts, prereleases, and preview builds.
- Core tools such as Node, Go, Python, and Ruby: use the official release feed/page or the backend metadata used by mise.
- Use `mise outdated --local --json` and `mise ls-remote <tool>` to establish the version candidates, but do not infer publication dates from version numbers alone.

For each tool, compare the latest stable release time with `now - release_age`.

- If the latest release is older than or equal to the cutoff, leave that tool unchanged, even if it is outdated.
- If the latest release is newer than the cutoff, select the immediately preceding stable version available from `mise ls-remote`. Skip missing, prerelease, or yanked versions. If no safe predecessor exists, report the tool and do not change it.
- If the configured/current version is already the selected predecessor, report it as already compliant.

The default cutoff is 3 days. Change it only when the user supplies an option or explicitly requests another window. Never silently choose a different window.

### 3. Run the dry run first

Before editing `mise.toml`, installing a tool, or updating `mise.lock`, present a dry-run report containing:

- tool name;
- current and latest versions;
- latest release timestamp and the cutoff used;
- selected target version (the predecessor when latest is inside the safety window);
- the exact `mise.toml` and expected `mise.lock` changes;
- an authoritative release link for the latest version and the selected target version;
- the command output from `mise upgrade <selected-tools> --dry-run --local` (or an equivalent dry-run command when the config has not yet been pinned).

For a request that only asks for a check/dry run, stop after this report. If the user asked to execute the update, continue automatically after showing the dry-run result; otherwise ask for confirmation before applying it.

The dry run must not mutate the repository or install tools. If network access or mise's cache permissions prevent the check, report the failure and request the needed access rather than guessing release dates.

### 4. Apply only qualifying updates

For every approved candidate:

1. Change its `mise.toml` entry from a floating expression such as `latest` to the selected predecessor version. Do not change non-qualifying tools.
2. Run `mise upgrade <tool> --yes --local` for the selected tools. This installs the target and refreshes `mise.lock` when lockfiles are enabled.
3. Do not run an unrestricted `mise upgrade` that would also move tools whose latest release is outside the qualifying window.

Use `apply_patch` for configuration edits. Preserve formatting and unrelated changes.

### 5. Verify and report

Run:

```sh
mise current <updated-tools>
mise upgrade <updated-tools> --dry-run --local
git diff --check
git diff -- mise.toml mise.lock
git status --short
```

The final report must state the release-age option used, qualifying tools, target versions, commands run, files changed, and intentionally skipped outdated tools. Confirm that the post-update dry run reports the selected tools as up to date.

## Safety rules

- Never replace a recent latest release with that latest version; pin the immediately preceding stable version.
- Never treat a prerelease or preview as the latest stable release.
- Never update unrelated tools merely because `mise outdated` lists them.
- Never overwrite or revert existing user changes in `mise.toml` or `mise.lock`.
- If the predecessor cannot be determined reliably, stop that tool's update and explain why.
