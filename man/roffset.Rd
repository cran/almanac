% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/roffset.R
\name{roffset}
\alias{roffset}
\title{Create an offset rschedule}
\usage{
roffset(rschedule, by)
}
\arguments{
\item{rschedule}{\verb{[rschedule]}

An rschedule to offset.}

\item{by}{\verb{[integer(1)]}

A single integer to offset by.}
}
\value{
An offset rschedule.
}
\description{
\code{roffset()} creates a new rschedule with events that are \emph{offset} from an
existing rschedule by a certain amount. This can be useful when generating
relative events like "the day after Christmas."
}
\examples{
on_christmas <- yearly() \%>\%
  recur_on_month_of_year("Dec") \%>\%
  recur_on_day_of_month(25)

on_day_after_christmas <- roffset(on_christmas, by = 1)

alma_search("2018-01-01", "2023-01-01", on_day_after_christmas)

# Now what if you want the observed holiday representing the day after
# Christmas?
on_weekends <- weekly() \%>\% recur_on_weekends()

# Adjust Christmas to the nearest weekday
on_christmas <- radjusted(on_christmas, on_weekends, adj_nearest)

# Offset by 1 and then adjust that to the following weekday.
# We never adjust backwards because that can coincide with the observed day
# for Christmas.
on_day_after_christmas <- on_christmas \%>\%
  roffset(by = 1) \%>\%
  radjusted(on_weekends, adj_following)

# Note that:
# - A Christmas on Friday the 24th resulted in a day after Christmas of
#   Monday the 27th
# - A Christmas on Monday the 26th resulted in a day after Christmas of
#   Tuesday the 27th
christmas <- alma_search("2018-01-01", "2023-01-01", on_christmas)
day_after_christmas <- alma_search("2018-01-01", "2023-01-01", on_day_after_christmas)

lubridate::wday(christmas, label = TRUE)
lubridate::wday(day_after_christmas, label = TRUE)
}
