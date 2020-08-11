#' Check version
#'
#' @export
#' @note Updated 2020-08-09.
#'
#' @examples
#' checkVersion("tmux")
checkVersion <- function(
    name,
    whichName = NULL,
    current = currentVersion(name),
    expected = expectedVersion(name),
    eval = c("==", ">="),
    required = TRUE
) {
    if (is.null(whichName)) {
        whichName <- name
    }
    if (identical(current, character())) {
        current <- NA_character_
    }
    assert(
        isString(name),
        isString(whichName) || is.na(whichName),
        is(current, "numeric_version") ||
            isString(current) || is.na(current),
        is(expected, "numeric_version") ||
            isString(expected) || is.na(expected),
        isFlag(required)
    )
    eval <- match.arg(eval)
    statusList <- .status()
    if (isTRUE(required)) {
        fail <- statusList[["fail"]]
    } else {
        fail <- statusList[["note"]]
    }
    ## Check to see if program is installed.
    if (is.na(current)) {
        if (isTRUE(required)) {
            .checkFail()
        }
        message(sprintf(
            fmt = "  %s | %s is not installed.",
            fail, name
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
    if (!identical(eval, "==")) {
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
    if (eval == ">=") {
        ok <- current >= expected
    } else if (eval == "==") {
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
        status, name,
        current, eval, expected
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
