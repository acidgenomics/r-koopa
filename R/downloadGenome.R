#' Download a genome
#'
#' @name downloadGenome
#' @note Updated 2021-01-04.
#'
#' @examples
#' ## > downloadEnsemblGenome()
NULL



#' @rdname downloadGenome
#' @export
downloadEnsemblGenome <- function() {
    input <- parseArgs(
        required = c(
            "organism",
            "genome-build"
        ),
        optional = c(
            "release",
            "type",
            "annotation",
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
    if (isSubset("type", names(input[["optional"]]))) {
        args[["type"]] <- input[["optional"]][["type"]]
    }
    if (isSubset("annotation", names(input[["optional"]]))) {
        args[["annotation"]] <- input[["optional"]][["annotation"]]
    }
    if (isSubset("output-dir", names(input[["optional"]]))) {
        args[["outputDir"]] <- input[["optional"]][["output-dir"]]
    }
    if (isSubset("decompress", names(input[["flags"]]))) {
        args[["decompress"]] <- TRUE
    }
    requireNamespaces("AcidGenomes")
    do.call(
        what = AcidGenomes::downloadEnsemblGenome,
        args = args
    )
}