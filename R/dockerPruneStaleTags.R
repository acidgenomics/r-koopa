#' Prune (delete) stale tags from DockerHub for a specific repo
#'
#' @name dockerPruneStaleTags
#' @note Updated 2021-03-02.
#'
#' @examples
#' ## > dockerPruneTags()
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
        df <- jsonlite::fromJSON(json)[["results"]]
        assert(is.data.frame(df))
        df
    }



#' Prune (delete) stale tags from DockerHub
#'
#' @note Updated 2021-03-02.
#' @noRd
#'
#' @seealso
#' - https://stackoverflow.com/questions/44209644/
#' - https://serverfault.com/questions/1021883/
#' - https://gist.github.com/kizbitz/e59f95f7557b4bbb8bf2
.dockerPruneStaleTags <-
    function(
        username,
        password,
        organization,
        image
    ) {
        token <- .dockerHubToken(
            username = username,
            password = password
        )
        tags <- .dockerListTags(
            organization = organization,
            image = image,
            token = token
        )
        assert(isSubset(
            x = c("last_updated", "tag_status"),
            y = colnames(tags)
        ))
        ## Arrange from oldest to newest. By default, the JSON API returns
        ## newest to oldest.
        tags <- tags[order(tags[["last_updated"]]), , drop = FALSE]
        isStale <- tags[["tag_status"]] == "stale"
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
                        "-H", paste0("'Authorization: JWT ", token, "'"),
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
    }



#' @rdname dockerPruneStaleTags
#' @export
dockerPruneStaleTags <- function() {
    argNames <- c(
        "username",
        "password",
        "organization",
        "image"
    )
    parse <- parseArgs(
        required = argNames,
        positional = FALSE
    )
    args <- parse[["required"]][argNames]
    do.call(
        what = .dockerPruneStaleTags,
        args = args
    )
}
