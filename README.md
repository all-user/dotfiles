# dotfiles

Minimal configuration for an Apple Silicon Mac, bootstrapped with mise.

## Bootstrap

Install Xcode Command Line Tools and clone this repository, then install the
pinned mise release:

```sh
xcode-select --install
git clone https://github.com/all-user/dotfiles.git
cd dotfiles
curl https://mise.run | MISE_VERSION=v2026.7.5 sh
~/.local/bin/mise trust
~/.local/bin/mise bootstrap
```

`mise bootstrap` installs declared tools and packages, checks out pinned Zsh
plugins, links the managed dotfiles, and installs IBM Plex Mono after verifying
its SHA-256 checksum.

On an existing machine, first review the managed targets with
`mise dotfiles status`. The old regular files can then be replaced explicitly:

```sh
~/.local/bin/mise bootstrap --force-dotfiles
```

Install the 1Password desktop app from the official website, then enable CLI
integration and any required shell plugins. The `op` CLI itself is managed by
mise.

## Updates

Tool versions are resolved through the committed `mise.lock`, which is also
linked as the global mise lockfile. Update them explicitly and review both the
config and lockfile changes:

```sh
~/.local/bin/mise upgrade
~/.local/bin/mise lock
```

Zsh plugins are pinned to full commit SHAs in `mise.toml` and must be updated
there intentionally. System packages can be updated with:

```sh
~/.local/bin/mise bootstrap packages upgrade
```
