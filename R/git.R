## Consider using git2r package here instead.
## https://github.com/ropensci/git2r



#' Default Git branch
#'
#' @note Updated 2021-04-23.
#' @export
#'
#' @param repo `character(1)`.
#'   Git repository directory path.
#' @param remote `character(1)`.
#'   Remote name.
#'
#' @seealso
#' - `koopa::git_default_branch` (shell).
#'
#' @examples
#' ## > repo <- file.path("~", "git", "monorepo")
#' ## > gitDefaultBranch(repo)
gitDefaultBranch <- function(repo, remote = "origin") {
    assert(
        isADir(repo),
        isString(remote),
        isSystemCommand("git")
    )
    wd <- getwd()
    setwd(repo)
    x <- shell(
        command = "git",
        args = c("remote", "show", remote),
        stdout = TRUE
    )
    pattern <- "^.+HEAD branch: ([^\\s]+)$"
    x <- grep(pattern = pattern, x = x, value = TRUE)
    x <- sub(pattern = pattern, replacement = "\\1", x = x)
    assert(isString(x))
    setwd(wd)
    x
}
