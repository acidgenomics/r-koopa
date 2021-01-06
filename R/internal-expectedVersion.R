#' Expected version
#'
#' @note Updated 2021-01-06.
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
            x <- sub(pattern = "^(.+)=\"(.+)\"$", replacement = "\\2", x = x)
            x
        },
        FUN.VALUE = character(1L),
        USE.NAMES = TRUE
    )
}



.expectedHomebrewCaskVersion <- function(x) {
    .expectedVersion(paste0("homebrew-cask-", x))
}



.expectedMacOSAppVersion <- function(x) {
    .expectedVersion(x = paste0("macos-app-", tolower(x)))
}



.expectedMajorVersion <- function(x) {
    x <- .expectedVersion(x)
    x <- sanitizeVersion(x)
    x <- majorVersion(x)
    x
}



.expectedMinorVersion <- function(x) {
    x <- .expectedVersion(x)
    x <- sanitizeVersion(x)
    x <- minorVersion(x)
    x
}
