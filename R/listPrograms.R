#' List user-accessible programs exported in PATH
#'
#' @export
#' @note Updated 2020-08-11.
#'
#' @examples
#' ## > listPrograms()
listPrograms <- function() {
    assert(isVanilla())
    path <- Sys.getenv("PATH")
    assert(any(grepl("koopa", path)))
    ## Split PATH string into a character vector.
    path <- strsplit(x = path, split = ":", fixed = TRUE)[[1L]]
    keep <- grepl("koopa", path)
    path <- path[keep]
    invisible(lapply(X = path, FUN = .printPrograms))
}

.printPrograms <- function(path) {
    if (!isADir(path)) return()
    path <- realpath(path)
    files <- sort(list.files(path = path, all.files = FALSE, full.names = TRUE))
    # Ignore directories.
    keep <- !file.info(files)[["isdir"]]
    files <- files[keep]
    # Ignore exported scripts in `opt`.
    keep <- !grepl(file.path(.koopaPrefix(), "opt"), files)
    files <- files[keep]
    if (!hasLength(files)) return()
    h1(path)
    ul(basename(files))
}
