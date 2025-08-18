# mercuriete-overlay

mercuriete's Gentoo overlay

[![CI](https://github.com/mercuriete/mercuriete-overlay/workflows/CI/badge.svg)](https://github.com/mercuriete/mercuriete-overlay/actions?query=branch%3A%22main%22)

## How to use this repository?

There is one main method for making use of this repository.

### Layman

You can use the Layman tool to add and sync the repository, read the instructions on the [Gentoo Wiki](https://wiki.gentoo.org/wiki/Layman#Adding_custom_repositories).

The repositories.xml can be found at `https://raw.githubusercontent.com/mercuriete/mercuriete-overlay/main/repositories.xml`.

You (I mean me) can use this command below

```
layman -o https://raw.githubusercontent.com/mercuriete/mercuriete-overlay/main/repositories.xml -f -a mercuriete-overlay
```
