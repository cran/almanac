% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/recur-on-month-of-year.R
\name{recur_on_month_of_year}
\alias{recur_on_month_of_year}
\title{Recur on a month of the year}
\usage{
recur_on_month_of_year(x, month)
}
\arguments{
\item{x}{\verb{[rrule]}

A recurrence rule.}

\item{month}{\verb{[integer / character]}

Months of the year to mark as events. Integer values must be between
\verb{[1, 12]}. This can also be a full month string like \code{"November"}, or an
abbreviation like \code{"Nov"}.}
}
\value{
An updated rrule.
}
\description{
\code{recur_on_month_of_year()} recurs on a specific month of the year.
}
\examples{
# There is a big difference between adding this rule to a `yearly()`
# or `monthly()` frequency, and a `daily()` frequency.

# Limit from every day to every day in February
on_feb_daily <- daily() \%>\% recur_on_month_of_year("Feb")

# Limit from 1 day per month to 1 day in February
on_feb_monthly <- monthly() \%>\% recur_on_month_of_year("Feb")

start <- "1999-01-01"
end <- "2001-01-01"

alma_search(start, end, on_feb_daily)

alma_search(start, end, on_feb_monthly)
}
