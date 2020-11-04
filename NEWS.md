## koopa 0.0.14 (2020-11-04)

- Added more suggested packages: BiocCheck, BiocManager, covr, desc, lintr,
  remotes, and sessioninfo.

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
