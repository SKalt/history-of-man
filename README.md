# The history of `man`


## Disambiguation
This repo contains built, prettified HTML man pages for each version of the [linux man pages][linux-man-repo].
 _The History of Man_ may also refer to:
 - [the history of man pages][man-page-history]
 - [the history of humankind][human-history]
 - [the git history of the linux man pages][linux-man-repo-history]
 - [the linux man pages changelog][linux-man-repo-log]

## Why build this?

There are some cool tools like [explainshell][explainshell] and [interesting analyses][cli-complexity] based on the man pages.
I'd like to make it easier to make more of them.

## Licensing

The raw nroff man pages include their copyrights; I've modified the buld script to 

The [man-pages announcements file][man-pages-announce] states:
> These man pages are distributed under a variety of copyright licenses.
> Although these licenses permit free distribution of the nroff sources contained in this package, commercial distribution may impose other requirements (e.g., acknowledgment of copyright or inclusion of the raw nroff sources with the commercial distribution).
> If you distribute these man pages commercially, it is your responsibility to figure out your obligations.
> (For many man pages, these obligations require you to distribute nroff sources with any pre-formatted man pages that you provide.)
> Each file that contains nroff source for a man page also contains the author(s) name, email address, and copyright notice.

<!-- 
rg -e '\.\\" %%%LICENSE_START' ./external/man-pages \
  | awk -F '(' '{ print $2 }' \
  | awk '{ x[$1]++ } END { for (i in x) { print x[i] " " i } }' \
  | sort -n

rg -le '\.\\" %%%LICENSE_START\(VERBATIM\)' ./external/man-pages \
  | xargs rg -Ue 'VERBATIM\)(.*\n){20}' \
  | awk '{ $1=""; x[$0]++ } END { for (i in x) { print x[i] i } }' \
  | sort -n
 -->
 
The license file at [./LICENSE](./LICENSE) covers only the code in this repo that builds the HTML man pages.

## TODO:

[ ] automate syncing of man page history (on new tags?)

<!-- References: -->

[linux-man-repo]: https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
[linux-man-repo-log]: https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/log/
[man-page-history]: https://en.wikipedia.org/wiki/Man_page#History
[human-history]: https://en.wikipedia.org/wiki/Human_evolution

[man-pages-announce]: https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/tree/man-pages-5.07.Announce#n50

[explainshell]: https://www.explainshell.com/
[cli-complexity]: https://danluu.com/cli-complexity/

<!-- other links:
  https://github.com/tldr-pages/tldr
  https://salsa.debian.org/debian/man-db ?
  http://www.kylheku.com/cgit/man/
  https://bazaar.launchpad.net/~ubuntu-manpage-repository-dev/ubuntu-manpage-repository/trunk/files
-->