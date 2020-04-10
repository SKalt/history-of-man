Please do.

# Development environment
We need to use these command-line utilities to run the build eventually:
- `git`
- `man2html`
- `make`

For development, we'll need
- [`git subtrac`][git subtrac] for assistance managing our submodules
- `shellcheck` for linting.

How you get access to them is up to you.
However, I'd recommend the following setup:

Using
- a `go` 1.12+ toolchain
- docker

<details><summary>Debian global setup</summary>

```sh
#!/usr/bin/env bash
# as root
apt-get update &&
  apt-get install \
    make \
    man2html-base \
    git;

go instal git-subtrac
```
</details>

[git subrac]: https://github.com/apenwarr/git-subtrac