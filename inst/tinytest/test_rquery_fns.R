
test_rquery_fns <- function() {

   a <- data.frame(x = c(1, 2) , y = c(20, 30), z = c(300, 400))
   optree <- local_td(a) %.>%
      select_columns(., c("x", "y")) %.>%
      select_rows_nse(., x<2 & y<30)
   # cat(format(optree))
   # print(ex_data_table(optree))
   expect_true("relop" %in% class(optree))

   invisible(NULL)
}

test_rquery_fns()

