# The History of MAN(1)


## Disambiguation
This repo contains built, prettified HTML man pages for each version of the [linux man pages][linux-man-repo].
 _The History of Man_ may also refer to:
 - [the history of man pages][man-page-history]
 - [the history of humankind][human-history].
 - [the git history of the linux man pages][linux-man-repo-history][linux-man-repo-log]

## Why build this?
There are some really cool tools like [explainshell][explainshell] built on top of man pages. I'd like to make it easier to make more of them.

## Licensing
The man pages include their own copyrights. The license file at [./LICENSE](./LICENSE) covers only the code in this repo that builds the HTML man pages.

## TODO:

[ ] automate syncing of man page history (on new tags?)

[ ]  create history in branch `history` with just the milestones (each commit == 1 git tag) to diff the tagged versions

[ ] correlate dates with versions (ISO)

<!-- References: -->

[linux-man-repo]: https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
[linux-man-repo-log]: https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/log/
[man-page-history]: https://en.wikipedia.org/wiki/Man_page#History
[human-history]: https://en.wikipedia.org/wiki/Human_evolution

[explainshell]: https://www.explainshell.com/

<!-- other links:
  https://github.com/tldr-pages/tldr
  https://salsa.debian.org/debian/man-db ?
  http://www.kylheku.com/cgit/man/
  https://bazaar.launchpad.net/~ubuntu-manpage-repository-dev/ubuntu-manpage-repository/trunk/files
-->