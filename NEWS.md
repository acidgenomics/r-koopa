## koopa 0.1.10 (2021-03-02)

### New functions

- Added `dockerPruneTags`, which helps prune old tags automatically.

## koopa 0.1.9 (2021-03-02)

### Minor changes

- Added more package version checks: boost, cairo, harfbuzz, icu4c, imagemagick,
  and node.

## koopa 0.1.8 (2021-03-01)

### Minor changes

- Added file size check to `drat`.
- Updated dependency packages.
- Cleaned up NAMESPACE.

## koopa 0.1.7 (2021-02-17)

- `drat`: pkgdown documentation in docs is no longer removed.

## koopa 0.1.6 (2021-02-16)

- `dockerBuildAllTags`: Ignore lines that contain comments in `build.txt` files.

## koopa 0.1.5 (2021-02-15)

- Migrated `checkBinManConsistency` here from main koopa package.

## koopa 0.1.4 (2021-02-15)

- Added version check for GNU tar.
- Updated dependency version cutoffs.

## koopa 0.1.3 (2021-02-11)

- Including checking for GNU binutils on macOS in addition to Linux.

## koopa 0.1.2 (2021-02-06)

- Improved internal argument parsing for syntactic functions.
- `drat`: Added optional override flags: `--no-check`, `--no-pkgdown`,
  and `--no-deploy`.

## koopa 0.1.1 (2021-02-04)

- Updated internal bb8 dependency to renamed AcidDevTools package.
- Migrated `detectHPC` function from basejump, which is more useful for koopa.

## koopa 0.1.0 (2021-01-31)

- Initial stable public release.
- Bug fixes for `drat`.
- Improved genome download support for Ensembl, Gencode, RefSeq, and UCSC.

## koopa 0.0.23 (2020-01-04)

- Added check for bpytop.
- Added check for GNU stow.
- `listPrograms` now excludes `app` directory, as expected.
- Migrated internal R scripts previously defined in koopa package.

## koopa 0.0.22 (2020-12-24)

- Bug fix for GPG Suite version check on macOS.

## koopa 0.0.21 (2020-12-14)

- `parseArgs`: Bug fix for parsing of quoted arguments containing spaces.

## koopa 0.0.20 (2020-12-07)

- Added `hasPositionalArgs` boolean check for user input.

## koopa 0.0.19 (2020-11-19)

- Added groff to system check.
- Removed autojump from system check. Now favoring zoxide instead.

## koopa 0.0.18 (2020-11-12)

- Internal syntax updates reflecting reorganization in main `koopa` program.

## koopa 0.0.17 (2020-11-10)

- `koopaPrefix`: Path resolution fix on Linux.
  Needed to wrap `koopa` bin path in `dirname` call.

## koopa 0.0.16 (2020-11-10)

- Added checks for Rust dog, procs, and starship.
- Added check for ps as a base dependency.

## koopa 0.0.15 (2020-11-06)

- Now requiring bb8 0.2.41+.

## koopa 0.0.14 (2020-11-04)

- Added more suggested packages: BiocManager, covr, desc, lintr, remotes, and
  sessioninfo.
- Removed defunct `installBioconductor` reexport.

## koopa 0.0.13 (2020-11-03)

- Migrated installer functions to bb8: `installAcidverse`,
  `installBioconductor`, and `installDefaultPackages`.

## koopa 0.0.12 (2020-10-29)

- `installDefaultPackages`: Added temporary fix for DelayedArray not currently
  available for Bioc Devel (3.13).
  Requires goalie v0.4.10, which adds `isBiocDevel` check function.
  Also requires bb8 v0.2.34, which adds easy installation from Git repos
  inside the `install` function.

## koopa 0.0.11 (2020-10-28)

- Added new `installAcidverse` function.
- Updated `installDefaultPackages` to call `installAcidverse` internally.

## koopa 0.0.10 (2020-10-26)

- Added support for checking armadillo version.

## koopa 0.0.9 (2020-10-06)

- Renamed acidbase dependency to AcidBase.

## koopa 0.0.8 (2020-09-11)

- Added `realpath` to reexports.

## koopa 0.0.7 (2020-09-08)

- `installDefaultPackages`: Added broom, biobroom, and some other recommended
  packages from r-lib.

## koopa 0.0.6 (2020-08-27)

- `installDefaultPackages`: Removed temporary mgcv build fix for macOS.

## koopa 0.0.5 (2020-08-25)

- `dockerBuildAllTags`: Fix for recently built image check.

## koopa 0.0.4 (2020-08-25)

- `installDefaultPackages`: Added PANTHER.db package.

## koopa 0.0.3 (2020-08-24)

- `installDefaultPackages`: Bug fix for mgcv compilation issue on macOS.

## koopa 0.0.2 (2020-08-17)

- Updated `installDefaultPackages` to install from Acid Genomics drat repo
  rather than from GitHub directly.

## koopa 0.0.1 (2020-08-12)

- Initial commit of koopa R package.
