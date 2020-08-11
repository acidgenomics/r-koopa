## FIXME MOVE TO GOALIE.

#' Is the package installed and at least the specific version?
#'
#' @export
#' @note Updated 2020-06-24.
#'
#' @param x `character`.
#'   Named character vector.
#'   Name corresponds to package name, and value corresponds to minimum version.
#' @param op `character(1)`.
#'   Mathematical operator.
#'   Defaults to less than or equal to.
#'
#' @return `logical`.
#'   Whether package passes version check.
#'
#' @examples
#' isPackageVersion(
#'     x = c(
#'         "acidgenomics/basejump" = "0.1.0",
#'         "acidgenomics/goalie" = "0.1.0"
#'     )
#' )
isPackageVersion <- function(x, op = ">=") {
    packages <- basename(names(x))
    versions <- package_version(x)
    op <- get(x = op, inherits = TRUE)
    stopifnot(is.primitive(op))
    out <- mapply(
        package = packages,
        version = versions,
        MoreArgs = list(op = op),
        FUN = function(package, version, op) {
            ok <- .isInstalled(package)
            if (!isTRUE(ok)) return(ok)
            current <- packageVersion(package)
            expected <- version
            ok <- op(e1 = current, e2 = expected)
            if (!isTRUE(ok)) return(ok)
            TRUE
        },
        SIMPLIFY = TRUE,
        USE.NAMES = TRUE
    )
    out
}



## FIXME IS THIS IN GOALIE?

#' Is the package installed?
#' @note Updated 2020-06-24.
#' @noRd
.isInstalled <- function(x) {
    stopifnot(requireNamespace("utils", quietly = TRUE))
    # Note that GitHub packages are "owner/repo", so use basename.
    basename(x) %in% rownames(utils::installed.packages())
}
