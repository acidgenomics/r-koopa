#' Download a genome
#'
#' @name downloadGenome
#' @note Updated 2021-01-31.
#'
#' @examples
#' ## Ensembl.
#' ## > downloadEnsemblGenome()
#'
#' ## GENCODE.
#' ## > downloadGencodeGenome()
#'
#' ## RefSeq.
#' ## > downloadRefSeqGenome()
#'
#' ## UCSC.
#' ## > downloadUCSCGenome()
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
        what = AcidGenomes::downloadGencodeGenome,
        args = args
    )
}



#' @rdname downloadGenome
#' @export
downloadRefSeqGenome <- function() {
    requireNamespaces("AcidGenomes")
    input <- parseArgs(
        required = "organism",
        optional = c(
            "taxonomic-group",
            "genome-build",
            "output-dir"
        ),
        positional = FALSE
    )
    args <- list()
    args[["organism"]] <- input[["required"]][["organism"]]
    if (isSubset("genome-build", names(input[["optional"]]))) {
        args[["genomeBuild"]] <- input[["optional"]][["genome-build"]]
    }
    if (isSubset("taxonomic-group", names(input[["optional"]]))) {
        args[["taxonomicGroup"]] <- input[["optional"]][["taxonomic-group"]]
    }
    if (isSubset("output-dir", names(input[["optional"]]))) {
        args[["outputDir"]] <- input[["optional"]][["output-dir"]]
    }
    do.call(
        what = AcidGenomes::downloadRefSeqGenome,
        args = args
    )
}



#' @rdname downloadGenome
#' @export
downloadUCSCGenome <- function() {
    requireNamespaces("AcidGenomes")
    input <- parseArgs(
        required = "organism",
        optional = c(
            "genome-build",
            "output-dir"
        ),
        positional = FALSE
    )
    args <- list()
    args[["organism"]] <- input[["required"]][["organism"]]
    if (isSubset("genome-build", names(input[["optional"]]))) {
        args[["genomeBuild"]] <- input[["optional"]][["genome-build"]]
    }
    if (isSubset("output-dir", names(input[["optional"]]))) {
        args[["outputDir"]] <- input[["optional"]][["output-dir"]]
    }
    do.call(
        what = AcidGenomes::downloadUCSCGenome,
        args = args
    )
}
