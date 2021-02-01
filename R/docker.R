#' Manage Docker images
#'
#' @name docker
#' @note Updated 2021-01-04.
#'
#' @examples
#' ## > dockerBuildAllTags()
NULL



#' Build all Docker tags
#'
#' @note Updated 2021-01-31.
#' @noRd
#'
#' @param images `character`.
#'   Docker image names.
#' @param dir `character(1)`.
#'   Docker image repository.
#' @param days `numeric(1)`.
#'   Number of days to allow since last build.
#' @param force `logical(1)`.
#'   Force rebuild.
.dockerBuildAllTags <- function(
    images,
    dir = file.path("~", ".config", "koopa", "docker"),
    days = 2L,
    force = FALSE
) {
    assert(
        isCharacter(images),
        isADir(dir),
        isNumber(days),
        isFlag(force)
    )
    ## Treat all warnings as errors.
    warn <- getOption("warn")
    options("warn" = 2L)
    koopaPrefix <- koopaPrefix()
    if (!any(grepl(pattern = "/", x = images)))
        images <- file.path("acidgenomics", images)
    alert(sprintf("Building all tags: %s.", toString(images)))
    invisible(lapply(
        X = images,
        FUN = function(image) {
            imageDir <- file.path(dir, image)
            assert(isADir(imageDir))
            ## Build tags in desired order, using "build.txt" file.
            buildFile <- file.path(imageDir, "build.txt")
            if (file.exists(buildFile)) {
                tags <- readLines(buildFile)
            } else {
                ## Or build alphabetically (default).
                tags <- sort(list.dirs(
                    path = imageDir,
                    full.names = FALSE,
                    recursive = FALSE
                ))
            }
            if (length(tags) > 1L) {
                ## Build "latest" tag automatically at the end.
                tags <- setdiff(tags, "latest")
            }
            assert(hasLength(tags))
            ## Build the versioned images, defined by `Dockerfile` in the
            ## subdirectories.
            status <- mapply(
                tag = tags,
                MoreArgs = list(image = image),
                FUN = function(image, tag) {
                    path <- file.path(imageDir, tag)
                    if (isASymlink(path)) {
                        sourceTag <- basename(realpath(path))
                        destTag <- tag
                        shell(
                            command = file.path(
                                koopaPrefix,
                                "bin",
                                "docker-tag"
                            ),
                            args = c(image, sourceTag, destTag)
                        )
                    } else {
                        if (!isTRUE(force)) {
                            if (isTRUE(
                                .isDockerBuildRecent(
                                    image = paste0(image, ":", tag),
                                    days = days
                                )
                            )) {
                                alertInfo(sprintf(
                                    "'%s:%s' was built recently. Skipping.",
                                    image, tag
                                ))
                                return(0L)
                            }
                        }
                        shell(
                            command = file.path(
                                koopaPrefix,
                                "bin",
                                "docker-build"
                            ),
                            args = c(
                                paste0("--tag=", tag),
                                image
                            )
                        )
                    }
                },
                USE.NAMES = FALSE,
                SIMPLIFY = TRUE
            )
            assert(all(as.integer(status) == 0L))
            ## Update "latest" tag, if necessary.
            latestFile <- file.path(imageDir, "latest")
            if (isAFile(latestFile) || isASymlink(latestFile)) {
                if (isASymlink(latestFile)) {
                    sourceTag <- basename(realpath(latestFile))
                } else if (isAFile(latestFile)) {
                    sourceTag <- readLines(latestFile)
                }
                assert(isString(sourceTag))
                destTag <- "latest"
                alert(sprintf(
                    "Tagging %s '%s' as '%s'.",
                    image, sourceTag, destTag
                ))
                shell(
                    command = file.path(koopaPrefix, "bin", "docker-tag"),
                    args = c(image, sourceTag, destTag)
                )
            }
        }
    ))
    options("warn" = warn)
    invisible(TRUE)
}



#' Is the Docker build recent?
#'
#' @note Updated 2021-01-04.
#' @noRd
.isDockerBuildRecent <- function(image, days = 2L) {
    assert(
        isString(image),
        isNumber(days)
    )
    shell(
        command = "docker",
        args = c("pull", image),
        stdout = FALSE,
        stderr = FALSE
    )
    x <- shell(
        command = "docker",
        args = c(
            "inspect",
            "--format='{{json .Created}}'",
            image
        ),
        stdout = TRUE
    )
    x <- gsub("\"", "", x)
    x <- sub("\\.[0-9]+Z$", "", x)
    diffDays <- difftime(
        time1 = Sys.time(),
        time2 = as.POSIXct(x, format = "%Y-%m-%dT%H:%M:%S"),
        units = "days"
    )
    diffDays < days
}



#' @describeIn docker Build all tags for a specific image.
#' @export
dockerBuildAllTags <- function() {
    parse <- parseArgs(
        optional = c("days", "dir"),
        flags = "force",
        positional = TRUE
    )
    args <- list(
        images = parse[["positional"]],
        force = "force" %in% parse[["flags"]]
    )
    optional <- parse[["optional"]]
    if (!is.null(optional)) {
        if (isSubset("days", names(optional))) {
            args[["days"]] <- as.numeric(optional[["days"]])
        }
        if (isSubset("dir", names(optional))) {
            args[["dir"]] <- optional[["dir"]]
        }
    }
    do.call(what = .dockerBuildAllTags, args = args)
}
