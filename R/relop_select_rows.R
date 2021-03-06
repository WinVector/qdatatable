
#' Select rows by condition.
#'
#' \code{data.table} based implementation.
#'
#' @inheritParams ex_data_table_step
#'
#' @examples
#'
#' dL <- build_frame(
#'     "x", "y" |
#'     2L , "b" |
#'     1L , "a" |
#'     3L , "c" )
#' rquery_pipeline <- local_td(dL) %.>%
#'   select_rows_nse(., x <= 2)
#' dL %.>% rquery_pipeline
#'
#' @export
ex_data_table_step.relop_select_rows <- function(optree,
                                            ...,
                                            tables = list(),
                                            source_usage = NULL,
                                            source_limit = NULL,
                                            env = parent.frame()) {
  force(env)
  wrapr::stop_if_dot_args(substitute(list(...)), "rqdatatable::ex_data_table_step.relop_select_rows")
  if(is.null(source_usage)) {
    source_usage <- columns_used(optree)
  }
  x <- ex_data_table_step(optree$source[[1]],
                     tables = tables,
                     source_usage = source_usage,
                     source_limit = source_limit,
                     env = env)
  tmpnam <- ".rquery_ex_select_rows_tmp"
  src <- vapply(seq_len(length(optree$parsed)),
                function(i) {
                  paste("(", optree$parsed[[i]]$presentation, ")")
                }, character(1))
  lsrc <- remap_parsed_exprs_for_data_table(src)
  src <- paste0(tmpnam, "[ ", paste(lsrc$eexprs, collapse = " & "), " ]")
  expr <- parse(text = src)
  tmpenv <- patch_global_child_env(env)
  assign(tmpnam, x, envir = tmpenv)
  eval(expr, envir = tmpenv, enclos = tmpenv)
}

