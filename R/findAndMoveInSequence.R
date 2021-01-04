## FIXME MOVE THIS INTO BASEJUMP / ACIDBASE INSTEAD?



#' Find and move files in sequence
#'
#' @name findAndMoveInSequence
#' @note Updated 2021-01-04.
#'
#' @param sourceDir `character(1)`.
#'   Source directory.
#' @param targetDir `character(1)`.
#'   Target directory.
#'
#' @examples
#' ## > findAndMoveInSequence(sourceDir, targetDir)
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
                kebabCase(
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
            cli_alert(sprintf("Renaming '%s' to '%s'.", from, to))
            file.rename(from = from, to = to)
        }
    ))
    cli_alert_info(sprintf(
        "Successfully renamed %d files.",
        length(sourceFiles)
    ))
}



#' @rdname findAndMoveInSequence
#' @export
findAndMoveInSequence <- function() {
    posArgs <- positionalArgs()
    sourceDir <- realpath(posArgs[[1L]])
    targetDir <- realpath(posArgs[[2L]])
    .findAndMoveInSequence(
        sourceDir = sourceDir,
        targetDir = targetDir
    )
}
