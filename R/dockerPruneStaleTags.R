#' Prune (delete) stale tags from DockerHub for a specific repo
#'
#' @name dockerPruneStaleTags
#' @note Updated 2021-03-30.
#'
#' @examples
#' ## > dockerPruneStaleTags()
NULL



#' Fetch DockerHub API token for a specific user
#'
#' @note Updated 2021-03-02.
#' @noRd
#'
#' @return `character(1)`.
.dockerHubToken <-
    function(username, password) {
        requireNamespaces("jsonlite")
        json <- shell(
            command = "curl",
            args = c(
                "-s",
                "-H", "'Content-Type: application/json'",
                "-X", "POST",
                "-d",
                paste0(
                    "'{\"username\": \"", username, "\", ",
                    "\"password\": \"", password, "\"}'"
                ),
                "https://hub.docker.com/v2/users/login/"
            ),
            stdout = TRUE
        )
        token <- jsonlite::fromJSON(json)[["token"]]
        assert(isString(token))
        token
    }



#' Get all tags for a specific Docker repo
#'
#' @note Updated 2021-03-02.
#' @noRd
#'
#' @return `data.frame`
.dockerListTags <-
    function(organization, image, token) {
        requireNamespaces("jsonlite")
        assert(
            isString(organization),
            isString(image),
            isString(token)
        )
        json <- shell(
            command = "curl",
            args = c(
                "-s",
                "-H", "'Accept: application/json'",
                "-H", paste0("'Authorization: JWT ", token, "'"),
                paste0(
                    "'",
                    pasteURL(
                        "hub.docker.com",
                        "v2",
                        "repositories",
                        organization,
                        image,
                        "tags",
                        "?page_size=100",
                        protocol = "https"
                    ),
                    "'"
                )
            ),
            stdout = TRUE
        )
        jsonlite::fromJSON(json)[["results"]]
    }



#' Prune (delete) stale tags from DockerHub
#'
#' @note Updated 2021-03-30.
#' @noRd
#'
#' @seealso
#' - https://stackoverflow.com/questions/44209644/
#' - https://serverfault.com/questions/1021883/
#' - https://gist.github.com/kizbitz/e59f95f7557b4bbb8bf2
.dockerPruneStaleTags <-
    function(images) {
        assert(isCharacter(images))
        username <- Sys.getenv("DOCKERHUB_USERNAME")
        if (is.null(username)) {
            stop(sprintf(
                "Set '%s' with '%s' environment variable.",
                "username", "DOCKERHUB_USERNAME"
            ))
        }
        password <- Sys.getenv("DOCKERHUB_PASSWORD")
        if (is.null(password)) {
            stop(sprintf(
                "Set '%s' with '%s' environment variable.",
                "password", "DOCKERHUB_PASSWORD"
            ))
        }
        token <- .dockerHubToken(
            username = username,
            password = password
        )
        if (!any(grepl(pattern = "^[^/]+/[^/]$", x = images))) {
            images <- paste("acidgenomics", images, sep = "/")
        }
        split <- strsplit(x = images, split = "/", fixed = TRUE)
        split <- do.call(what = rbind, args = split)
        out <- mapply(
            organization = split[, 1L],
            image = split[, 2L],
            MoreArgs = list(
                token = token
            ),
            FUN = function(
                organization,
                image,
                token
            ) {
                tags <- .dockerListTags(
                    organization = organization,
                    image = image,
                    token = token
                )
                if (!hasLength(tags)) {
                    alertInfo(sprintf(
                        "No tags to prune for {.var %s/%s} repo.",
                        organization, image
                    ))
                    return(invisible(FALSE))
                }
                assert(isSubset(
                    x = c("last_updated", "tag_status"),
                    y = colnames(tags)
                ))
                ## Arrange from oldest to newest. By default, the JSON API
                ## returns newest to oldest.
                tags <- tags[order(tags[["last_updated"]]), , drop = FALSE]
                isStale <- tags[["tag_status"]] != "active"  # inactive, stale
                if (all(isStale)) {
                    alertWarning(sprintf(
                        "All tags for {.var %s/%s} repo are stale. Skipping.",
                        organization, image
                    ))
                    return(invisible(FALSE))
                }
                staleTags <- tags[isStale, "name", drop = TRUE]
                if (!hasLength(staleTags)) {
                    alertInfo(sprintf(
                        "No stale tags to prune for {.var %s/%s} repo.",
                        organization, image
                    ))
                    return(invisible(FALSE))
                }
                alert(sprintf(
                    "Pruning %d %s from {.var %s/%s} repo.",
                    length(staleTags),
                    ngettext(
                        n = length(staleTags),
                        msg1 = "tag",
                        msg2 = "tags",
                    ),
                    organization,
                    image
                ))
                ## Loop across the stale tags and delete.
                status <- vapply(
                    X = staleTags,
                    organization = organization,
                    image = image,
                    token = token,
                    FUN = function(tag, organization, image, token) {
                        alert(sprintf("Deleting stale {.var %s} tag.", tag))
                        shell(
                            command = "curl",
                            args = c(
                                "-siL",
                                "-H", "'Accept: application/json'",
                                "-H", paste0(
                                    "'Authorization: JWT ", token, "'"
                                ),
                                "-X", "DELETE",
                                paste0(
                                    "'",
                                    pasteURL(
                                        "hub.docker.com",
                                        "v2",
                                        "repositories",
                                        organization,
                                        image,
                                        "tags",
                                        tag,
                                        protocol = "https"
                                    ),
                                    "'"
                                )
                            )
                        )
                    },
                    FUN.VALUE = integer(1L)
                )
                invisible(status)
            },
            SIMPLIFY = FALSE,
            USE.NAMES = FALSE
        )
        names(out) <- images
        invisible(out)
    }



#' @rdname dockerPruneStaleTags
#' @export
dockerPruneStaleTags <- function() {
    images <- positionalArgs()
    .dockerPruneStaleTags(images = images)
}



#' @rdname dockerPruneStaleTags
#' @export
dockerPruneAllStaleTags <- function() {
    dockerDir <- file.path("~", ".config", "koopa", "docker", "acidgenomics")
    assert(isADir(dockerDir))
    images <- sort(list.dirs(
        path = dockerDir,
        full.names = FALSE,
        recursive = FALSE
    ))
    .dockerPruneStaleTags(images = images)
}
