#' Check version
#'
#' @note Updated 2021-04-06.
#' @noRd
#'
#' @param name `character(1)`.
#'   Program name.
#'   `current` and `expected` arguments use this value for version checks when
#'   they are left unset.
#' @param nameFancy `character(1)` or `NULL`..
#'   Fancy name for use in check messages.
#' @param current,expected `character(1)`.
#'   Current or expected version number.
#' @param op `character(1)`.
#'   Operator to use for evaluation.
#' @param required `logical(1)`.
#'   Is the program required or optional?
#' @param ... Passthrough to `checkVersion()`.
#'
#' @return Invisible `logical`.
#'
#' @examples
#' .checkVersion("tmux")
.checkVersion <- function(
    name,
    nameFancy = NULL,
    current = .currentVersion(name),
    expected = .expectedVersion(name),
    op = c("==", ">="),
    required = TRUE
) {
    if (is.null(nameFancy)) {
        nameFancy <- name
    }
    if (identical(current, character())) {
        current <- NA_character_
    }
    assert(
        isString(name),
        isString(nameFancy),
        is(current, "numeric_version") ||
            isString(current) || is.na(current),
        is(expected, "numeric_version") ||
            isString(expected) || is.na(expected),
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
        if (isTRUE(required)) {
            .setCheckFail()
        }
        message(sprintf(
            fmt = "  %s | %s is not installed.",
            fail, nameFancy
        ))
        return(invisible(FALSE))
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
            .setCheckFail()
        }
        status <- fail
    }
    message(sprintf(
        fmt = "  %s | %s (%s %s %s)",
        status, nameFancy,
        current, op, expected
    ))
    invisible(ok)
}



## Updated 2021-02-11.
.checkGNUVersion <- function(name, ...) {
    .checkVersion(
        name = name,
        nameFancy = paste("GNU", name),
        ...
    )
}



## Updated 2021-02-11.
.checkHomebrewCaskVersion <- function(name, ...) {
    .checkVersion(
        name = name,
        current = .currentHomebrewCaskVersion(name),
        expected = .expectedHomebrewCaskVersion(name),
        ...
    )
}



## Updated 2021-02-11.
.checkMacOSAppVersion <- function(name, ...) {
    .checkVersion(
        name = name,
        current = .currentMacOSAppVersion(name),
        expected = .expectedMacOSAppVersion(name),
        ...
    )
}



## Updated 2021-02-11.
.checkPythonPackageVersion <- function(
    name,
    op = c("==", ">="),
    required = TRUE
) {
    .checkVersion(
        name = name,
        nameFancy = NULL,
        current = .currentVersion(name),
        expected = .expectedPythonPackageVersion(name),
        op = match.arg(op),
        required = required
    )
}



## Updated 2021-02-11.
.checkRubyPackageVersion <- function(
    name,
    op = c("==", ">="),
    required = TRUE
) {
    .checkVersion(
        name = name,
        nameFancy = NULL,
        current = .currentVersion(name),
        expected = .expectedRubyPackageVersion(name),
        op = match.arg(op),
        required = required
    )
}



## Updated 2021-02-11.
.checkRustPackageVersion <- function(
    name,
    op = c("==", ">="),
    required = TRUE
) {
    .checkVersion(
        name = name,
        nameFancy = NULL,
        current = .currentVersion(name),
        expected = .expectedRustPackageVersion(name),
        op = match.arg(op),
        required = required
    )
}
