#' Prune old tags from DockerHub for a specific repo
#'
#' @name dockerPruneTags
#' @note Updated 2021-03-02.
#'
#' @examples
#' ## > dockerPruneTags()
NULL



## Updated 2021-03-02.
.dockerHubToken <- function(username, password) {
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



.dockerPruneTags <- function() {
}



dockerPruneTags <- function() {
    stop("FIXME")
}
