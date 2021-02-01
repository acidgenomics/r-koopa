#' Build a package and commit to drat repo
#'
#' @name drat
#' @note Updated 2021-01-19.
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
    requireNamespaces(c("desc", "devtools"))
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
            descFile <- file.path(pkgDir, "DESCRIPTION")
            assert(isAFile(descFile))
            check(path = pkgDir)
            .pkgdownDeployToAWS(pkg = pkgDir)
            tarball <- devtools::build(pkg = pkgDir)
            assert(isAFile(tarball))
            drat::insertPackage(
                file = tarball,
                repodir = repoDir,
                action = "archive"
            )
            invisible(file.remove(tarball))
            setwd(pkgDir)
            name <- desc::desc_get_field(key = "Package", file = descFile)
            version <- as.character(desc::desc_get_version(file = descFile))
            today <- Sys.Date()
            shell(command = "git", args = c("fetch", "--force", "--tags"))
            shell(
                command = "git",
                args = c(
                    "tag", "--force",
                    "-a", paste0("'v", version, "'"),
                    "-m", paste0("'", name, " v", version, " (", today, ")'")
                )
            )
            shell(command = "git", args = c("push", "--force", "--tags"))
            setwd(repoDir)
            shell(command = "git", args = c("checkout", "master"))
            shell(command = "git", args = c("fetch", "--all"))
            shell(command = "git", args = "merge")
            shell(command = "git", args = c("add", "./"))
            shell(
                command = "git",
                args = c(
                    "commit", "-m", paste0("'Add ", basename(tarball), ".'")
                )
            )
            shell(command = "git", args = "push")
            setwd(wd)
            message(sprintf("Successfully added '%s'.", basename(tarball)))
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
#' @note Updated 2021-01-19.
#' @noRd
.pkgdownDeployToAWS <- function(
    pkg = ".",
    bucketDir = "s3://r.acidgenomics.com/packages"
) {
    requireNamespaces(c("desc", "pkgdown"))
    assert(isSystemCommand("aws"))
    pkgDir <- realpath(pkg)
    descFile <- file.path(pkgDir, "DESCRIPTION")
    assert(isAFile(descFile))
    pkgName <- desc::desc_get_field(key = "Package", file = descFile)
    bucketDir <- pasteURL(bucketDir, tolower(pkgName))
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
    pkgdown::build_site(pkg = pkg)
    shell(
        command = "aws",
        args = c(
            "s3", "sync", "--delete",
            paste0(docsDir, "/"),
            paste0(bucketDir, "/")
        )
    )
    unlink(docsDir, recursive = TRUE)
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
