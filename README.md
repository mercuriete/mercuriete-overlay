# mercuriete-overlay
mercuriete's Gentoo overlay

## How to use this repository?

There are one main method for making use of this repository.

### Layman

You can use the Layman tool to add and sync the repository, read the instructions on the [Gentoo Wiki](https://wiki.gentoo.org/wiki/Layman#Adding_custom_repositories).

The repositories.xml can be found at `https://raw.githubusercontent.com/mercuriete/mercuriete-overlay/master/repositories.xml`.

You (I mean me) can use this command below

```
layman -o https://raw.githubusercontent.com/mercuriete/mercuriete-overlay/master/repositories.xml -f -a mercuriete-overlay
```
