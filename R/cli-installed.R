#' Program installation status
#'
#' @note Updated 2020-08-09.
#' @noRd
installed <- function(
    which,
    required = TRUE,
    path = TRUE
) {
    assert(
        isCharacter(which),
        isFlag(required),
        isFlag(path)
    )
    statusList <- .status()
    invisible(vapply(
        X = which,
        FUN = function(which) {
            ok <- nzchar(Sys.which(which))
            if (!isTRUE(ok)) {
                if (isTRUE(required)) {
                    .checkFail()
                    status <- statusList[["fail"]]
                } else {
                    status <- statusList[["note"]]
                }
                message(sprintf(
                    fmt = "  %s | %s missing.",
                    status, which
                ))
            } else {
                status <- statusList[["ok"]]
                msg <- sprintf("  %s | %s", status, which)
                if (isTRUE(path)) {
                    msg <- paste0(
                        msg, "\n",
                        sprintf("       |   %.69s", Sys.which(which))
                    )
                }
                message(msg)
            }
            invisible(ok)
        },
        FUN.VALUE = logical(1L)
    ))
}
