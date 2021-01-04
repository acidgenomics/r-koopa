#' Syntactic naming functions
#'
#' @name syntactic
#' @note Updated 2020-01-04.
NULL



#' @rdname syntactic
#' @export
camelCase <- function() {
    args <- parseArgs(
        flags = c("prefix", "recursive", "strict"),
        positional = TRUE
    )
    positional <- args[["positional"]]
    prefix <- "prefix" %in% args[["flags"]]
    recursive <- "recursive" %in% args[["flags"]]
    strict <- "strict" %in% args[["flags"]]
    syntactic::camelCase(
        object = positional,
        rename = TRUE,
        recursive = recursive,
        strict = strict,
        prefix = prefix
    )
}



#' @rdname syntactic
#' @export
kebabCase <- function() {
    args <- parseArgs(
        flags = c("prefix", "recursive"),
        positional = TRUE
    )
    positional <- args[["positional"]]
    prefix <- "prefix" %in% args[["flags"]]
    recursive <- "recursive" %in% args[["flags"]]
    syntactic::kebabCase(
        object = positional,
        rename = TRUE,
        recursive = recursive,
        prefix = prefix
    )
}



#' @rdname syntactic
#' @export
snakeCase <- function() {
    args <- parseArgs(
        flags = c("prefix", "recursive"),
        positional = TRUE
    )
    positional <- args[["positional"]]
    prefix <- "prefix" %in% args[["flags"]]
    recursive <- "recursive" %in% args[["flags"]]
    syntactic::snakeCase(
        object = positional,
        rename = TRUE,
        recursive = recursive,
        prefix = prefix
    )
}
