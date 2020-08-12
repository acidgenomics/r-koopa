#' Unordered list
#'
#' @export
#' @note Updated 2020-08-11.
#'
#' @param x `character(1)`.
#'   Text to be displayed as list items.
#'
#' @examples
#' ul(c("Item 1", "Item 2"))
ul <- function(x) {
    indent <- 4L
    cli_div(theme = list(body = list("margin-left" = indent)))
    cli_ul(items = x)
    cli_end()
    invisible(x)
}
