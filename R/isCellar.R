#' Is a system command cellarized?
#'
#' @export
#' @note Updated 2020-08-11.
#'
#' @param x `character`.
#'   Application name.
#' @param pattern `character(1)`.
#'   Case insensitive file path pattern matching string.
#'
#' @examples
#' isCellar(c("vim", "tmux"))
isCellar <- function(x, pattern = "/cellar/") {
    which <- Sys.which(x)
    ok <- all(nzchar(which))
    if (!isTRUE(ok)) return(FALSE)
    which <- realpath(which)
    grepl(pattern = pattern, x = which, ignore.case = TRUE)
}
