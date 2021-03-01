#' List user-accessible programs exported in PATH
#'
#' @name listPrograms
#' @note Updated 2021-03-01.
#'
#' @examples
#' ## > listPrograms()
NULL



## Updated 2021-03-01.
.printPrograms <- function(path) {
    if (!isADir(path)) return()
    path <- realpath(path)
    files <- sort(list.files(path = path, all.files = FALSE, full.names = TRUE))
    ## Ignore directories.
    keep <- !file.info(files)[["isdir"]]
    files <- files[keep]
    ## Ignore scripts defined in non-koopa programs.
    keep <- !grepl(
        pattern = file.path(
            koopaPrefix(),
            "(app|cellar|dotfiles|opt|stow)"
        ),
        x = files
    )
    files <- files[keep]
    if (!hasLength(files)) return()
    h1(path)
    ul(basename(files))
    invisible(NULL)
}



#' @rdname listPrograms
#' @export
listPrograms <- function() {
    path <- Sys.getenv("PATH")
    assert(any(grepl("koopa", path)))
    ## Split PATH string into a character vector.
    path <- strsplit(x = path, split = ":", fixed = TRUE)[[1L]]
    keep <- grepl("koopa", path)
    path <- path[keep]
    invisible(lapply(X = path, FUN = .printPrograms))
}
