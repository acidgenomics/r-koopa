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
    parse <- parseArgs(
        required = "organism",
        optional = c(
            "genome-build",
            "release",
            "output-dir"
        ),
        positional = FALSE
    )
    args <- list()
    args[["organism"]] <- parse[["required"]][["organism"]]
    if (isSubset("genome-build", names(parse[["optional"]]))) {
        args[["genomeBuild"]] <- parse[["optional"]][["genome-build"]]
    }
    if (isSubset("release", names(parse[["optional"]]))) {
        args[["release"]] <- parse[["optional"]][["release"]]
    }
    if (isSubset("output-dir", names(parse[["optional"]]))) {
        args[["outputDir"]] <- parse[["optional"]][["output-dir"]]
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
    parse <- parseArgs(
        required = "organism",
        optional = c(
            "genome-build",
            "release",
            "output-dir"
        ),
        positional = FALSE
    )
    args <- list()
    args[["organism"]] <- parse[["required"]][["organism"]]
    if (isSubset("genome-build", names(parse[["optional"]]))) {
        args[["genomeBuild"]] <- parse[["optional"]][["genome-build"]]
    }
    if (isSubset("release", names(parse[["optional"]]))) {
        args[["release"]] <- parse[["optional"]][["release"]]
    }
    if (isSubset("output-dir", names(parse[["optional"]]))) {
        args[["outputDir"]] <- parse[["optional"]][["output-dir"]]
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
    parse <- parseArgs(
        required = "organism",
        optional = c(
            "taxonomic-group",
            "genome-build",
            "output-dir"
        ),
        positional = FALSE
    )
    args <- list()
    args[["organism"]] <- parse[["required"]][["organism"]]
    if (isSubset("genome-build", names(parse[["optional"]]))) {
        args[["genomeBuild"]] <- parse[["optional"]][["genome-build"]]
    }
    if (isSubset("taxonomic-group", names(parse[["optional"]]))) {
        args[["taxonomicGroup"]] <- parse[["optional"]][["taxonomic-group"]]
    }
    if (isSubset("output-dir", names(parse[["optional"]]))) {
        args[["outputDir"]] <- parse[["optional"]][["output-dir"]]
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
    parse <- parseArgs(
        required = "organism",
        optional = c(
            "genome-build",
            "output-dir"
        ),
        positional = FALSE
    )
    args <- list()
    args[["organism"]] <- parse[["required"]][["organism"]]
    if (isSubset("genome-build", names(parse[["optional"]]))) {
        args[["genomeBuild"]] <- parse[["optional"]][["genome-build"]]
    }
    if (isSubset("output-dir", names(parse[["optional"]]))) {
        args[["outputDir"]] <- parse[["optional"]][["output-dir"]]
    }
    do.call(
        what = AcidGenomes::downloadUCSCGenome,
        args = args
    )
}
