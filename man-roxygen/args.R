#' @param query Query terms
#' @param filter Filter options. See details.
#' @param offset Number of record to start at. Minimum: 1. For
#' \code{\link{cr_works}}, and any function setting \code{works = TRUE},
#' the maximum offset value is 10000. For larger requests use \code{cursor}.
#' @param limit Number of results to return in the query. Not relavant when
#' searching with specific dois. Default: 20. Max: 1000
#' @param sample (integer) Number of random results to return. when you use
#' the sample parameter, the rows and offset parameters are ignored.
#' Ignored unless \code{works=TRUE}. Max: 100
#' @param sort (character) Field to sort on, one of score, relevance, updated,
#' deposited, indexed, or published.
#' @param order (character) Sort order, one of 'asc' or 'desc'
