context("testing cr_works")


test_that("cr_works returns", {
  skip_on_cran()

  a <- cr_works(query="NSF")
  b <- cr_works(query="renear+-ontologies")
  c <- cr_works(query="global state", filter=c(has_orcid=TRUE), limit=3)
  d <- cr_works(filter=c(has_full_text = TRUE))
  e <- cr_works(dois=c('10.1007/12080.1874-1746','10.1007/10452.1573-5125', '10.1111/(issn)1442-9993'))
  f <- cr_works(query="NSF", facet=TRUE, limit=0)
  g <- cr_works(sample=1)
  h <- cr_works(query="NSF", facet=TRUE)
  i <- suppressWarnings(cr_works(dois=c('blblbl', '10.1038/nnano.2014.279')))

  # correct class
  expect_is(a, "list")
  expect_is(b, "list")
  expect_is(c, "list")
  expect_is(d, "list")
  expect_is(e, "list")
  expect_is(f, "list")
  expect_is(g, "list")
  expect_is(h, "list")
  expect_is(i, "list")

  expect_is(a$meta, "data.frame")
  expect_is(a$data, "data.frame")
  expect_is(a$data, "tbl_df")
  expect_is(a$data$URL, "character")
  expect_equal(a$facets, NULL)

  expect_is(h, "list")
  expect_is(h$meta, "data.frame")
  expect_is(h$facets, "list")
  expect_is(h$facets$license, "data.frame")
  expect_is(h$facets$license$.id, "character")

  expect_equal(i$meta, NULL)
  expect_equal(i$facets, NULL)
  expect_is(i$data, "tbl_df")

  # dimensions are correct
  expect_equal(length(a), 3)
  expect_equal(length(b), 3)
  expect_equal(length(c), 3)
  expect_equal(length(d), 3)
  expect_equal(length(e), 3)
  expect_equal(length(f), 3)
  expect_equal(length(g), 3)
  expect_equal(length(h), 3)
  expect_equal(length(i), 3)
})

test_that("cr_works fails correctly", {
  skip_on_cran()

  expect_error(cr_works(timeout_ms = 1))
  expect_equal(NROW(cr_works(query = "adfaaf")$data), 0)
})


test_that("cr_works warns correctly", {
  skip_on_cran()

  expect_warning(cr_works(dois = c('blblbl', '10.1038/nnano.2014.279')), "Resource not found")
  expect_equal(NROW(suppressWarnings(cr_works(dois = c('blblbl', '10.1038/nnano.2014.279'))$data)), 1)
})


test_that("cr_works - parses links data correctly", {
  skip_on_cran()

  aa <- cr_works(filter = c(has_full_text = FALSE), limit = 10)
  bb <- cr_works(filter = c(has_full_text = TRUE), limit = 10)

  expect_is(aa, "list")
  expect_is(bb, "list")

  expect_equal(length(Filter(Negate(is.null), aa$data$link)), 0)
  expect_gt(length(Filter(Negate(is.null), bb$data$link)), 0)

  expect_is(bb$data$link[[1]], "data.frame")
  expect_match(bb$data$link[[1]]$URL, "http")
})

test_that("cr_works - parses funders correctly", {
  skip_on_cran()

  doi <- "10.1515/crelle-2013-0024"
  aa <- cr_works(doi)

  expect_is(aa, "list")
  expect_is(aa$data, "data.frame")
  expect_is(aa$data$container.title, "character")
  expect_equal(aa$facets, NULL)
  expect_is(aa$data$funder, "list")
  expect_is(aa$data$funder[[1]], "data.frame")
  expect_true(any(grepl("funder", names(aa$data))))

  doi <- "10.1186/isrctn11093872"
  bb <- cr_works(doi)
  expect_true(any(grepl("funder", names(bb$data))))
  expect_named(bb$data$funder[[1]], c("DOI", "name", "doi.asserted.by"))

  doi <- "10.1145/2831244.2831252"
  cc <- cr_works(doi)
  expect_true(any(grepl("funder", names(cc$data))))
  expect_named(cc$data$funder[[1]], c("name", "award"))

  doi <- "10.1145/2834800.2834802"
  dd <- cr_works(doi)
  expect_true(any(grepl("funder", names(dd$data))))
  expect_named(dd$data$funder[[1]],
               c("DOI", "name", "doi.asserted.by", "award"))

  doi <- "10.1145/2834800.2834802"
  dd <- cr_works(doi)
  expect_true(any(grepl("funder", names(dd$data))))
  expect_named(dd$data$funder[[1]],
               c("DOI", "name", "doi.asserted.by", "award"))

  doi <- "10.1145/2832099.2832103"
  ee <- cr_works(doi)
  expect_true(any(grepl("funder", names(ee$data))))
  expect_named(ee$data$funder[[1]],
               c("DOI", "name", "doi.asserted.by", "award"))

  doi <- "10.1016/j.pediatrneurol.2015.06.002"
  ff <- cr_works(doi)
  expect_true(any(grepl("funder", names(ff$data))))
  expect_named(ff$data$funder[[1]], c("DOI", "name", "doi.asserted.by"))

  doi <- "10.1016/j.tcs.2015.06.001"
  gg <- cr_works(doi)
  expect_true(any(grepl("funder", names(gg$data))))
  expect_named(gg$data$funder[[1]],
               c("DOI", "name", "doi.asserted.by", "award"))

  doi <- "10.1016/j.ffa.2015.10.008"
  hh <- cr_works(doi)
  expect_true(any(grepl("funder", names(hh$data))))
  expect_named(
    hh$data$funder[[1]],
    c("DOI", "name", "doi.asserted.by", "award1", "award2", "award3"))
})

test_that("cr_works - parses affiliation inside authors correctly", {
  skip_on_cran()

  doi <- "10.4018/978-1-4666-9588-7.les2"
  aa <- cr_works(doi)
  expect_true(any(grepl("author", names(aa$data))))
  expect_named(aa$data$author[[1]], c("given", "family", "affiliation.name"))
})

test_that("cr_works - email works", {
          skip_on_cran()
  
          Sys.setenv("crossref_email" = "name@example.com")
          a <- cr_works(query="NSF")
          expect_is(a, "list")
})

test_that("cr_works - email is validated", {
  skip_on_cran()
  
  Sys.setenv("crossref_email" = "name@example")
  expect_error(cr_works(query="NSF"))
})

test_that("cr_works - email NULL works", {
  skip_on_cran()
  
  Sys.setenv("crossref_email" = "")
  a <- cr_works(query="NSF")
  expect_is(a, "list")
})

Sys.sleep(2)

