#' Check system
#'
#' @export
#' @note Updated 2020-08-11.
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
    macos <- isMacOS()
    linux <- !macos
    host <- shell(command = koopa, args = "host-id", stdout = TRUE)
    os <- shell(command = koopa, args = "os-string", stdout = TRUE)
    docker <- isDocker()
    ## Basic dependencies ======================================================
    h2("Basic dependencies")
    checkInstalled(
        which = c(
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
        ),
        path = FALSE
    )
    ## Shells ==================================================================
    h2("Shells")
    checkVersion(name = "bash", nameFancy = "Bash")
    checkVersion(name = "zsh", nameFancy = "Zsh")
    checkVersion(name = "fish", nameFancy = "Fish")
    ## Core packages ===========================================================
    h2("Core packages")
    checkVersion(name = "autoconf", nameFancy = "GNU autoconf")
    checkVersion(name = "automake", nameFancy = "GNU automake")
    if (isTRUE(linux)) {
        checkVersion(name = "binutils", nameFancy = "GNU binutils")
    }
    checkVersion(name = "coreutils", nameFancy = "GNU coreutils")
    checkVersion(name = "findutils", nameFancy = "GNU findutils")
    checkVersion(name = "gawk", nameFancy = "GNU gawk")
    ## > checkVersion(name = "gcc", nameFancy = "GNU gcc")
    checkVersion(
        name = "GNU grep",
        whichName = "grep",
        current = currentVersion("grep"),
        expected = expectedVersion("grep")
    )
    if (isTRUE(linux)) {
        checkVersion(
            name = "GNU libtool",
            whichName = "libtool",
            current = currentVersion("libtool"),
            expected = expectedVersion("libtool")
        )
    }
    checkVersion(
        name = "GNU make",
        whichName = "make",
        current = currentVersion("make"),
        expected = expectedVersion("make")
    )
    if (isTRUE(linux)) {
        checkVersion(
            name = "GNU ncurses",
            whichName = "ncurses6-config",
            current = currentMinorVersion("ncurses"),
            expected = expectedVersion("ncurses")
        )
    }
    checkVersion(
        name = "GNU parallel",
        whichName = "parallel",
        current = currentVersion("parallel"),
        expected = expectedVersion("parallel")
    )
    checkVersion(
        name = "GNU patch",
        whichName = "patch",
        current = currentVersion("patch"),
        expected = expectedVersion("patch")
    )
    checkVersion(
        name = "GNU sed",
        whichName = "sed",
        current = currentVersion("sed"),
        expected = expectedVersion("sed")
    )
    checkVersion(
        name = "GNU texinfo",
        whichName = "makeinfo",
        current = currentVersion("texinfo"),
        expected = expectedVersion("texinfo")
    )
    checkVersion(
        name = "GNU Wget",
        whichName = "wget",
        current = currentVersion("wget"),
        expected = expectedVersion("wget")
    )
    checkVersion(
        name = "CMake",
        whichName = "cmake",
        current = currentVersion("cmake"),
        expected = expectedVersion("cmake")
    )
    checkVersion(
        name = "cURL",
        whichName = "curl",
        current = currentVersion("curl"),
        expected = expectedVersion("curl")
    )
    checkVersion(
        name = "OpenSSH",
        whichName = "ssh",
        current = currentVersion("openssh"),
        expected = expectedVersion("openssh")
    )
    checkVersion(
        name = "pkg-config",
        whichName = "pkg-config",
        current = currentVersion("pkg-config"),
        expected = expectedVersion("pkg-config")
    )
    checkVersion(
        name = "rsync",
        whichName = "rsync",
        current = currentVersion("rsync"),
        expected = expectedVersion("rsync")
    )
    ## Editors =================================================================
    h2("Editors")
    checkVersion(
        name = "Emacs",
        whichName = "emacs",
        current = currentVersion("emacs"),
        expected = expectedVersion("emacs")
    )
    checkVersion(
        name = "Neovim",
        whichName = "nvim",
        current = currentVersion("neovim"),
        expected = expectedVersion("neovim")
    )
    checkVersion(
        name = "Tmux",
        whichName = "tmux",
        current = currentVersion("tmux"),
        expected = expectedVersion("tmux")
    )
    checkVersion(
        name = "Vim",
        whichName = "vim",
        current = currentMinorVersion("vim"),
        expected = expectedMinorVersion("vim")
    )
    ## Languages ===============================================================
    h2("Primary languages")
    checkVersion(
        name = "Python",
        whichName = "python3",
        current = currentVersion("python"),
        expected = expectedVersion("python")
    )
    checkVersion(
        name = "R",
        current = currentVersion("r"),
        expected = expectedVersion("r")
    )
    h2("Secondary languages")
    if (!isTRUE(docker)) {
        checkVersion(
            name = "Go",
            whichName = "go",
            current = currentMinorVersion("go"),
            expected = expectedMinorVersion("go")
        )
    }
    checkVersion(
        name = "Java : OpenJDK",
        whichName = "java",
        current = currentVersion("openjdk"),
        expected = expectedVersion("openjdk")
    )
    if (!isTRUE(docker)) {
        checkVersion(
            name = "Julia",
            whichName = "julia",
            current = currentVersion("julia"),
            expected = expectedVersion("julia")
        )
    }
    checkVersion(
        name = "Perl",
        whichName = "perl",
        current = currentVersion("perl"),
        expected = expectedVersion("perl")
    )
    if (!isTRUE(docker)) {
        checkVersion(
            name = "Ruby",
            whichName = "ruby",
            current = currentVersion("ruby"),
            expected = expectedVersion("ruby")
        )
        checkVersion(
            name = "Rust",
            whichName = "rustc",
            current = currentVersion("rust"),
            expected = expectedVersion("rust")
        )
    }
    ## Version managers ========================================================
    h2("Version managers")
    condaPrefix <- shell(command = koopa, args = "conda-prefix", stdout = TRUE)
    if (file.exists(file.path(condaPrefix, "bin", "anaconda"))) {
        checkVersion(
            name = "Anaconda",
            whichName = "conda",
            current = currentVersion("anaconda"),
            expected = expectedVersion("anaconda")
        )
    } else {
        checkVersion(
            name = "Miniconda",
            whichName = "conda",
            current = currentVersion("conda"),
            expected = expectedVersion("conda")
        )
    }
    if (!isTRUE(docker)) {
        checkVersion(
            name = "Rust : rustup",
            whichName = "rustup",
            current = currentVersion("rustup"),
            expected = expectedVersion("rustup")
        )
    }
    ## Cloud APIs ==============================================================
    if (
        !identical(os, "arch-rolling") &&
        !identical(os, "opensuse-leap-15")
    ) {
        h2("Cloud APIs")
        checkInstalled("aws")
        if (!isTRUE(docker)) {
            checkInstalled(c("az", "gcloud"))
        }
    }
    ## Tools ===================================================================
    h2("Tools")
    checkVersion(
        name = "Git",
        whichName = "git",
        current = currentVersion("git"),
        expected = expectedVersion("git")
    )
    if (!isTRUE(docker)) {
        checkVersion(
            name = "htop",
            current = currentVersion("htop"),
            expected = expectedVersion("htop")
        )
    }
    checkVersion(
        name = "Neofetch",
        whichName = "neofetch",
        current = currentVersion("neofetch"),
        expected = expectedVersion("neofetch")
    )
    checkVersion(
        name = "Subversion",
        whichName = "svn",
        current = currentVersion("subversion"),
        expected = expectedVersion("subversion")
    )
    ## Shell tools =============================================================
    h2("Shell tools")
    if (!isTRUE(docker)) {
        checkVersion(
            name = "The Silver Searcher (Ag)",
            whichName = "ag",
            current = currentVersion("the-silver-searcher"),
            expected = expectedVersion("the-silver-searcher")
        )
        checkVersion(
            name = "autojump",
            whichName = "autojump",
            current = currentVersion("autojump"),
            expected = expectedVersion("autojump")
        )
        checkVersion(
            name = "fzf",
            whichName = "fzf",
            current = currentVersion("fzf"),
            expected = expectedVersion("fzf")
        )
    }
    checkVersion(
        name = "ShellCheck",
        whichName = "shellcheck",
        current = currentVersion("shellcheck"),
        expected = expectedVersion("shellcheck")
    )
    checkInstalled("shunit2")
    ## Heavy dependencies ======================================================
    if (!isTRUE(docker)) {
        h2("Heavy dependencies")
        checkVersion(
            name = "PROJ",
            whichName = "proj",
            current = currentVersion("proj"),
            expected = expectedVersion("proj")
            ## > expected = ifelse(
            ## >     test = isTRUE(macos),
            ## >     yes = "6.3.2",
            ## >     no = expectedVersion("proj")
            ## > )
        )
        checkVersion(
            name = "GDAL",
            whichName = "gdalinfo",
            current = currentVersion("gdal"),
            expected = expectedVersion("gdal")
            ## > expected = ifelse(
            ## >     test = isTRUE(macos),
            ## >     yes = "2.4.4",
            ## >     no = expectedVersion("gdal")
            ## > )
        )
        checkVersion(
            name = "GEOS",
            whichName = "geos-config",
            current = currentVersion("geos"),
            expected = expectedVersion("geos")
        )
        checkVersion(
            name = "GSL",
            whichName = "gsl-config",
            current = currentVersion("gsl"),
            expected = expectedVersion("gsl")
        )
        checkVersion(
            name = "HDF5",
            whichName = "h5cc",
            current = currentVersion("hdf5"),
            expected = expectedVersion("hdf5")
        )
        checkVersion(
            name = "LLVM",
            ## > whichName = "llvm-config",
            whichName = NA,
            current = currentMajorVersion("llvm"),
            expected = switch(
                EXPR = os,
                `rhel-7` = "7",
                expectedMajorVersion("llvm")
            )
        )
        checkVersion(
            name = "SQLite",
            whichName = "sqlite3",
            current = currentMinorVersion("sqlite"),
            expected = expectedMinorVersion("sqlite")
        )
        checkInstalled(
            which = c(
                "pandoc",
                "pandoc-citeproc",
                "tex"
            )
        )
    }
    ## OS-specific =============================================================
    if (isTRUE(linux)) {
        h2("Linux specific")
        checkVersion(
            name = "GnuPG",
            whichName = "gpg",
            current = currentVersion("gnupg"),
            expected = expectedVersion("gnupg")
        )
        if (!isTRUE(docker)) {
            checkVersion(
                name = "Aspera Connect",
                whichName = "ascp",
                current = currentVersion("aspera-connect"),
                expected = expectedVersion("aspera-connect")
            )
            checkVersion(
                name = "Password store (pass)",
                current = currentVersion("password-store"),
                expected = expectedVersion("password-store")
            )
            checkVersion(
                name = "RStudio Server",
                whichName = "rstudio-server",
                current = currentVersion("rstudio-server"),
                expected = expectedVersion("rstudio-server")
            )
            checkVersion(
                name = "docker-credential-pass",
                current = currentVersion("docker-credential-pass"),
                expected = expectedVersion("docker-credential-pass")
            )
            checkVersion(
                name = "rename (Perl File::Rename)",
                whichName = "rename",
                current = currentVersion("perl-file-rename"),
                expected = expectedVersion("perl-file-rename")
            )
        }
    } else if (isTRUE(macos)) {
        h2("macOS specific")
        checkInstalled(
            which = c(
                "brew",
                "clang",
                "gcc"
            )
        )
        checkVersion(
            name = "TeX Live",
            whichName = "tex",
            current = currentVersion("tex"),
            expected = expectedVersion("tex")
        )
        checkHomebrewCaskVersion("gpg-suite")
    }
    ## High performance ========================================================
    if (
        isTRUE(linux) &&
        isTRUE(getOption("mc.cores") >= 3L) &&
        !isTRUE(docker)
    ) {
        h2("High performance")
        checkVersion(
            name = "Docker",
            whichName = "docker",
            current = currentVersion("docker"),
            expected = expectedVersion("docker")
        )
        checkVersion(
            name = "Shiny Server",
            whichName = "shiny-server",
            current = currentVersion("shiny-server"),
            expected = expectedVersion("shiny-server")
        )
        ## > checkVersion(
        ## >     name = "bcbio-nextgen",
        ## >     whichName = "bcbio_nextgen.py",
        ## >     current = currentVersion("bcbio-nextgen"),
        ## >     expected = expectedVersion("bcbio-nextgen")
        ## > )
        ## > checkInstalled("bcbio_vm.py", required = FALSE)
        ## > checkVersion(
        ## >     name = "bcl2fastq",
        ## >     current = currentVersion("bcl2fastq"),
        ## >     expected = expectedVersion("bcl2fastq"),
        ## >     required = FALSE
        ## > )
        checkVersion(
            name = "Lmod",
            whichName = NA,
            current = currentVersion("lmod"),
            expected = expectedVersion("lmod")
        )
        checkVersion(
            name = "Lua",
            whichName = "lua",
            current = currentVersion("lua"),
            expected = expectedVersion("lua")
        )
        checkVersion(
            name = "LuaRocks",
            whichName = "luarocks",
            current = currentVersion("luarocks"),
            expected = expectedVersion("luarocks")
        )
        # > checkVersion(
        # >     name = "Singularity",
        # >     whichName = "singularity",
        # >     current = currentVersion("singularity"),
        # >     expected = expectedVersion("singularity")
        # > )
    }
    ## Python packages =========================================================
    h2("Python packages")
    checkInstalled(
        which = c(
            "black",
            "flake8",
            "pip3",
            "pylint",
            "pytest",
            "ranger"
        )
    )
    ## Rust cargo crates =======================================================
    if (!isTRUE(docker)) {
        h2("Rust cargo crates")
        checkInstalled(
            which = c(
                "broot",
                "cargo",
                "dust",
                "exa",
                "fd",
                "rg"
            )
        )
    }
    ## Ruby gems ===============================================================
    if (!isTRUE(docker)) {
        h2("Ruby gems")
        checkInstalled(
            which = c(
                "gem",
                "bundle",
                "ronn"
            )
        )
    }
    if (Sys.getenv("KOOPA_CHECK_FAIL") == 1L) {
        stop("System failed checks.", call. = FALSE)
    }
}
