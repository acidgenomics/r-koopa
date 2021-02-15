## NOTE Consider adding support for checking PATH priority here.



#' Check system
#'
#' @export
#' @note Updated 2021-02-15.
#'
#' @details
#' If you see this error, reinstall ruby, rbenv, and emacs:
#' # Ignoring commonmarker-0.17.13 because its extensions are not built.
#' Try: gem pristine commonmarker --version 0.17.13
#'
#' @examples
#' ## > checkSystem()
checkSystem <- function() {
    h1("Checking koopa installation.")
    koopa <- koopa()
    macos <- isMacOS()
    linux <- !macos
    docker <- isDocker()
    os <- shell(
        command = koopa,
        args = c("system", "os-string"),
        stdout = TRUE
    )
    ## Basic dependencies ======================================================
    h2("Basic dependencies")
    .checkInstalled(
        name = c(
            ## "[",
            ## "basenc",
            ## "chsh",  # lchsh on Fedora
            ## "rename",
            ## "top",
            ## "uptime",
            "b2sum",
            "base32",
            "base64",
            "basename",
            "bc",
            "cat",
            "chcon",
            "chgrp",
            "chmod",
            "chown",
            "chroot",
            "cksum",
            "comm",
            "cp",
            "csplit",
            "curl",
            "cut",
            "date",
            "dd",
            "df",
            "dir",
            "dircolors",
            "dirname",
            "du",
            "echo",
            "env",
            "expand",
            "expr",
            "factor",
            "false",
            "find",
            "fmt",
            "fold",
            "g++",
            "gcc",
            "grep",
            "groff",
            "groups",
            "head",
            "hostid",
            "id",
            "install",
            "join",
            "kill",
            "less",
            "link",
            "ln",
            "logname",
            "ls",
            "man",
            "md5sum",
            "mkdir",
            "mkfifo",
            "mknod",
            "mktemp",
            "mv",
            "nice",
            "nl",
            "nohup",
            "nproc",
            "numfmt",
            "od",
            "openssl",
            "parallel",
            "paste",
            "patch",
            "pathchk",
            "pinky",
            "pr",
            "printenv",
            "printf",
            "ps",
            "ptx",
            "pwd",
            "readlink",
            "realpath",
            "rm",
            "rmdir",
            "rsync",
            "runcon",
            "sed",
            "seq",
            "sh",
            "sha1sum",
            "sha224sum",
            "sha256sum",
            "sha384sum",
            "sha512sum",
            "shred",
            "shuf",
            "sleep",
            "sort",
            "split",
            "stat",
            "stdbuf",
            "stty",
            "sum",
            "svn",
            "sync",
            "tac",
            "tail",
            "tee",
            "test",
            "timeout",
            "touch",
            "tr",
            "tree",
            "true",
            "truncate",
            "tsort",
            "tty",
            "udunits2",
            "uname",
            "unexpand",
            "uniq",
            "unlink",
            "users",
            "vdir",
            "wc",
            "wget",
            "which",
            "who",
            "whoami",
            "xargs",
            "yes"
        )
    )
    ## Shells ==================================================================
    h2("Shells")
    .checkVersion("bash")
    .checkVersion("zsh")
    .checkVersion("fish")
    ## GNU packages ============================================================
    h2("GNU packages")
    .checkGNUVersion("autoconf")
    .checkGNUVersion("automake")
    .checkGNUVersion("binutils")
    .checkGNUVersion("coreutils")
    .checkGNUVersion("findutils")
    .checkGNUVersion("gawk")
    ## > .checkGNUVersion("gcc")
    .checkGNUVersion("grep")
    .checkGNUVersion("groff")
    if (isTRUE(linux))
        .checkGNUVersion("libtool")
    .checkGNUVersion("make")
    if (isTRUE(linux))
        .checkGNUVersion("ncurses")
    .checkGNUVersion("parallel")
    .checkGNUVersion("patch")
    .checkGNUVersion("sed")
    .checkGNUVersion("stow")
    .checkGNUVersion("tar")
    .checkGNUVersion("texinfo")
    .checkGNUVersion("wget")
    ## Core packages ===========================================================
    h2("Core packages")
    .checkVersion("cmake", nameFancy = "CMake")
    .checkVersion("curl", nameFancy = "cURL")
    .checkVersion("openssh", nameFancy = "OpenSSH")
    .checkVersion("pkg-config", nameFancy = NULL)
    .checkVersion("rsync", nameFancy = NULL)
    ## Editors =================================================================
    h2("Editors")
    .checkVersion("emacs")
    .checkVersion("neovim")
    .checkVersion("tmux")
    .checkVersion(
        name = "vim",
        current = .currentMinorVersion("vim"),
        expected = .expectedMinorVersion("vim")
    )
    ## Languages ===============================================================
    h2("Primary languages")
    .checkVersion("python")
    .checkVersion("r")
    h2("Secondary languages")
    .checkVersion("go")
    .checkVersion("openjdk", nameFancy = "Java : OpenJDK")
    .checkVersion("julia")
    .checkVersion("perl")
    .checkVersion("ruby")
    .checkVersion("rust")
    ## Version managers ========================================================
    h2("Version managers")
    condaPrefix <- shell(
        command = koopa,
        args = c("system", "prefix", "conda"),
        stdout = TRUE
    )
    if (file.exists(file.path(condaPrefix, "bin", "anaconda"))) {
        .checkVersion("anaconda")
    } else {
        .checkVersion("conda", nameFancy = "Miniconda")
    }
    if (!isTRUE(docker)) {
        .checkVersion("rustup", nameFancy = "Rust : rustup")
    }
    ## Cloud APIs ==============================================================
    h2("Cloud APIs")
    .checkInstalled(c("aws", "az", "gcloud"))
    ## Tools ===================================================================
    h2("Tools")
    .checkVersion("git")
    .checkVersion("htop", nameFancy = NULL)
    .checkVersion("neofetch")
    .checkVersion("subversion")
    ## Shell tools =============================================================
    h2("Shell tools")
    .checkVersion("the-silver-searcher")
    .checkVersion("shellcheck", nameFancy = "ShellCheck")
    .checkInstalled("shunit2")
    ## Heavy dependencies ======================================================
    h2("Heavy dependencies")
    .checkVersion("armadillo", nameFancy = "Armadillo")
    .checkVersion("proj", nameFancy = "PROJ")
    .checkVersion("gdal", nameFancy = "GDAL")
    .checkVersion("geos", nameFancy = "GEOS")
    .checkVersion("gsl", nameFancy = "GSL")
    .checkVersion("hdf5", nameFancy = "HDF5")
    .checkVersion(
        name = "llvm",
        nameFancy = "LLVM",
        current = .currentMajorVersion("llvm"),
        expected = .expectedMajorVersion("llvm")
    )
    .checkVersion("sqlite", nameFancy = "SQLite")
    .checkInstalled(
        name = c(
            "pandoc",
            "pandoc-citeproc",
            "tex"
        )
    )
    ## OS-specific =============================================================
    if (isTRUE(linux)) {
        h2("Linux specific")
        .checkVersion("aspera-connect")
        if (!isTRUE(docker)) {
            .checkVersion("docker")
            .checkVersion("docker-credential-pass")
        }
        .checkVersion("gnupg", nameFancy = "GnuPG")
        .checkVersion("password-store")
        .checkVersion("perl-file-rename")
        .checkVersion("rstudio-server", nameFancy = "RStudio Server")
    } else if (isTRUE(macos)) {
        h2("macOS specific")
        .checkInstalled(
            name = c("clang", "gcc")
        )
        .checkVersion("homebrew")
        .checkVersion("tex", nameFancy = "TeX Live")
        .checkHomebrewCaskVersion("gpg-suite", nameFancy = "GPG Suite")
    }
    ## High performance ========================================================
    if (
        isTRUE(linux) &&
        !isTRUE(docker) &&
        isTRUE(getOption("mc.cores") >= 3L)
    ) {
        h2("High performance")
        ## > .checkVersion("bcbio-nextgen", nameFancy = NULL)
        ## > .checkVersion("bcl2fastq")
        .checkVersion("lmod")
        .checkVersion("lua")
        .checkVersion("luarocks", nameFancy = "LuaRocks")
        .checkVersion("shiny-server")
        # > .checkVersion("singularity")
    }
    ## Python packages =========================================================
    h2("Python packages")
    .checkPythonPackageVersion("pip")
    .checkPythonPackageVersion("black")
    .checkPythonPackageVersion("bpytop")
    .checkPythonPackageVersion("flake8")
    .checkPythonPackageVersion("pylint")
    .checkPythonPackageVersion("ranger-fm")
    ## Rust packaegs ===========================================================
    h2("Rust packages")
    .checkInstalled("cargo")
    .checkRustPackageVersion("bat")
    .checkRustPackageVersion("broot")
    .checkRustPackageVersion("dog")
    .checkRustPackageVersion("du-dust")
    .checkRustPackageVersion("exa")
    .checkRustPackageVersion("fd-find")
    .checkRustPackageVersion("hyperfine")
    .checkRustPackageVersion("procs")
    .checkRustPackageVersion("ripgrep")
    .checkRustPackageVersion("ripgrep-all")
    .checkRustPackageVersion("starship")
    .checkRustPackageVersion("tokei")
    .checkRustPackageVersion("xsv")
    .checkRustPackageVersion("zoxide")
    ## Ruby gems ===============================================================
    h2("Ruby gems")
    .checkRubyPackageVersion("gem")
    .checkRubyPackageVersion("bundle")
    .checkRubyPackageVersion("ronn")
    if (Sys.getenv("KOOPA_CHECK_FAIL") == 1L) {
        stop("System failed checks.", call. = FALSE)
    }
}
