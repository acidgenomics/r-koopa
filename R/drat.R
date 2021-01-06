#' Build a package and commit to drat repo
#'
#' @note Updated 2021-01-06.
#' @export
#'
#' @examples
#' ## > drat("~/monorepo/r-packages/basejump")
drat <- function() {
    wd <- getwd()
    if (hasPositionalArgs()) {
        pkgDir <- positionalArgs()[[1L]]
    } else {
        pkgDir <- "."
    }
    assert(
        isADir(pkgDir),
        isAFile(file.path(pkgDir, "DESCRIPTION"))
    )
    pkgDir <- realpath(pkgDir)
    pkgName <- basename(pkgDir)
    ## Handle `r-koopa` edge case.
    if (any(grepl("-", pkgName))) {
        pkgName <- strsplit(pkgName, "-")[[1L]][[2L]]
    }
    repoDir <- file.path("~", "monorepo", "drat")
    assert(isADir(repoDir))
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
    setwd(wd)
    message(sprintf("Successfully added '%s'.", basename(file)))
    invisible(TRUE)
}
