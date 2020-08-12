#' Expected version
#'
#' @name expectedVersion
#' @note Updated 2020-08-11.
#'
#' @param x `character`.
#'   Program name.
#'
#' @examples
#' apps <- c("vim", "tmux")
#' expectedVersion(apps)
#' expectedMajorVersion(apps)
#' expectedMinorVersion(apps)
NULL



#' @describeIn expectedVersion Expected system command version.
#' @export
expectedVersion <- function(x) {
    variablesFile <- file.path(
        .koopaPrefix(),
        "include",
        "variables.txt"
    )
    assert(isFile(variablesFile))
    variables <- readLines(variablesFile)
    vapply(
        X = x,
        FUN = function(x) {
            x <- kebabCase(x)
            keep <- grepl(pattern = paste0("^", x, "="), x = variables)
            assert(sum(keep, na.rm = TRUE) == 1L)
            x <- variables[keep]
            assert(isString(x))
            x <- sub(pattern = "^(.+)=\"(.+)\"$", replacement = "\\2", x = x)
            x
        },
        FUN.VALUE = character(1L),
        USE.NAMES = TRUE
    )
}



#' @describeIn expectedVersion Expected Homebrew Cask version.
#' @export
expectedHomebrewCaskVersion <- function(x) {
    expectedVersion(paste0("homebrew-cask-", x))
}



#' @describeIn expectedVersion Expected macOS app version.
#' @export
expectedMacOSAppVersion <- function(x) {
    expectedVersion(x = paste0("macos-app-", tolower(x)))
}



#' @describeIn expectedVersion Expected major version.
#' @export
expectedMajorVersion <- function(x) {
    x <- expectedVersion(x)
    x <- sanitizeVersion(x)
    x <- majorVersion(x)
    x
}



#' @describeIn expectedVersion Expected minor version.
#' @export
expectedMinorVersion <- function(x) {
    x <- expectedVersion(x)
    x <- sanitizeVersion(x)
    x <- minorVersion(x)
    x
}
