#' Create an adjusted rschedule
#'
#' @description
#' `radjusted()` creates a new adjusted rschedule on top of an existing one. The
#' new rschedule contains the same event dates as the existing rschedule,
#' except when they intersect with the dates in the event set of the
#' rschedule, `adjust_on`. In those cases, an `adjustment` is applied to the
#' problematic dates to shift them to valid event dates.
#'
#' This is most useful when creating corporate holiday rschedules. For example,
#' Christmas always falls on December 25th, but if it falls on a Saturday,
#' your company might observe Christmas on the previous Friday. If it falls
#' on a Sunday, you might observe it on the following Monday. In this case,
#' you could construct an rschedule for a recurring event of December 25th,
#' and a second rschedule for weekends. When Christmas falls on a weekend,
#' you would apply an adjustment of [adj_nearest()] to get the observance date.
#'
#' @inheritParams adj_following
#'
#' @param adjust_on `[rschedule]`
#'
#'   An rschedule that determines when the `adjustment` is to be applied.
#'
#' @param adjustment `[function]`
#'
#'   An adjustment function to apply to problematic dates. Typically one
#'   of the pre-existing adjustment functions, like [adj_nearest()].
#'
#'   A custom adjustment function must have two arguments `x` and `rschedule`.
#'   `x` is the complete vector of dates that possibly need adjustment.
#'   `rschedule` is the rschedule who's event set determines when an
#'   adjustment needs to be applied. The function should adjust `x` as required
#'   and return the adjusted Date vector.
#'
#' @return
#' An adjusted rschedule.
#'
#' @export
#' @examples
#' since <- "2000-01-01"
#' until <- "2010-01-01"
#'
#' on_christmas <- yearly(since = since, until = until) %>%
#'   recur_on_month_of_year("Dec") %>%
#'   recur_on_day_of_month(25)
#'
#' # All Christmas dates, with no adjustments
#' alma_events(on_christmas)
#'
#' on_weekends <- weekly(since = since, until = until) %>%
#'   recur_on_weekends()
#'
#' # Now all Christmas dates that fell on a weekend are
#' # adjusted either forwards or backwards, depending on which
#' # non-event date was closer
#' on_adj_christmas <- radjusted(on_christmas, on_weekends, adj_nearest)
#'
#' alma_events(on_adj_christmas)
radjusted <- function(rschedule, adjust_on, adjustment) {
  new_radjusted(rschedule, adjust_on, adjustment)
}

# ------------------------------------------------------------------------------

#' @export
print.almanac_radjusted <- function(x, ...) {
  cli::cli_text("<radjusted>")

  cli_indented()
  cli::cli_text(cli::style_underline("adjust:"))
  print(x$rschedule)
  cli::cli_end()

  cli_indented()
  cli::cli_text(cli::style_underline("adjust on:"))
  print(x$adjust_on)
  cli::cli_end()

  invisible(x)
}

# ------------------------------------------------------------------------------

#' @export
rschedule_events.almanac_radjusted <- function(x) {
  x$cache$get_events()
}

# ------------------------------------------------------------------------------

new_radjusted <- function(rschedule, adjust_on, adjustment) {
  check_rschedule(rschedule)
  check_rschedule(adjust_on)
  check_adjustment(adjustment)

  cache <- cache_radjusted$new(
    rschedule = rschedule,
    adjust_on = adjust_on,
    adjustment = adjustment
  )

  new_rschedule(
    rschedule = rschedule,
    adjust_on = adjust_on,
    adjustment = adjustment,
    cache = cache,
    class = "almanac_radjusted"
  )
}

# ------------------------------------------------------------------------------

check_adjustment <- function(x,
                             ...,
                             arg = caller_arg(x),
                             call = caller_env()) {
  check_function(x, arg = arg, call = call)

  fmls <- fn_fmls(x)

  if (length(fmls) != 2L) {
    cli::cli_abort(
      "{.arg {arg}} must have two arguments, {.arg x} and {.arg rschedule}.",
      call = call
    )
  }

  invisible(NULL)
}
