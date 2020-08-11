#' Header level
#'
#' @name header
#' @note Updated 2020-08-11.
#'
#' @examples
#' h1("Level 1")
#' h2("Level 2")
NULL



.h <- function(x, level) {
    arrow <- magenta(paste0(paste0(rep("=", level), collapse = ""), ">"))
    cat(paste0(.koopaEmoji, " ", arrow, " ", x, "\n"))
    invisible(x)
}



#' @rdname header
#' @export
h1 <- function(x) {
    cat("\n")
    .h(x = x, level = 1L)
}



#' @rdname header
#' @export
h2 <- function(x) {
    .h(x = x, level = 2L)
}



#' @rdname header
#' @export
h3 <- function(x) {
    .h(x = x, level = 3L)
}



#' @rdname header
#' @export
h4 <- function(x) {
    .h(x = x, level = 4L)
}



#' @rdname header
#' @export
h5 <- function(x) {
    .h(x = x, level = 5L)
}



#' @rdname header
#' @export
h6 <- function(x) {
    .h(x = x, level = 6L)
}



#' @rdname header
#' @export
h7 <- function(x) {
    .h(x = x, level = 7L)
}
