#' Koopa paths
#'
#' @name paths
#' @note Updated 2020-08-12.
#' 
#' @examples
#' koopa()
#' koopaPrefix()
NULL



#' @rdname paths
#' @export
koopa <- function() {
    x <- Sys.which("koopa")
    x <- realpath(x)
    x
}



#' @rdname paths
#' @export
koopaPrefix <- function() {
    realpath(file.path(dirname(koopa()), ".."))
}
