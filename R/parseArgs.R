#' Parse command line argument flags
#'
#' @export
#' @note Updated 2020-08-09.
#'
#' @param required,optional `character` or `NULL`.
#'   Valid key-value pair argument names.
#'   For example, `aaa` for `--aaa=AAA` or `--aaa AAA`.
#'   Note that `--aaa AAA`-style arguments (note lack of `=`) are not currently
#'   supported.
#' @param flags `character` or `NULL`.
#'   Valid long flag names.
#'   For example, `aaa` for `--aaa`.
#'   Short flags, such as `-r`, are intentionally not supported.
#' @param positional `logical(1)`.
#'   Require positional arguments to be defined.
#'
#' @return `list`.
#'   Named list containing arguments, organized by type:
#'   - `required`
#'   - `optional`
#'   - `flags`
#'   - `positional`
#'
#' @seealso
#' - argparse Python package.
#' - argparser R package.
#' - optparse R package.
#'
#' @examples
#' ## Inside Rscript:
#' ## > args <- parseArgs(
#' ## >     required = c("aaa", "bbb"),
#' ## >     optional = c("ccc", "ddd"),
#' ## >     flags = "force",
#' ## >     positional = TRUE
#' ## > )
#' ## > aaa <- args[["required"]][["aaa"]]
#' ## > force <- "force" %in% args[["flags"]]
#' ## > posArgs <- args[["positional"]]
parseArgs <- function(
    required = NULL,
    optional = NULL,
    flags = NULL,
    positional = FALSE
) {
    assert(
        areDisjointSets(required, optional),
        areDisjointSets(required, flags),
        areDisjointSets(optional, flags),
        isFlag(positional)
    )
    cmdArgs <- commandArgs(trailingOnly = TRUE)
    out <- list(
        required = NULL,
        optional = NULL,
        flags = NULL,
        positional = NULL
    )
    if (!is.null(flags)) {
        flagPattern <- "^--([^=[:space:]]+)$"
        flagArgs <- grep(pattern = flagPattern, x = cmdArgs, value = TRUE)
        cmdArgs <- setdiff(cmdArgs, flagArgs)
        flagNames <- sub(
            pattern = flagPattern,
            replacement = "\\1",
            x = flagArgs
        )
        ok <- flags %in% flagNames
        if (!all(ok)) {
            fail <- flags[!ok]
            stop(sprintf(
                "Invalid flags requested: %s.",
                toString(fail, width = 200L)
            ))
        }
        out[["flags"]] <- flagNames
    }
    if (!is.null(required) || !is.null(optional)) {
        argPattern <- "^--([^=[:space:]]+)=([^[:space:]]+)$"
        args <- grep(pattern = argPattern, x = cmdArgs, value = TRUE)
        cmdArgs <- setdiff(cmdArgs, args)
        names(args) <- sub(pattern = argPattern, replacement = "\\1", x = args)
        args <- sub(pattern = argPattern, replacement = "\\2", x = args)
        if (!is.null(required)) {
            ok <- isSubset(required, names(args))
            if (!all(ok)) {
                fail <- required[!ok]
                stop(sprintf(
                    "Missing required args: %s.",
                    toString(fail, width = 200L)
                ))
            }
            out[["required"]] <- args[required]
            args <- args[!names(args) %in% required]
        }
        if (!is.null(optional) && hasLength(args)) {
            match <- match(x = names(args), table = optional)
            if (any(is.na(match))) {
                fail <- names(args)[is.na(match)]
                stop(sprintf(
                    "Invalid args detected: %s.",
                    toString(fail, width = 200L)
                ))
            }
            out[["optional"]] <- args
        }
    }
    if (isTRUE(positional)) {
        if (!hasLength(cmdArgs) || any(grepl(pattern = "^--", x = cmdArgs))) {
            stop("Positional arguments are required but missing.")
        }
        out[["positional"]] <- cmdArgs
    } else {
        if (hasLength(cmdArgs)) {
            stop(sprintf(
                "Positional arguments are defined but not allowed: %s.",
                toString(cmdArgs, width = 200L)
            ))
        }
    }
    out
}



#' @rdname parseArgs
#' @export
positionalArgs <- function() {
    x <- parseArgs(
        required = NULL,
        optional = NULL,
        flags = NULL,
        positional = TRUE
    )
    x[["positional"]]
}
