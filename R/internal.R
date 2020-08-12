#' Check failure
#'
#' Set a system environment variable that we can detect in `koopa check`.
#'
#' @note Updated 2020-08-11.
#' @noRd
#'
#' @examples
#' .checkFail()
.checkFail <- function() {
    Sys.setenv("KOOPA_CHECK_FAIL" = 1L)
}



.koopaEmoji <- "\U1F422"



#' Status labels
#'
#' @note Updated 2020-08-11.
#' @noRd
.status <- function() {
    list(
        fail = red("FAIL"),
        note = yellow("NOTE"),
        ok   = green("  OK")
    )
}
