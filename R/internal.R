#' Koopa emoji
#'
#' @note Updated 2021-01-04.
#' @noRd
.koopaEmoji <- "\U1F422"



#' Check failure
#'
#' Set a system environment variable that we can detect in `koopa check`.
#'
#' @note Updated 2020-08-11.
#' @noRd
.setCheckFail <- function() {
    Sys.setenv("KOOPA_CHECK_FAIL" = 1L)
}



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
