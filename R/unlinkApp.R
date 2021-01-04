#' Unlink an application
#'
#' @note Updated 2021-01-04.
#' @export
#'
#' @param x `character.`
#'   Application names.
#'
#' @examples
#' ## > unlinkApp(c("vim", "tmux"))
unlinkApp <- function() {
    x <- positionalArgs()
    .unlinkApp(x)
}



.unlinkApp <- function(x) {
    assert(isLinux())
    koopa <- koopa()
    invisible(lapply(
        X = x,
        FUN = function(app) {
            cellarPrefix <- shell(
                command = koopa,
                args = "cellar-prefix",
                stdout = TRUE
            )
            makePrefix <- shell(
                command = koopa,
                args = "make-prefix",
                stdout = TRUE
            )
            ## List all files in make prefix (e.g. '/usr/local').
            files <- list.files(
                path = makePrefix,
                all.files = TRUE,
                full.names = TRUE,
                recursive = TRUE,
                include.dirs = FALSE,
                no.. = TRUE
            )
            ## This step can be CPU intensive and safe to skip.
            files <- sort(files)
            ## Resolve the file paths, to match cellar symlinks.
            realpaths <- realpath(files)
            ## Get the symlinks that resolve to the desired app.
            hits <- grepl(pattern = file.path(cellarPrefix, app), x = realpaths)
            message(sprintf("%d cellar symlinks detected.", sum(hits)))
            ## Ready to remove the maching symlinks.
            trash <- files[hits]
            file.remove(trash)
        }
    ))
}
