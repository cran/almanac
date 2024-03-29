# ------------------------------------------------------------------------------
# stepper()

test_that("allows integerish input", {
  rrule <- daily()
  step <- stepper(rrule)
  expect_identical(step(1), step(1L))
})

test_that("must be integerish `n`", {
  step <- stepper(daily())
  expect_snapshot(error = TRUE, {
    step(1.5)
  })
})

# ------------------------------------------------------------------------------
# workdays()

test_that("workdays works", {
  x <- as.Date("2020-04-24")
  expect_identical(x %s+% workdays(1), x + 3)
})

# ------------------------------------------------------------------------------
# new_stepper()

test_that("can create an empty stepper", {
  x <- new_stepper()
  attributes(x) <- NULL
  expect_identical(x, integer())
})

test_that("can create a new stepper", {
  rrule <- daily()
  x <- new_stepper(rschedule = rrule)
  expect_s3_class(x, c("stepper", "vctrs_vctr"))
  expect_identical(attr(x, "rschedule"), rrule)
})

test_that("`n` is validated", {
  expect_snapshot(error = TRUE, {
    new_stepper(1)
  })
})

test_that("`rschedule` is validated", {
  expect_snapshot(error = TRUE, {
    new_stepper(rschedule = 1)
  })
})

# ------------------------------------------------------------------------------
# vec_arith()

test_that("default method error is thrown", {
  expect_snapshot({
    (expect_error(vec_arith("+", new_stepper(), 1), class = "vctrs_error_incompatible_op"))
    (expect_error(vec_arith("+", 1, new_stepper()), class = "vctrs_error_incompatible_op"))
  })
})

test_that("can use unary ops", {
  rb <- runion()
  step <- stepper(rb)

  expect_equal(+step(1), step(1))
  expect_equal(-step(1), step(-1))
})

test_that("can add stepper to date", {
  rrule <- recur_on_weekends(weekly())
  step <- stepper(rrule)

  # friday
  x <- as.Date("1970-01-02")

  expect_identical(
    step(1) %s+% x,
    x + 3
  )
})

test_that("can add date to stepper", {
  rrule <- recur_on_weekends(weekly())
  step <- stepper(rrule)

  # friday
  x <- as.Date("1970-01-02")

  expect_identical(
    x %s+% step(1),
    x + 3
  )
})

test_that("can subtract stepper from date", {
  rrule <- recur_on_weekends(weekly())
  step <- stepper(rrule)

  # monday
  x <- as.Date("1970-01-05")

  expect_identical(
    x %s-% step(1),
    x - 3
  )
})

test_that("cannot subtract date from stepper", {
  rrule <- recur_on_weekends(weekly())
  step <- stepper(rrule)

  # monday
  x <- as.Date("1970-01-05")

  expect_snapshot(error = TRUE, {
    step(1) %s-% x
  })
})

# ------------------------------------------------------------------------------
# vec_ptype2()

test_that("steppers are coercible if from the same rschedule", {
  rrule <- weekly()
  x_step <- stepper(rrule)
  y_step <- stepper(rrule)
  x <- x_step(1)
  y <- y_step(2)

  expect_step <- stepper(rrule)
  expect <- expect_step(integer())

  expect_identical(vec_ptype2(x, y), expect)

  expect_snapshot(error = TRUE, {
    vec_ptype2(x, new_stepper())
  })
})

# ------------------------------------------------------------------------------
# vec_cast()

test_that("steppers are coercible if from the same rschedule", {
  rrule <- weekly()
  x_step <- stepper(rrule)
  y_step <- stepper(rrule)
  x <- x_step(1)
  y <- y_step(2)

  expect_identical(vec_cast(x, y),  x)
  expect_identical(vec_cast(y, x),  y)

  expect_snapshot(error = TRUE, {
    vec_cast(x, new_stepper())
  })
})

# ------------------------------------------------------------------------------
# slider_plus() / slider_minus()

test_that("`slider_plus()` method is registered", {
  skip_if_not_installed("slider", minimum_version = "0.3.0")

  y <- workdays(1)

  # friday
  x <- as.Date("1970-01-09")

  expect_identical(
    slider::slider_plus(x, y),
    as.Date("1970-01-12")
  )

  # monday
  x <- as.Date("1970-01-12")

  expect_identical(
    slider::slider_plus(x, y),
    as.Date("1970-01-13")
  )
})

test_that("`slider_minus()` method is registered", {
  skip_if_not_installed("slider", minimum_version = "0.3.0")

  y <- workdays(1)

  # monday
  x <- as.Date("1970-01-12")

  expect_identical(
    slider::slider_minus(x, y),
    as.Date("1970-01-09")
  )

  # friday
  x <- as.Date("1970-01-09")

  expect_identical(
    slider::slider_minus(x, y),
    as.Date("1970-01-08")
  )
})

test_that("`slide_index()` works with steppers", {
  skip_if_not_installed("slider", minimum_version = "0.3.0")

  # wednesday -> wednesday
  x <- 1:8
  i <- as.Date("1970-01-07") + 0:7

  out <- slider::slide_index(
    .x = x,
    .i = i,
    .f = identity,
    .before = workdays(1),
    .after = workdays(1)
  )

  expect_identical(
    out,
    list(
      1:2, # On Wed, Bounds Tue-Thu
      1:3, # On Thu, Bounds Wed-Fri
      2:6, # On Fri, Bounds Thu-Mon
      3:6, # On Sat, Bounds Fri-Mon
      3:6, # On Sun, Bounds Fri-Mon
      3:7, # On Mon, Bounds Fri-Tue
      6:8, # On Tue, Bounds Mon-Wed
      7:8  # On Wed, Bounds Tue-Thu
    )
  )
})
