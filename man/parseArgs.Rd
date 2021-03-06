% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parseArgs.R
\name{parseArgs}
\alias{parseArgs}
\alias{positionalArgs}
\alias{hasPositionalArgs}
\title{Parse command line argument flags}
\usage{
parseArgs(required = NULL, optional = NULL, flags = NULL, positional = FALSE)

positionalArgs()

hasPositionalArgs()
}
\arguments{
\item{required, optional}{\code{character} or \code{NULL}.
Valid key-value pair argument names.
For example, \code{aaa} for \code{--aaa=AAA} or \verb{--aaa AAA}.
Note that \verb{--aaa AAA}-style arguments (note lack of \code{=}) are not currently
supported.}

\item{flags}{\code{character} or \code{NULL}.
Valid long flag names.
For example, \code{aaa} for \code{--aaa}.
Short flags, such as \code{-r}, are intentionally not supported.}

\item{positional}{\code{logical(1)}.
Require positional arguments to be defined.}
}
\value{
\code{list}.
Named list containing arguments, organized by type:
\itemize{
\item \code{required}
\item \code{optional}
\item \code{flags}
\item \code{positional}
}
}
\description{
Parse command line argument flags
}
\note{
Updated 2021-01-06.
}
\examples{
## Inside Rscript:
## > args <- parseArgs(
## >     required = c("aaa", "bbb"),
## >     optional = c("ccc", "ddd"),
## >     flags = "force",
## >     positional = TRUE
## > )
## > aaa <- args[["required"]][["aaa"]]
## > force <- "force" \%in\% args[["flags"]]
## > posArgs <- args[["positional"]]
}
\seealso{
\itemize{
\item argparse Python package.
\item argparser R package.
\item optparse R package.
}
}
