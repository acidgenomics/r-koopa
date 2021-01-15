#' Build a package and commit to drat repo
#'
#' @name drat
#' @note Updated 2021-01-15.
#'
#' @return `logical(1)`.
#'
#' @examples
#' ## > drat()
NULL



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
            setwd(pkgDir)
            pkgName <- basename(pkgDir)
            ## Handle `r-koopa` edge case.
            if (any(grepl("-", pkgName))) {
                pkgName <- strsplit(pkgName, "-")[[1L]][[2L]]
            }
            check(path = pkgDir)
            devtools::build(pkg = pkgDir)
            tarballs <- sort(list.files(
                path = dirname(pkgDir),
                pattern = paste0(pkgName, "_.*.tar.gz"),
                recursive = FALSE,
                ignore.case = TRUE
            ))
            file <- tail(tarballs, n = 1L)
            assert(isAFile(file))
            .pkgdownDeployToAWS(pkg = pkgDir)
            drat::insertPackage(
                file = file,
                repodir = repoDir,
                action = "archive"
            )
            invisible(file.remove(file))
            setwd(repoDir)
            shell(command = "git", args = c("checkout", "master"))
            shell(command = "git", args = c("fetch", "--all"))
            shell(command = "git", args = "merge")
            shell(command = "git", args = c("add", "./"))
            shell(
                command = "git",
                args = c("commit", "-m", paste0("'Add ", basename(file), ".'"))
            )
            shell(command = "git", args = "push")
            message(sprintf("Successfully added '%s'.", basename(file)))
            TRUE
        }
    )
    setwd(repoDir)
    assert(isAFile("update"))
    shell(command = "./update")
    setwd(wd)
    invisible(TRUE)
}



#' Deploy pkgdown website to AWS S3
#'
#' @note Updated 2021-01-15.
#' @noRd
.pkgdownDeployToAWS <- function(
    pkg = ".",
    bucketDir = "s3://r.acidgenomics.com/packages"
) {
    pkgDir <- realpath(pkg)
    pkgName <- basename(pkgDir)
    bucketDir <- pasteURL(bucketDir, pkgName)
    docsDir <- file.path(pkgDir, "docs")
    configFile <- file.path(pkgDir, "_pkgdown.yml")
    if (!isAFile(configFile)) {
        alertWarning(sprintf(
            "pkgdown not enabled for {.pkg %s} at {.path %s}. Skipping.",
            pkgName, pkgDir
        ))
        return(invisible(FALSE))
    }
    alert(sprintf(
        paste(
            "Building pkgdown website for {.pkg %s} at {.path %s},",
            "then pushing to AWS S3 bucket at {.url %s}."
        ),
        pkgName, docsDir, bucketDir
    ))
    assert(isSystemCommand("aws"))
    requireNamespaces("pkgdown")
    pkgdown::build_site(pkg = pkg)
    shell(
        command = "aws",
        args = c(
            "s3",
            "sync",
            paste0(docsDir, "/"),
            paste0(bucketDir, "/")
        )
    )
    invisible(TRUE)
}



#' @rdname drat
#' @export
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
