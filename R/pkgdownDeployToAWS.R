#' Deploy a pkgdown website to AWS S3 bucket
#'
#' @name pkgdownDeployToAWS
#' @note Updated 2021-03-01.
#'
#' @return `logical(1)`.
#'
#' @examples
#' ## > pkgdownDeployToAWS()
NULL



#' Deploy pkgdown website to AWS S3
#'
#' @note Updated 2021-03-01.
#' @noRd
.pkgdownDeployToAWS <- function(
    package = ".",
    bucketDir = "s3://r.acidgenomics.com/packages",
    clean = TRUE
) {
    requireNamespaces(c("desc", "pkgdown"))
    assert(isSystemCommand("aws"))
    pkgDir <- realpath(package)
    descFile <- file.path(pkgDir, "DESCRIPTION")
    assert(isAFile(descFile))
    pkgName <- desc::desc_get_field(key = "Package", file = descFile)
    bucketDir <- pasteURL(bucketDir, tolower(pkgName))
    docsDir <- file.path(pkgDir, "docs")
    configFile <- file.path(pkgDir, "_pkgdown.yml")
    if (!isAFile(configFile)) {
        alertWarning(sprintf(
            "pkgdown not enabled for {.pkg %s} at {.path %s}. Skipping.",
            pkgName, pkgDir
        ))
        return(invisible(FALSE))
    }
    alert(sprintf(
        paste(
            "Building pkgdown website for {.pkg %s} at {.path %s},",
            "then pushing to AWS S3 bucket at {.url %s}."
        ),
        pkgName, docsDir, bucketDir
    ))
    if (isTRUE(clean)) {
        unlink(docsDir, recursive = TRUE)
    }
    pkgdown::build_site(pkg = pkgDir)
    shell(
        command = "aws",
        args = c(
            "s3", "sync", "--delete",
            paste0(docsDir, "/"),
            paste0(bucketDir, "/")
        )
    )
    if (isTRUE(clean)) {
        unlink(docsDir, recursive = TRUE)
    }
    invisible(TRUE)
}



#' @rdname pkgdownDeployToAWS
#' @export
pkgdownDeployToAWS <- function() {
    args <- list()
    parse <- parseArgs(
        flags = "no-clean",
        optional = c("bucket-dir", "package"),
        positional = FALSE
    )
    flags <- parse[["flags"]]
    optional <- parse[["positional"]]
    if (isSubset("package", names(optional))) {
        args[["package"]] <- optional[["package"]]
    }
    if (isSubset("bucket-dir", names(optional))) {
        args[["bucketDir"]] <- optional[["bucket-dir"]]
    }
    if (isSubset("no-clean", flags)) {
        args[["clean"]] <- FALSE
    }
    do.call(what = .pkgdownDeployToAWS, args = args)
}
