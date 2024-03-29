% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calendars.R
\name{cal_us_federal}
\alias{cal_us_federal}
\title{US federal calendar}
\usage{
cal_us_federal(since = NULL, until = NULL)
}
\arguments{
\item{since}{\verb{[Date(1)]}

A lower bound on the event set to generate.

Defaults to \code{\link[=almanac_since]{almanac_since()}} if not set.}

\item{until}{\verb{[Date(1)]}

An upper bound on the event set to generate.

Defaults to \code{\link[=almanac_until]{almanac_until()}} if not set.}
}
\value{
An rcalendar.
}
\description{
\code{cal_us_federal()} is an example calendar that represents the federal
holidays in the United States. It makes no attempt to be historically
accurate, but instead represents the \emph{currently} recognized federal holidays.
The calendar represents the \emph{observed} dates of each holiday, rather than the
actual dates of each holiday (i.e. if a holiday falls on a Saturday, it is
federally observed on the preceding Friday).

Refer to the source code of \code{cal_us_federal()} to get a feel for how to
build your own personal calendar.
}
\examples{
cal <- cal_us_federal()

# All 2023 holidays
cal_events(cal, year = 2023)

# Notice that for 2028, `cal_events()` knows that you probably want to
# treat New Year's Day as a 2028 holiday even though it will observed in
# 2027 (because it will be a Saturday and will be rolled back to being
# observed on Friday)
cal_events(cal, year = 2028)

# Were any of these dates on a holiday?
x <- as.Date(c(
  "2023-11-10",
  "2023-10-05",
  "2023-06-19",
  "2023-05-29",
  "2023-05-28"
))

alma_in(x, cal)

# Which one?
cal_match(x, cal)
}
