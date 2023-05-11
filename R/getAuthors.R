#' Get authors data into a dataframe of a pubmed record
#'
#' @description
#' Find all authors data of one pubmed record
#' 
#' If the record has no author return NULL
#' 
#' @param doc A xml document
#' @param id NULL (by default). A id of the doc
#' @return A dataframe with the forename, lastName, Initial and affiliation.
#'
#' @export
#'

getAuthors <- function(doc, id = NULL) {
  
  authors <- doc |>
    xml_find_all(xpath = './/AuthorList//Author')
  doc <- NULL
  
  if (length(authors) == 0) {
    return(NULL)
  }
  
  df <- data.frame(LastName = character(), ForeName = character(),
                   Initials = character(), Affiliation = character())
  
  for (author in authors) {
    LastName <- author |>
      xml_find_first('.//LastName')|>
      xml2::xml_text()
    ForeName <- author |>
      xml_find_first('.//ForeName')|>
      xml2::xml_text()
    Initials <- author |>
      xml_find_first('.//Initials')|>
      xml2::xml_text()
    Affiliation <- author |>
      xml_find_first('.//Affiliation')|>
      xml2::xml_text()
    new_df <- data.frame(LastName, ForeName,Initials,Affiliation)
    df <- rbind(df, new_df)
  }
  
  df['PMID'] <- id
  authors <- NULL
  
  return(df)
}
