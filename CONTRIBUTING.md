Please do.

If you see inaccuracies in any of the nroff man pages, please submit patches to [the linux man pages repo][linux-man-repo].
Make sure to read through their contribution guidelines and search their mailing list archives for similar before submitting bug reports or patches. 

Feel free to report bugs in the build process to [the github issue tracker](https://github.com/skalt/history-of-man/issues).
Since this is free software, the maintainers have no obligation to look at, respond to, or fix reported issues.
Issues with reproduction steps and work on a fix are most likely to be addressed.
Similar considerations apply to feature requests submitted via the issue tracker.

## Development environment

We need to use these command-line utilities to run the build eventually:
- `git`
- `man2html`
- `make`
- `parallel`, aka gnu parallel

For development, we'll need

- [`git subtrac`][git-subtrac] for assistance vendoring our submodules
- `shellcheck` for linting.

How you get access to them is up to you.
However, I'd recommend the following setup:

Using
- a `go` 1.13+ toolchain
- `docker`

<details><summary>Debian global setup</summary>

```sh
#!/usr/bin/env bash
# as root
apt-get update &&
  apt-get install \
    make \
    man2html-base \
    git;
# if possible 
apt-get install parallel
go install git-subtrac
```
</details>

[git-subtrac]: https://github.com/apenwarr/git-subtrac
[linux-man-repo]: https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
