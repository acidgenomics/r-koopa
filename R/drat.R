#' Build a package and commit to drat repo
#'
#' @note Updated 2021-01-06.
#' @export
#'
#' @return `logical(1)`.
#'
#' @examples
#' ## > drat()
drat <- function() {
    parse <- parseArgs(
        optional = "repo-dir",
        positional = TRUE
    )
    args <- list("pkgDirs" = parse[["positional"]])
    optional <- parse[["optional"]]
    if (!is.null(optional)) {
        if (isSubset("repo-dir", names(optional))) {
            args[["repoDir"]] <- optional[["repo-dir"]]
        }
    }
    do.call(what = .drat, args = args)
}



.drat <- function(
    pkgDirs,
    repoDir = file.path("~", "monorepo", "drat")
) {
    assert(
        allAreDirs(pkgDirs),
        isADir(repoDir)
    )
    pkgDirs <- realpath(pkgDirs)
    wd <- getwd()
    lapply(
        X = pkgDirs,
        repoDir = repoDir,
        FUN = function(pkgDir, repoDir) {
            pkgName <- basename(pkgDir)
            ## Handle `r-koopa` edge case.
            if (any(grepl("-", pkgName))) {
                pkgName <- strsplit(pkgName, "-")[[1L]][[2L]]
            }
            setwd(dirname(pkgDir))
            devtools::build(pkgDir)
            tarballs <- sort(list.files(
                path = ".",
                pattern = paste0(pkgName, "_.*.tar.gz"),
                recursive = FALSE,
                ignore.case = TRUE
            ))
            file <- tail(tarballs, n = 1L)
            assert(isAFile(file))
            drat::insertPackage(
                file = file,
                repodir = repoDir,
                action = "archive"
            )
            invisible(file.remove(file))
            setwd(repoDir)
            shell(command = "git", args = c("checkout", "master"))
            shell(command = "git", args = c("add", "./"))
            shell(
                command = "git",
                args = c("commit", "-m", paste0("'Add ", basename(file), ".'"))
            )
            shell(command = "git", args = "push")
            shell(command = "update")
            message(sprintf("Successfully added '%s'.", basename(file)))
            setwd(wd)
            TRUE
        }
    )
    invisible(TRUE)
}
