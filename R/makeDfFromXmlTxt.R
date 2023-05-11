#' Convert a node of a xml doc into a dataframe
#'
#' @description
#' find a node and then use its name as a variable for the df, and the text for the value.
#' 
#' This also accept a id
#' 
#' @param doc A xml document
#' @param xpath chr vect. the path of the nodes
#' @param id NULL (by default). A id of the doc
#' @return A dataframe.
#'
#' @examples
#' # Chop ----------------------------------------------------------------------
#' html_text <- '
#' <h2>A simple H1</h2>
#' <div>
#'   <buz>B1</buz>
#'   <buz>B2</buz>
#'   <buz>B3</buz>
#' </div>
#'
#' '
#' doc <- read_html(html_text)
#' 
#' df <- nodeList2Df(doc, xpath = './/div//buz', id = 'doc1')
#'
#' # Unchop --------------------------------------------------------------------
#'
#' @export
#'
#'

makeDfFromXmlTxt <- function(doc, xpath, id = NA) {
  
  node <- doc |>
    xml_find_first(xpath)
  
  name <- xml_name(node)
  
  if (is.na(name)) {
    node <- NULL
    return(NULL)
  }
  
  df <- data.frame(xml2::xml_text(node),id)
  colnames(df) <- c(name, 'id')
  
  node <- NULL
  return(df)
}
