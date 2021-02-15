#' Check `bin` and `man` directory consistency
#'
#' @note Updated 2021-02-15.
#' @noRd
#'
#' @details
#' Check that all scripts in `bin` and `sbin` directories have corresponding
#' documentation in `man/man1`.
checkBinManConsistency <- function() {
    koopaPrefix <- koopaPrefix()
    ## Exclude these directories from search.
    exclude <- file.path(koopaPrefix, "(app|dotfiles|opt|system)", "")
    h1("Checking bin/man consistency.")
    status <- 0L
    ## Bin-to-man mapping {{{1
    ## =========================================================================
    bins <- sort(list.files(
        path = koopaPrefix,
        pattern = "^[s]?bin$",
        full.names = TRUE,
        recursive = TRUE,
        include.dirs = TRUE
    ))
    bins <- bins[!grepl(pattern = exclude, x = bins)]
    ## Scripts {{{2
    ## -------------------------------------------------------------------------
    ## List the files for each bin directory.
    scripts <- sort(unlist(lapply(
        X = bins,
        FUN = list.files,
        full.names = TRUE,
        recursive = FALSE,
        include.dirs = FALSE
    )))
    ## Man files {{{2
    ## -------------------------------------------------------------------------
    ## Map to corresponding man files.
    manfiles <- gsub(
        pattern = file.path("", "[s]?bin", ""),
        replacement = file.path("", "man", "man1", ""),
        x = scripts
    )
    assert(!any(duplicated(manfiles)))
    manfiles <- paste0(manfiles, ".1")
    ok <- file.exists(manfiles)
    if (!all(ok)) {
        missing <- manfiles[!ok]
        message(sprintf(
            "%d missing man pages detected. Resolving.",
            length(missing)
        ))
        invisible({
            lapply(X = dirname(missing), FUN = initDir)
            file.create(missing)
        })
        status <- 1L
    }
    ## Orphaned man-to-bin files {{{1
    ## =========================================================================
    mans <- sort(list.files(
        path = koopaPrefix,
        pattern = "^man1$",
        full.names = TRUE,
        recursive = TRUE,
        include.dirs = TRUE
    ))
    mans <- mans[!grepl(pattern = exclude, x = mans)]
    manfiles2 <- sort(unlist(lapply(
        X = mans,
        FUN = list.files,
        full.names = TRUE,
        recursive = FALSE,
        include.dirs = FALSE
    )))
    orphans <- setdiff(manfiles2, manfiles)
    if (hasLength(orphans)) {
        message(sprintf(
            "%d orphaned man pages detected. Resolving.",
            length(orphans)
        ))
        invisible(file.remove(orphans))
        status <- 1L
    }
    quit(status = status)
}