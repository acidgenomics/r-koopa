#' Expected version
#'
#' @note Updated 2021-02-11.
#' @noRd
#'
#' @param x `character`.
#'   Program name.
#'
#' @examples
#' apps <- c("vim", "tmux")
#' .expectedVersion(apps)
#' .expectedMajorVersion(apps)
#' .expectedMinorVersion(apps)
.expectedVersion <- function(x) {
    variablesFile <- file.path(
        koopaPrefix(),
        "include",
        "variables.txt"
    )
    assert(isFile(variablesFile))
    variables <- readLines(variablesFile)
    vapply(
        X = x,
        FUN = function(x) {
            x <- syntactic::kebabCase(x)
            keep <- grepl(pattern = paste0("^", x, "="), x = variables)
            assert(sum(keep, na.rm = TRUE) == 1L)
            x <- variables[keep]
            assert(isString(x))
            x <- sub(
                pattern = "^(.+)=\"(.+)\"(.+)?$",
                replacement = "\\2",
                x = x
            )
            x
        },
        FUN.VALUE = character(1L),
        USE.NAMES = TRUE
    )
}



## Updated 2021-02-11.
.expectedHomebrewCaskVersion <- function(x) {
    .expectedVersion(paste0("homebrew-cask-", x))
}



## Updated 2021-02-11.
.expectedMacOSAppVersion <- function(x) {
    .expectedVersion(x = paste0("macos-app-", tolower(x)))
}



## Updated 2021-02-11.
.expectedMajorVersion <- function(x) {
    x <- .expectedVersion(x)
    x <- sanitizeVersion(x)
    x <- majorVersion(x)
    x
}



## Updated 2021-02-11.
.expectedMinorVersion <- function(x) {
    x <- .expectedVersion(x)
    x <- sanitizeVersion(x)
    x <- minorVersion(x)
    x
}



## Updated 2021-02-11.
.expectedPythonPackageVersion <- function(x) {
    .expectedVersion(x = paste("python", x, sep = "-"))
}



## Updated 2021-02-11.
.expectedRubyPackageVersion <- function(x) {
    .expectedVersion(x = paste("ruby", x, sep = "-"))
}



## Updated 2021-02-11.
.expectedRustPackageVersion <- function(x) {
    .expectedVersion(x = paste("rust", x, sep = "-"))
}
