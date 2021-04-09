#' Syntactic naming functions
#'
#' @name syntactic
#' @note Updated 2021-03-10.
NULL



#' @rdname syntactic
#' @export
camelCase <- function() {
    parse <- parseArgs(
        flags = "recursive",
        positional = TRUE
    )
    flags <- parse[["flags"]]
    positional <- parse[["positional"]]
    args <- list(
        "object" = positional,
        "prefix" = FALSE,
        "recursive" = isSubset("recursive", flags),
        "rename" = TRUE,
        "strict" = TRUE
    )
    do.call(what = syntactic::camelCase, args = args)
}



#' @rdname syntactic
#' @export
kebabCase <- function() {
    parse <- parseArgs(
        flags = "recursive",
        positional = TRUE
    )
    flags <- parse[["flags"]]
    positional <- parse[["positional"]]
    args <- list(
        "object" = positional,
        "prefix" = FALSE,
        "recursive" = isSubset("recursive", flags),
        "rename" = TRUE
    )
    do.call(what = syntactic::kebabCase, args = args)
}



#' @rdname syntactic
#' @export
snakeCase <- function() {
    parse <- parseArgs(
        flags = "recursive",
        positional = TRUE
    )
    flags <- parse[["flags"]]
    positional <- parse[["positional"]]
    args <- list(
        "object" = positional,
        "prefix" = FALSE,
        "recursive" = isSubset("recursive", flags),
        "rename" = TRUE
    )
    do.call(what = syntactic::snakeCase, args = args)
}
