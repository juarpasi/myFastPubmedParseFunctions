#' a fn for make a df from a doc with attr and text
#'
#' @description
#' This function take a list of text nodes and make a dataframe with its attributes
#' 
#' This also accept a id
#' 
#' @param doc A xml document
#' @param xpath chr vect. the path of the nodes
#' @param attribs NULL by default
#'   * `NULL` (the default): it find out for all the attributes availables
#'   * `chr vect`: names of the attributes to get.
#' @return A dataframe.
#'
#' @examples
#' # Chop ----------------------------------------------------------------------
#' html_text <- '
#' <h2>A simple H1</h2>
#' <div>
#'   <buz col = "r", date = "2003">B1</buz>
#'   <buz col = "b", date = "2013", name = "foo">B2</buz>
#'   <buz col = "y", date = "2023">B3</buz>
#' </div>
#' 
#' <h2>A simple H2</h2>
#' <div>
#'   <buz col = "g", date = "20203">B4</buz>
#'   <buz col = "b", date = "20203", name = "foo2">B6</buz>
#'   <buz col = "c", date = "20203">B6</buz>
#' </div>
#' '
#' doc <- read_html(html_text)
#' 
#' df <- nodeList2Df(doc, xpath = './/div//buz', id = 'doc1', attribs = c('co','date'))
#'
#' # Unchop --------------------------------------------------------------------
#'
#' @export
#'
#'

nodeList2Df <- function(doc, xpath, id = NA, attribs = NULL) {
  
  #get nodes
  nodes <- doc |>
  xml_find_all(xpath)
  
  if (length(nodes) == 0) {
    return(NULL)
  }
  
  #get text
  df <- data.frame(text = xml2::xml_text(nodes))
  
  #get value of attr and add to dataframe
  if (is.null(attribs)) {
    df2 <- xml_attrs(nodes) |>
      #to do: manage when the nodes are of different sizes, and prevent the resuse of the vector
      do.call(rbind, arg = _)
    df <- cbind(df,df2)
  }else{
    for (att in attribs) {
      df[att] <- xml_attr(nodes, attr = att)
    }
  }
  #add id
  df['id'] <- id
  nodes <- NULL
  
  return(df)
}
