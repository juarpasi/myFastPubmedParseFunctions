#' Split a vector into a match with grep
#'
#' @description
#' Take a vector and a pattern.
#' The vector the is splitter each time a pattern appear
#' 
#' Also, when the first element has no pattern this could be dropped
#' 
#' @param str.vec A str vector
#' @param splitter chr vect. A pattern
#' @param drop.first FALSE (by default). If is TRUE, then the fisrt element is remove if has no math with pattern
#' @return A list of vector, each element of the list has the first chr with a pattern
#'
#' @examples
#' splitAt(c('a','a','b','a','b','c'),'a')
#' splitAt(c('a','a','b','a','b','c'),'b')
#' splitAt(c('a','a','b','a','b','c'),'b', drop.first = T)
#' #[out] $`1`
#' #[1] "b" "a"
#' 
#' #$`2`
#' #[1] "b" "c"
#'
#' @export
#'

splitAt <- function(str.vec,
                    splitter,
                    drop.first = FALSE) {
  
  #find where the splitter appear
  positions <- grep(splitter,str.vec)
  
  #return a list with a the first element each splitter
  vectorList <- split(str.vec, findInterval(seq_along(str.vec), positions))
  
  if (positions[1] !=1) {
    message("The first element has no match splitter")
    if (isTRUE(drop.first)) {
      message("Removing the fisrt element")
      vectorList <- vectorList[-1]
      return(vectorList)
    }
  }
  
  return(vectorList)

}