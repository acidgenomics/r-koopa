#' Current version of installed program
#'
#' @name currentVersion
#' @note Updated 2020-11-12.
#'
#' @param x `character`.
#'   Program names.
#' @param .cmd `character(1)`.
#'   Koopa version command function to call internally via `shell()`.
#'   Intended for use with wrapper functions only.
#'
#' @return `character`.
#'   Version character string.
#'
#' @examples
#' apps <- c("vim", "tmux")
#' if (goalie::allAreSystemCommands(apps)) {
#'     currentVersion(apps)
#'     currentMajorVersion(apps)
#'     currentMinorVersion(apps)
#' }
#'
#' if (goalie::isMacOS()) {
#'     apps <- c("BBEdit", "RStudio")
#'     currentMacOSAppVersion(apps)
#'     casks <- c("bbedit", "rstudio")
#'     currentHomebrewCaskVersion(casks)
#' }
NULL



#' @describeIn currentVersion Current system command version.
#' @export
currentVersion <- function(x, .cmd = "version") {
    vapply(
        X = x,
        .cmd = .cmd,
        FUN = function(x, .cmd) {
            tryCatch(
                expr = shell(
                    command = koopa(),
                    args = c("system", .cmd, paste0("'", x, "'")),
                    stdout = TRUE,
                    stderr = FALSE
                ),
                warning = function(w) NA_character_,
                error = function(e) NA_character_
            )
        },
        FUN.VALUE = character(1L),
        USE.NAMES = TRUE
    )
}



#' @describeIn currentVersion Current Homebrew Cask version.
#' @export
currentHomebrewCaskVersion <- function(x) {
    currentVersion(x = x, .cmd = "homebrew-cask-version")
}



#' @describeIn currentVersion Current macOS app version.
#' @export
currentMacOSAppVersion <- function(x) {
    currentVersion(x = x, .cmd = "macos-app-version")
}



#' @describeIn currentVersion Current major version.
#' @export
currentMajorVersion <- function(x) {
    x <- currentVersion(x)
    if (is.na(x)) return(NA_character_)
    x <- sanitizeVersion(x)
    x <- majorVersion(x)
    x
}



#' @describeIn currentVersion Current minor version.
#' @export
currentMinorVersion <- function(x) {
    x <- currentVersion(x)
    if (is.na(x)) return(NA_character_)
    x <- sanitizeVersion(x)
    x <- minorVersion(x)
    x
}
