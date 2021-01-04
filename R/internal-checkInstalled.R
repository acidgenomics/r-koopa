#' Check if program is installed
#'
#' @note Updated 2020-08-11.
#' @noRd
#'
#' @param name `character`.
#'   Program name.
#' @param required `logical(1)`.
#'   Is the program required or optional?
#' @param path `logical(1)`.
#'   Display the path to program.
#'   Calls `Sys.which()` internally.
#'
#' @return `logical`.
#'
#' @examples
#' .checkInstalled("bash")
.checkInstalled <- function(
    name,
    required = TRUE,
    path = FALSE
) {
    assert(
        isCharacter(name),
        isFlag(required),
        isFlag(path)
    )
    statusList <- .status()
    invisible(vapply(
        X = name,
        FUN = function(name) {
            which <- Sys.which(name)
            ok <- nzchar(which)
            if (!isTRUE(ok)) {
                if (isTRUE(required)) {
                    .setCheckFail()
                    status <- statusList[["fail"]]
                } else {
                    status <- statusList[["note"]]
                }
                message(sprintf(
                    fmt = "  %s | %s missing.",
                    status, name
                ))
            } else {
                status <- statusList[["ok"]]
                msg <- sprintf("  %s | %s", status, name)
                if (isTRUE(path)) {
                    msg <- paste0(
                        msg, "\n",
                        sprintf("       |   %.69s", which)
                    )
                }
                message(msg)
            }
            invisible(ok)
        },
        FUN.VALUE = logical(1L)
    ))
}
