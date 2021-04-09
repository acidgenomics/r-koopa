#' Find and move files in sequence
#'
#' @name findAndMoveInSequence
#' @note Updated 2021-03-01.
#'
#' @examples
#' ## > findAndMoveInSequence()
NULL



.findAndMoveInSequence <- function(sourceDir, targetDir) {
    assert(
        isADir(sourceDir),
        isADir(targetDir),
        !identical(sourceDir, targetDir)
    )
    sourceFiles <- sort(list.files(
        path = sourceDir,
        all.files = FALSE,
        full.names = TRUE,
        recursive = TRUE,
        include.dirs = FALSE
    ))
    targetFiles <- file.path(
        targetDir,
        paste0(
            strtrim(
                syntactic::kebabCase(
                    paste(
                        autopadZeros(seq_along(sourceFiles)),
                        basenameSansExt(sourceFiles),
                        sep = "-"
                    ),
                    prefix = FALSE
                ),
                width = 100L
            ),
            ".", fileExt(sourceFiles)
        )
    )
    assert(identical(length(sourceFiles), length(targetFiles)))
    invisible(mapply(
        from = sourceFiles,
        to = targetFiles,
        FUN = function(from, to) {
            alert(sprintf("Renaming '%s' to '%s'.", from, to))
            file.rename(from = from, to = to)
        }
    ))
    alertInfo(sprintf(
        "Successfully renamed %d files.",
        length(sourceFiles)
    ))
}



#' @rdname findAndMoveInSequence
#' @export
findAndMoveInSequence <- function() {
    pos <- positionalArgs()
    args <- list(
        "sourceDir" = realpath(pos[[1L]]),
        "targetDir" = realpath(pos[[2L]])
    )
    do.call(what = .findAndMoveInSequence, args = args)
}
