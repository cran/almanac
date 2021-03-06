% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/alma-search.R
\name{alma_search}
\alias{alma_search}
\title{Search for events}
\usage{
alma_search(from, to, rschedule, inclusive = TRUE)
}
\arguments{
\item{from, to}{\verb{[Date(1)]}

Dates defining the range to look for events.}

\item{rschedule}{\verb{[rschedule]}

An rschedule, such as an rrule or rbundle.}

\item{inclusive}{\verb{[logical(1)]}

If \code{from} or \code{to} are events, should they be included?}
}
\value{
A Date vector of all events between \code{from} and \code{to}.
}
\description{
\code{alma_search()} retrieves all events between \code{from} and \code{to}.
}
\examples{
on_12th <- monthly() \%>\% recur_on_mday(12)
on_monday <- weekly() \%>\% recur_on_wday("Monday")

# On the 12th of the month, or on Mondays
rb <- runion() \%>\%
  add_rschedule(on_12th) \%>\%
  add_rschedule(on_monday)

alma_search("2019-01-01", "2019-01-31", rb)
}
