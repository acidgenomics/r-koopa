#' Check version
#'
#' @export
#' @note Updated 2020-08-11.
#'
#' @param name `character(1)`.
#'   Program name.
#'   `current` and `expected` arguments use this value for version checks when
#'   they are left unset.
#' @param nameFancy `character(1)` or `NULL`..
#'   Fancy name for use in check messages.
#'   Inherits `name` when left `NULL`.
#' @param current,expected `character(1)`.
#'   Current or expected version number.
#' @param whichName `character(1)`, `missing`, or `NULL`.
#'   Program name to check in `PATH`.
#'   Inherits from `name` when left unset.
#'   Set `NULL` to skip any additional `PATH` checks.
#' @param op `character(1)`.
#'   Operator to use for evaluation.
#' @param required `logical(1)`.
#'   Is the program required or optional?
#'
#' @return Invisible `logical`.
#'
#' @examples
#' checkVersion("tmux")
checkVersion <- function(
    name,
    nameFancy = NULL,
    current = currentVersion(name),
    expected = expectedVersion(name),
    whichName,
    op = c("==", ">="),
    required = TRUE
) {
    if (is.null(nameFancy))
        nameFancy <- name
    if (identical(current, character()))
        current <- NA_character_
    if (missing(whichName))
        whichName <- name
    assert(
        isString(name),
        isString(nameFancy),
        is(current, "numeric_version") ||
            isString(current) || is.na(current),
        is(expected, "numeric_version") ||
            isString(expected) || is.na(expected),
        isString(whichName) || is.na(whichName),
        isFlag(required)
    )
    op <- match.arg(op)
    statusList <- .status()
    if (isTRUE(required)) {
        fail <- statusList[["fail"]]
    } else {
        fail <- statusList[["note"]]
    }
    ## Check to see if program is installed.
    if (is.na(current)) {
        if (isTRUE(required)) .checkFail()
        message(sprintf(
            fmt = "  %s | %s is not installed.",
            fail, nameFancy
        ))
        return(invisible(FALSE))
    }
    ## Normalize the program path, if applicable.
    if (is.na(whichName)) {
        which <- NA_character_
    } else {
        which <- unname(Sys.which(whichName))
        assert(isCharacter(which))
    }
    ## Sanitize the version for non-identical (e.g. GTE) comparisons.
    if (!identical(op, "==")) {
        if (grepl("\\.", current)) {
            current <- sanitizeVersion(current)
            current <- package_version(current)
        }
        if (grepl("\\.", expected)) {
            expected <- sanitizeVersion(expected)
            expected <- package_version(expected)
        }
    }
    ## Compare current to expected version.
    if (op == ">=") {
        ok <- current >= expected
    } else if (op == "==") {
        ok <- current == expected
    }
    if (isTRUE(ok)) {
        status <- statusList[["ok"]]
    } else {
        if (isTRUE(required)) {
            .checkFail()
        }
        status <- fail
    }
    msg <- sprintf(
        fmt = "  %s | %s (%s %s %s)",
        status, nameFancy,
        current, op, expected
    )
    if (!is.na(which)) {
        msg <- paste(
            msg,
            sprintf(
                fmt = "       |   %.69s",
                which
            ),
            sep = "\n"
        )
    }
    message(msg)
    invisible(ok)
}



#' @describeIn checkVersion Check macOS app version.
#' @export
checkMacOSAppVersion <- function(name) {
    invisible(vapply(
        X = name,
        FUN = function(name) {
            checkVersion(
                name = name,
                whichName = NA,
                current = currentMacOSAppVersion(name),
                expected = expectedMacOSAppVersion(name)
            )
        },
        FUN.VALUE = logical(1L)
    ))
}



#' @describeIn checkVersion Check Homebrew Cask version.
#' @export
checkHomebrewCaskVersion <- function(name) {
    invisible(vapply(
        X = name,
        FUN = function(name) {
            checkVersion(
                name = name,
                whichName = NA,
                current = currentHomebrewCaskVersion(name),
                expected = expectedHomebrewCaskVersion(name)
            )
        },
        FUN.VALUE = logical(1L)
    ))
}
