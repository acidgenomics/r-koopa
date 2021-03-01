#' Detect HPC environment
#'
#' Detect if R is running on a high-performance computing (HPC) cluster.
#'
#' Currently supports detection of Slurm or LSF.
#'
#' @note Updated 2019-07-28.
#' @noRd
#'
#' @return `character(1)` or `logical(1)`.
#'   Workload manager (scheduler) name if HPC is detected (e.g. `"SLURM"` or
#'   `"LSF"`), otherwise `FALSE`.
#'
#' @seealso
#' - `Sys.getenv`.
#' - `Sys.info`.
#' - `R.version`.
#' - `.Platform`.
#'
#' @examples
#' .detectHPC()
.detectHPC <- function() {
    if (!identical(Sys.getenv("LSF_ENVDIR"), "")) {
        "LSF"
    } else if (!identical(Sys.getenv("SLURM_CONF"), "")) {
        "SLURM"
    } else {
        FALSE
    }
}



#' Check failure
#'
#' Set a system environment variable that we can detect in `koopa check`.
#'
#' @note Updated 2020-08-11.
#' @noRd
.setCheckFail <- function() {
    Sys.setenv("KOOPA_CHECK_FAIL" = 1L)
}



#' Status labels
#'
#' @note Updated 2020-08-11.
#' @noRd
.status <- function() {
    list(
        fail = red("FAIL"),
        note = yellow("NOTE"),
        ok   = green("  OK")
    )
}
