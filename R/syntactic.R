#' Syntactic naming functions
#'
#' @name syntactic
#' @note Updated 2021-02-06.
NULL



#' @rdname syntactic
#' @export
camelCase <- function() {
    parse <- parseArgs(
        flags = c("prefix", "recursive", "strict"),
        positional = TRUE
    )
    flags <- parse[["flags"]]
    positional <- parse[["positional"]]
    args <- list(
        "object" = positional,
        "prefix" = isSubset("prefix", flags),
        "recursive" = isSubset("recursive", flags),
        "rename" = TRUE,
        "strict" = isSubset("strict", flags)
    )
    do.call(what = syntactic::camelCase, args = args)
}



#' @rdname syntactic
#' @export
kebabCase <- function() {
    parse <- parseArgs(
        flags = c("prefix", "recursive"),
        positional = TRUE
    )
    flags <- parse[["flags"]]
    positional <- parse[["positional"]]
    args <- list(
        "object" = positional,
        "prefix" = isSubset("prefix", flags),
        "recursive" = isSubset("recursive", flags),
        "rename" = TRUE
    )
    do.call(what = syntactic::kebabCase, args = args)
}



#' @rdname syntactic
#' @export
snakeCase <- function() {
    parse <- parseArgs(
        flags = c("prefix", "recursive"),
        positional = TRUE
    )
    flags <- parse[["flags"]]
    positional <- parse[["positional"]]
    args <- list(
        "object" = positional,
        "prefix" = isSubset("prefix", flags),
        "recursive" = isSubset("recursive", flags),
        "rename" = TRUE
    )
    do.call(what = syntactic::snakeCase, args = args)
}
