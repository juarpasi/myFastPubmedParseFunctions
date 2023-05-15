#' Read a xml pubmed file into chr strings
#'
#' @description
#' Split the xml doc into one string by a PubmedArticle
#' 
#' This also accept a id
#' 
#' @param file_path chr vect. the path of the PubMed record file
#' @return chr vect with one element per article.
#'
#' @export
#'

readXMLPubmed <- function(file_path) {
  
  xml_doc <-
    read_xml(file_path, encoding = "UTF-8") |>
    # extract nodes with the tag
    xml_find_all(".//PubmedArticle") |>
    as.character()
  
  return(xml_doc)
}
