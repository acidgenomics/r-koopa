## FIXME NEED TO ADD FLYBASE, REFSEQ.



#' Download a genome
#'
#' @name downloadGenome
#' @note Updated 2021-01-20.
#'
#' @examples
#' ## > downloadEnsemblGenome()
NULL



#' @rdname downloadGenome
#' @export
downloadEnsemblGenome <- function() {
    requireNamespaces("AcidGenomes")
    input <- parseArgs(
        required = "organism",
        optional = c(
            "genome-build",
            "release",
            "output-dir"
        ),
        positional = FALSE
    )
    args <- list()
    args[["organism"]] <- input[["required"]][["organism"]]
    if (isSubset("genome-build", names(input[["optional"]]))) {
        args[["genomeBuild"]] <- input[["optional"]][["genome-build"]]
    }
    if (isSubset("release", names(input[["optional"]]))) {
        args[["release"]] <- input[["optional"]][["release"]]
    }
    if (isSubset("output-dir", names(input[["optional"]]))) {
        args[["outputDir"]] <- input[["optional"]][["output-dir"]]
    }
    do.call(
        what = AcidGenomes::downloadEnsemblGenome,
        args = args
    )
}



#' @rdname downloadGenome
#' @export
downloadGencodeGenome <- function() {
    requireNamespaces("AcidGenomes")
    input <- parseArgs(
        required = c(
            "organism",
            "genome-build"  # FIXME MAKE OPTIONAL
        ),
        optional = c(
            "release",
            "output-dir"
        ),
        flags = "decompress",
        positional = FALSE
    )
    args <- list()
    args[["organism"]] <- input[["required"]][["organism"]]
    args[["genomeBuild"]] <- input[["required"]][["genome-build"]]
    if (isSubset("release", names(input[["optional"]]))) {
        args[["release"]] <- input[["optional"]][["release"]]
    }
    if (isSubset("output-dir", names(input[["optional"]]))) {
        args[["outputDir"]] <- input[["optional"]][["output-dir"]]
    }
    if (isSubset("decompress", names(input[["flags"]]))) {
        args[["decompress"]] <- TRUE
    }
    do.call(
        what = AcidGenomes::downloadGencodeGenome,
        args = args
    )
}
