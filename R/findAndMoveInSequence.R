#' Find and move files in sequence
#'
#' @note Updated 2021-01-04.
#' @export
#'
#' @examples
#' ## > findAndMoveInSequence()
findAndMoveInSequence <- function() {
    posArgs <- positionalArgs()
    sourceDir <- realpath(posArgs[[1L]])
    targetDir <- realpath(posArgs[[2L]])
    .findAndMoveInSequence(
        sourceDir = sourceDir,
        targetDir = targetDir
    )
}



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
            cli_alert(sprintf("Renaming '%s' to '%s'.", from, to))
            file.rename(from = from, to = to)
        }
    ))
    cli_alert_info(sprintf(
        "Successfully renamed %d files.",
        length(sourceFiles)
    ))
}
