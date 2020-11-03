#' Install Bioconductor
#'
#' @details
#' - Installs BiocManager package automatically, if necessary.
#' - Calls [BiocManager::install()] internally.
#'
#' @export
#' @note Updated 2020-11-03.
#'
#' @param version `character(1)`.
#'   Bioconductor release version.
#'   If left unset, defaults to latest release.
#'
#' @return Status from [BiocManager::install()].
#'
#' @seealso [BiocManager::version()].
#'
#' @examples
#' ## > installBioconductor()
installBioconductor <- function(
    version = Sys.getenv("BIOC_VERSION")
) {
    version <- as.character(version)
    h1(sprintf(
        "Installing Bioconductor %s.",
        ifelse(
            test = isString(version),
            yes = version,
            no = "(latest release)"
        )
    ))
    if (!requireNamespace("BiocManager", quietly = TRUE)) {
        install.packages("BiocManager")
    }
    requireNamespaces("BiocManager")
    if (!isString(version)) {
        version <- BiocManager::version()
    }
    BiocManager::install(
        update = FALSE,
        ask = FALSE,
        version = version
    )
}
