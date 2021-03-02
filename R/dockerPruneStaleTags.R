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
        token <- fromJSON(json)[["token"]]
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
        df <- fromJSON(json)[["results"]]
        assert(is.data.frame(df))
        df
    }



## Updated 2021-03-02.
.dockerPruneStaleTags <-
    function(username, password) {
        token <- .dockerHubToken(username = username, password = password)
    }



#' @rdname dockerPruneStaleTags
#' @export
dockerPruneStaleTags <- function() {
    stop("FIXME")
}
