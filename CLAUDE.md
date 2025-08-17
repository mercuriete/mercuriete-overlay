# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Gentoo Linux overlay repository that provides custom ebuilds (package definitions) for software not available in the official Gentoo repository. The overlay follows standard Gentoo conventions and serves packages across multiple categories.

## Architecture and Structure

### Ebuild Patterns
- **Standard ebuilds**: Version-specific packages following `package-name-version.ebuild` format
- **Live ebuilds**: Development versions using `package-name-9999.ebuild` for git sources
- **Binary packages**: Pre-compiled packages that install binaries (e.g., terraform-bin, aws-sam-cli)
- **Source packages**: Packages that compile from source (e.g., corectrl, nvtop)

### Package Categories
- `app-admin/`: Administrative and DevOps tools
- `app-forensics/`: Security and forensics tools  
- `app-misc/`: General applications
- `dev-db/`: Database tools
- `games-action/`: Gaming applications
- `kde-misc/`: KDE utilities and applications
- `sys-process/`: System monitoring tools

### Metadata Structure
- `metadata/layout.conf`: Overlay configuration (masters=gentoo, manifest settings)
- `metadata/md5-cache/`: Auto-generated cache files (do not edit manually)
- `profiles/repo_name`: Contains overlay name identifier
- `repositories.xml`: Layman overlay definition

## Development Commands

### Quality Assurance
```bash
# Run pkgcheck for quality assurance (used in CI)
pkgcheck ci --exit error,warning,style

# Check specific package
pkgcheck scan category/package-name
```

### Manifest Management
```bash
# Generate/update manifest for a package (run from package directory)
sudo pkgdev manifest
```

### Testing
```bash
# Install package locally for testing
emerge package-name

# Test ebuild phases
ebuild package-version.ebuild clean compile install
```

## CI/CD Pipeline

The repository uses GitHub Actions with:
- **Trigger**: Pushes to main, PRs to main, weekly schedule
- **Environment**: Gentoo Stage3 container 
- **Validation**: Uses `pkgcheck ci` for quality assurance
- **Automated updates**: Renovate bot for dependency management

## Ebuild Development Guidelines

### Binary Package Pattern (terraform-bin, aws-sam-cli)
- Download pre-compiled binaries from upstream releases
- Simple installation to `/opt/` or `/usr/local/`
- Use `dosym` for creating symlinks to `/usr/bin/`

### Source Package Pattern (corectrl)
- Inherit appropriate eclasses (`ecm` for KDE apps, `git-r3` for live ebuilds)
- Define comprehensive dependencies (DEPEND, RDEPEND, BDEPEND)
- Handle both stable versions and live git sources

### Version Handling
- Live ebuilds (9999) should inherit `git-r3` and use `EGIT_REPO_URI`
- Stable versions use `SRC_URI` with upstream release URLs
- Keywords typically include `~amd64` for testing architecture
- **Repository Convention**: The 9999 ebuild contains the actual content, stable version ebuilds are symlinks created with `ln -s package-name-9999.ebuild package-name-version.ebuild`

### Manifest Requirements
- All ebuilds must have corresponding Manifest files
- Manifests use BLAKE2B and SHA512 hashes
- Generated automatically but must be committed to repository
