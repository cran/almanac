% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rholiday.R
\name{holiday-utilities}
\alias{holiday-utilities}
\alias{hol_observe}
\alias{hol_offset}
\alias{hol_rename}
\title{Holiday utility functions}
\usage{
hol_observe(x, adjust_on, adjustment)

hol_offset(x, by)

hol_rename(x, name)
}
\arguments{
\item{x}{\verb{[rholiday]}

An rholiday.}

\item{adjust_on}{\verb{[rschedule]}

An rschedule that determines when the \code{adjustment} is to be applied.}

\item{adjustment}{\verb{[function]}

An adjustment function to apply to problematic dates. Typically one
of the pre-existing adjustment functions, like \code{\link[=adj_nearest]{adj_nearest()}}.

A custom adjustment function must have two arguments \code{x} and \code{rschedule}.
\code{x} is the complete vector of dates that possibly need adjustment.
\code{rschedule} is the rschedule who's event set determines when an
adjustment needs to be applied. The function should adjust \code{x} as required
and return the adjusted Date vector.}

\item{by}{\verb{[integer(1)]}

A single integer to offset by.}

\item{name}{\verb{[character(1)]}

A new name for the holiday.}
}
\description{
These three functions allow you to tweak existing holidays created by
\code{\link[=rholiday]{rholiday()}} so that they more properly align with business calendars. The
resulting holidays can then be added into an \code{\link[=rcalendar]{rcalendar()}}.
\itemize{
\item \code{hol_observe()} adjusts a holiday based on when it is actually observed.
For example, many holidays that occur on a Saturday are actually observed
on the preceding Friday or following Monday.
\item \code{hol_offset()} creates a new holiday by \emph{offsetting} it from an existing
one. For example, Boxing Day is the day after Christmas, and the observance
of Boxing Day may be dependent on the observance of Christmas (i.e. if
Christmas is Sunday, it may be observed on Monday, so Boxing Day would be
observed on Tuesday).
\item \code{hol_rename()} renames an existing holiday. This is typically useful after
a call to \code{hol_offset()}, since it doesn't rename the holiday but you may
want to give it a different name.
}
}
\examples{

on_weekends <- weekly() \%>\%
  recur_on_weekends()

# Christmas, adjusted to nearest Friday or Monday if it falls on a weekend
on_christmas <- hol_christmas() \%>\%
  hol_observe(on_weekends, adj_nearest)

# Boxing Day is the day after Christmas.
# If observed Christmas is a Friday, then observed Boxing Day should be Monday.
# If observed Christmas is a Monday, then observed Boxing Day should be Tuesday.
on_boxing_day <- on_christmas \%>\%
  hol_offset(1) \%>\%
  hol_observe(on_weekends, adj_following) \%>\%
  hol_rename("Boxing Day")

christmas_dates <- alma_events(on_christmas, year = 2010:2015)
boxing_day_dates <- alma_events(on_boxing_day, year = 2010:2015)

data.frame(
  christmas = christmas_dates,
  boxing_day = boxing_day_dates,
  christmas_weekday = lubridate::wday(christmas_dates, label = TRUE),
  boxing_day_weekday = lubridate::wday(boxing_day_dates, label = TRUE)
)
}
