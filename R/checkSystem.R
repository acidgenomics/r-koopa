#' Check system
#'
#' @export
#' @note Updated 2021-04-30.
#'
#' @details
#' If you see this error, reinstall ruby, rbenv, and emacs:
#' # Ignoring commonmarker-0.17.13 because its extensions are not built.
#' Try: gem pristine commonmarker --version 0.17.13
#'
#' @examples
#' ## > checkSystem()
checkSystem <- function() {
    if (isDocker()) {
        stop("System checks are not supported for Docker images.")
    }
    h1("Checking koopa installation.")
    koopa <- koopa()
    platform <- ifelse(test = isMacOS(), yes = "macos", no = "linux")
    ## Modify system path ======================================================
    koopaOpt <- file.path(dirname(dirname(koopa)), "opt")
    path <- Sys.getenv("PATH")
    path <- paste(
        file.path(koopaOpt, "conda", "condabin"),
        path,
        sep = ":"
    )
    Sys.setenv("PATH" = path)
    ## Basic dependencies ======================================================
    h2("Basic dependencies")
    .checkInstalled(
        name = c(
            ## > "[",
            ## > "basenc",
            ## > "chsh",  # lchsh on Fedora
            ## > "rename",
            ## > "top",
            ## > "uptime",
            ## > "dir",  # not on macos
            ## > "dircolors",  # not on macos
            ## > "factor",  # not on macos
            ## > "vdir",  # not on macos
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
            "dirname",
            "du",
            "echo",
            "env",
            "expand",
            "expr",
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
    .checkVersion("bash", nameFancy = "Bash")
    .checkVersion("zsh", nameFancy = "Zsh")
    .checkVersion("fish", nameFancy = "Fish")
    ## GNU packages ============================================================
    h2("GNU packages")
    .checkGNUVersion("autoconf")
    .checkGNUVersion("automake")
    .checkGNUVersion("gawk")
    .checkGNUVersion("groff")
    .checkGNUVersion("parallel")
    .checkGNUVersion("patch")
    .checkGNUVersion("stow")
    .checkGNUVersion("texinfo")
    .checkGNUVersion("wget")
    ## Core packages ===========================================================
    h2("Core packages")
    .checkVersion("boost", nameFancy = "Boost")
    .checkVersion("cairo", nameFancy = "Cairo")
    .checkVersion("cmake", nameFancy = "CMake")
    .checkVersion("curl", nameFancy = "cURL")
    .checkVersion("harfbuzz", nameFancy = "Harfbuzz")
    .checkVersion("imagemagick", nameFancy = "ImageMagick")
    .checkVersion("openssh", nameFancy = "OpenSSH")
    .checkVersion("pkg-config")
    .checkVersion("rsync")
    ## Editors =================================================================
    h2("Editors")
    .checkVersion("emacs", nameFancy = "Emacs")
    .checkVersion("neovim", nameFancy = "Neovim")
    .checkVersion("tmux", nameFancy = "Tmux")
    .checkVersion(
        name = "vim",
        nameFancy = "Vim",
        current = .currentMinorVersion("vim"),
        expected = .expectedMinorVersion("vim")
    )
    ## Languages ===============================================================
    h2("Primary languages")
    .checkVersion("python", nameFancy = "Python")
    .checkVersion("r", nameFancy = "R")
    h2("Secondary languages")
    .checkVersion("go", nameFancy = "Go")
    .checkVersion("openjdk", nameFancy = "Java : OpenJDK")
    .checkVersion("julia", nameFancy = "Julia")
    .checkVersion("node", nameFancy = "Node")
    .checkVersion("perl", nameFancy = "Perl")
    .checkVersion("ruby", nameFancy = "Ruby")
    .checkVersion("rust", nameFancy = "Rust")
    ## Version managers ========================================================
    h2("Version managers")
    condaPrefix <- shell(
        command = koopa,
        args = c("system", "prefix", "conda"),
        stdout = TRUE
    )
    if (file.exists(file.path(condaPrefix, "bin", "anaconda"))) {
        .checkVersion("anaconda", nameFancy = "Anaconda")
    } else {
        .checkVersion("conda", nameFancy = "Miniconda")
    }
    .checkVersion("rustup", nameFancy = "Rust : rustup")
    ## Cloud APIs ==============================================================
    h2("Cloud APIs")
    .checkInstalled(c("aws", "az", "gcloud"))
    ## Tools ===================================================================
    h2("Tools")
    .checkVersion("bfg", nameFancy = "BFG")
    .checkVersion("git", nameFancy = "Git")
    .checkVersion("htop")
    .checkVersion("neofetch", nameFancy = "Neofetch")
    .checkVersion("subversion", nameFancy = "Subversion")
    ## Shell tools =============================================================
    h2("Shell tools")
    .checkVersion("fzf")
    .checkVersion("the-silver-searcher", nameFancy = "The Silver Searcher")
    .checkVersion("hadolint")
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
    .checkVersion("pandoc", nameFancy = "Pandoc")
    .checkVersion("tex", nameFancy = "TeX")
    ## OS-specific =============================================================
    switch(
        EXPR = platform,
        "linux" = {
            h2("Linux specific")
            .checkGNUVersion("binutils")
            .checkGNUVersion("coreutils")
            .checkGNUVersion("findutils")
            .checkGNUVersion("gcc")
            .checkGNUVersion("grep")
            .checkGNUVersion("libtool")
            .checkGNUVersion("make")
            .checkGNUVersion("ncurses")
            .checkGNUVersion("sed")
            .checkGNUVersion("tar")
            .checkVersion("aspera-connect", nameFancy = "Aspera Connect")
            .checkVersion("docker", nameFancy = "Docker")
            .checkVersion("docker-credential-pass")
            .checkVersion("gnupg", nameFancy = "GnuPG")
            .checkVersion("icu", nameFancy = "ICU")
            .checkVersion("password-store", nameFancy = "Password Store")
            .checkVersion("perl-file-rename", nameFancy = "Perl File Rename")
            .checkVersion("rstudio-server", nameFancy = "RStudio Server")
            .checkVersion("sqlite", nameFancy = "SQLite")
            if (isTRUE(getOption("mc.cores") >= 3L)) {
                h3("High performance")
                .checkVersion("bcbio-nextgen")
                .checkVersion("bcl2fastq")
                .checkVersion("lmod", nameFancy = "Lmod")
                .checkVersion("lua", nameFancy = "Lua")
                .checkVersion("luarocks", nameFancy = "LuaRocks")
                .checkVersion("shiny-server", nameFancy = "Shiny Server")
                .checkVersion("singularity", nameFancy = "Singularity")
            }
        },
        "macos" = {
            h2("macOS specific")
            .checkInstalled("clang")
            .checkVersion("homebrew", nameFancy = "Homebrew")
            .checkVersion("tex", nameFancy = "TeX Live")
            .checkHomebrewCaskVersion("gpg-suite", nameFancy = "GPG Suite")
        }
    )
    ## Python packages =========================================================
    h2("Python packages")
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
    .checkRubyPackageVersion("bundler")
    .checkRubyPackageVersion("ronn")
    if (Sys.getenv("KOOPA_CHECK_FAIL") == 1L) {
        stop("System failed checks.", call. = FALSE)
    }
}
