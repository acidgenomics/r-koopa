#' Prune the cellar
#'
#' @export
#' @note Updated 2020-08-11.
#'
#' @examples
#' ## > pruneCellar()
pruneCellar <- function() {
    prefix <- shell(
        command = .koopa(),
        args = "cellar-prefix",
        stdout = TRUE
    )
    apps <- sort(list.dirs(
        path = prefix,
        full.names = TRUE,
        recursive = FALSE
    ))
    versions <- lapply(
        X = apps,
        FUN = function(app) {
            x <- list.dirs(
                path = app,
                full.names = FALSE,
                recursive = FALSE
            )
            if (all(grepl(pattern = "^[.0-9]+$", x = x))) {
                x <- numeric_version(x)
            }
            x <- sort(x)
            x
        }
    )
    names(versions) <- basename(apps)
    latest <- lapply(X = versions, FUN = tail, n = 1L)
    prune <- mapply(
        FUN = setdiff,
        x = versions,
        y = latest,
        SIMPLIFY = FALSE,
        USE.NAMES = TRUE
    )
    prune <- Filter(f = hasLength, x = prune)
    prunePaths <- sort(unlist(mapply(
        app = names(prune),
        versions = prune,
        MoreArgs = list(prefix = prefix),
        FUN = function(app, versions, prefix) {
            file.path(prefix, app, versions)
        },
        SIMPLIFY = FALSE,
        USE.NAMES = FALSE
    )))
    unlink(prunePaths, recursive = TRUE)
    shell(
        command = file.path(
            .koopaPrefix(),
            "os",
            "linux",
            "bin",
            "remove-broken-cellar-symlinks"
        ),
        args = ""
    )
}
