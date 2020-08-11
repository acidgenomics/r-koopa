#' Manage Docker images
#'
#' @name docker
#' @note Updated 2020-08-11.
#'
#' @param images `character`.
#'   Docker image names.
#' @param dir `character(1)`.
#'   Docker image repository.
#' @param days `numeric(1)`.
#'   Number of days to allow since last build.
#' @param force `logical(1)`.
#'   Force rebuild.
#'
#' @examples
#' ## > dockerBuildAllTags()
#' ## > isDockerBuildRecent("acidgenomics/debian")
NULL



#' @describeIn docker Build all tags for a specific image.
#' @export
dockerBuildAllTags <- function(
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
    if (!any(grepl(pattern = "/", x = images)))
        images <- file.path("acidgenomics", images)
    cli_alert(sprintf("Building all tags: %s.", toString(images)))
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
                                isDockerBuildRecent(image, days = days)
                            )) {
                                cli_alert_info(sprintf(
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
                cli_alert(sprintf(
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
}



#' @describeIn docker Has the requested Docker image been built recently?
#' @export
isDockerBuildRecent <- function(image, days = 2L) {
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
