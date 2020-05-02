# The history of `man`

## Disambiguation

This repo contains built, prettified HTML man pages for each version of the [linux man pages][linux-man-repo].
 _The History of Man_ may also refer to:
 - [the history of man pages][man-page-history]
 - [the history of humankind][human-history]
 - [the git history of the linux man pages][linux-man-repo]
 - [the linux man pages changelog][linux-man-repo-log]

## Usage

First, obtain a copy of this repo by clone, git submodule, or git archive download.  After that, you can find any of the built release versions of the linux man pages using this repo's git tags. The tags you're looking for would look like `man-pages-5.06`.

## Why build this?

There are some cool tools like [explainshell][explainshell] and [interesting analyses][cli-complexity] based on the man pages.
I'd like to make it easier to make more of them.

## Licensing

The [man-pages announcements file][man-pages-announce] states:
> These man pages are distributed under a variety of copyright licenses.
> Although these licenses permit free distribution of the nroff sources contained in this package, commercial distribution may impose other requirements (e.g., acknowledgment of copyright or inclusion of the raw nroff sources with the commercial distribution).
> If you distribute these man pages commercially, it is your responsibility to figure out your obligations.
> (For many man pages, these obligations require you to distribute nroff sources with any pre-formatted man pages that you provide.)
> Each file that contains nroff source for a man page also contains the author(s) name, email address, and copyright notice.

I've altered the HTML-building script to include the original license in a HTML comment. 

<details><summary>Breakdown of licenses</summary>

```sh
rg -e '\.\\" %%%LICENSE_START' ./external/man-pages \
  | awk -F '(' '{ print $2 }' \
  | awk '
    { x[$1]++ }
    END {
      for (i in x) {
        print x[i] " " i
      }
    }' \
  | sort -n | reverse

# 590 VERBATIM)
# 153 GPLv2+_DOC_FULL)
#  82 GPL_NOVERSION_ONELINE)
#  80 GPLv2+_DOC_ONEPARA)
#  46 BSD_4_CLAUSE_UCB)
#  19 VERBATIM_ONE_PARA)
#  16 GPLv2+_SW_3_PARA)
#  12 PUBLIC_DOMAIN)
#   9 PERMISSIVE_MISC)
#   9 GPLv2+_SW_ONEPARA)
#   5 GPLv2_ONELINE)
#   5 FREELY_REDISTRIBUTABLE)
#   5 BSD_ONELINE_CDROM)
#   5 BSD_3_CLAUSE_UCB)
#   4 GPLv2_MISC)
#   3 VERBATIM_PROF)
#   2 VERBATIM_TWO_PARA)
#   2 GPLv2+)
#   1 MIT)
#   1 MISC)
#   1 <license-type>)
#   1 LDPv1)
#   1 GPLv2+_DOC_MISC)
```

Most of the `VERBATIM` licenses appear to closely-related be GPL variants.

```sh
#!/usr/bin/env bash
tmp=/tmp/h.o.m-licenses;
rm -f $tmp;
for f in $(
  rg -le '\.\\" %%%LICENSE_START\(VERBATIM\)' ./external/man-pages
); do
  (
    rg -Ue 'VERBATIM\)(.*\n){0,}\.\\" %%%' "$f" \
      | tr '\n' ' ' \
      | sed 's/\.\\"//g';
    echo
  ) >> $tmp;
done;
awk '
  { $1=""; x[$0]++ }
  END {
    for (i in x) {
      print x[i] " " substr(i, 0, 200) "..." substr(i, 900, 100)
    }
  }
' < $tmp | sort -nr;
rm -f $tmp;
# 572  Permission is granted to make and distribute verbatim copies of this manual provided the copyright notice and this permission notice are preserved on all copies. Permission is granted to copy and dis...source, must acknowledge the copyright and authors of this work. %%%LICENSE_END
# 10  Permission is granted to make and distribute verbatim copies of this manual provided the copyright notice and this permission notice are preserved on all copies. Permission is granted to copy and dis... the source, must acknowledge the copyright and authors of this work. %%%LICENSE_END
# 2  Permission is granted to make and distribute verbatim copies of this manual provided the copyright notice and this permission notice are preserved on all copies. Permission is granted to copy and dis...source, must acknowledge the copyright and authors of this work. %%%LICENSE_END Other portions are f
# 2  Permission is granted to make and distribute verbatim copies of this manual provided the copyright notice and this permission notice are preserved on all copies. Permission is granted to copy and dis...source, must acknowledge the copyright and author of this work. %%%LICENSE_END
# 2  Permission is granted to make and distribute verbatim copies of this manual provided the copyright notice and this permission notice are preserved on all copies. Permission is granted to copy and dis...ource, must acknowledge the copyright and authors of this work. %%%LICENSE_END
# 1  Permission is granted to make and distribute verbatim copies of this manual provided the copyright notice and this permission notice are preserved on all copies. Permission is granted to copy and dis...source, must acknowledge the copyright and authors of this work. %%%LICENSE_END References consulted
# 1  Permission is granted to make and distribute verbatim copies of this manual provided the copyright notice and this permission notice are preserved on all copies. Permission is granted to copy and dis...source, must acknowledge the copyright and author(s) of this work. %%%LICENSE_END
```
<!-- 
to view each unique line in the licenses, do
rg -le '\.\\" %%%LICENSE_START\(VERBATIM\)' ./external/man-pages \
  | xargs rg -Ue 'VERBATIM\)(.*\n){0,}\.\\" ?%%%' \
  | awk '{ $1=""; x[$0]++ } END { for (i in x) { print x[i] i } }' \
  | sort -nr
 -->
</details>
 
The GPL-3 license file at [./LICENSE](./LICENSE) covers only the code in this repo that builds the HTML man pages.

## Contributing

If you're interested in contrubuting code, see [./CONTRIBUTING.md](./CONTRIBUTING.md). If you're inter

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