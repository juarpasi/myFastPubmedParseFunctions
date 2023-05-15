#' Extract the metadata from a PubMed record
#'
#' @description
#' A fast way of parsing metadata from a PubMed record.
#' 
#' The record has to be as a xml doc. Thus you need the `xml2` package.
#' 
#' @param doc A xml document
#' @param metadata.list chr vect. the metadata that one want to retrieve. Posibly:
#' * abstract
#' * meshDescrip
#' * meshQualifier
#' * keywordTerms
#' * pubType
#' * journal
#' * country
#' * language
#' * title
#' * year
#' * authors
#' @return A list. Each element is a record, each record contains a list with the metadata
#'
#' @examples
#' # Chop ----------------------------------------------------------------------
#' #You could use a for each for multiples pubmeds records
#' cl <- makeCluster(detectCores() - 1)
#' registerDoParallel(cl)
#' 
#' #
#' metadata <- foreach(file = files, .packages = c("xml2")) %dopar% {
#'  #library(xml2)
#'  doc <- xml2::read_xml(file)
#'  r <- getMetadata(doc,
#'                   metadata.list = c('abstract', 'title','meshDescrip',
#'                                     'meshQualifier','keywordTerms','pubType',
#'                                     'journal','year'))
#'  return(r)
#' }
#' # stop the cluster
#' stopCluster(cl)
#' 
#' # Unchop --------------------------------------------------------------------
#'
#' @export
#'

getMetadata <- function(doc, metadata.list = NULL) {
  
  # get pmid
  id <- doc |> xml_find_first('.//PMID') |> xml2::xml_text()
  
  metadataFunctions <-
    list(
      metadataNames = c('abstract','meshDescrip','meshQualifier',
                        'keywordTerms','pubType','journal','country',
                        'language','title','year','authors'),
      
      functions = c('nodeList2Df','nodeList2Df','nodeList2Df',
                    'nodeList2Df','nodeList2Df','makeDfFromXmlTxt','makeDfFromXmlTxt',
                    'makeDfFromXmlTxt','makeDfFromXmlTxt','makeDfFromXmlTxt','getAuthors'),
      
      opts = 
        list(
          list('.//MedlineCitation//Article//Abstract//AbstractText'),
          list('.//MedlineCitation//MeshHeadingList//DescriptorName'),
          list('.//MedlineCitation//MeshHeadingList//QualifierName'),
          list('.//MedlineCitation//KeywordList//Keyword'),
          list('.//Article//PublicationTypeList//PublicationType'),
          list('.//MedlineCitation//Article//Title'),
          list('.//MedlineJournalInfo//Country'),
          list('.//Article //Language'),
          list('.//ArticleTitle'),
          list('.//Article//Journal//JournalIssue//PubDate//Year'),
          list('')
        )
    )
  
  if (!is.null(metadata.list)) {
    positions <- metadataFunctions$metadataNames %in% metadata.list
    metadataFunctions$metadataNames <- metadataFunctions$metadataNames[positions]
    metadataFunctions$functions <- metadataFunctions$functions[positions]
    metadataFunctions$opts <- metadataFunctions$opts[positions]
  }
  
  for (i in 1:length(metadataFunctions$metadataNames)) {
    #add the doc and the id to the options of the functions
    metadataFunctions$opts[[i]] <- c(list(doc),metadataFunctions$opts[[i]], list(id))
    #to do: add the attr when calling nodeList2Df
  }
  
  metadaRes <-
    Map(
      function(fun, options)
        #call the function
        do.call(fun,options, envir = globalenv()),
        #the funciton and the options
        metadataFunctions$functions, metadataFunctions$opts
      )
  
  names(metadaRes) <- metadataFunctions$metadataNames
  
  doc <- NULL

  metadaRes <- metadaRes #|>
  ##add a function that drop a NULL element from a list
  #dropNullElementOfList()
  
  return(metadaRes)
}