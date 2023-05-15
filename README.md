# A fast way of parsing PubMed Files

There are many r packages that can retrive PubMed records and parse those records into R objects.

One of the main disadvantages of these functions is the speed.

This repository has some function that can be used for parsing PubMed records.

This functions use the `xml2` package and the other dependencies.

## Usage
Copy the function that are in the `R` directory. And you can use them in your workflow.

## A simple example
Here, use the `easyPubMed::fetch_pubmed_data` to get one record:

```r
library(xml2)
library(easyPubMed)

query <- 'cancer[TI] AND "2020"[dp] AND "journal article"[pt] AND "free full text"[sb] AND adolescent[mh]'

search <- get_pubmed_ids(query)

oneRecordCancer2020 <- fetch_pubmed_data(search, retmax = 1) |>
  read_xml()|>
  xml_find_all(".//PubmedArticle")
```

This is not a `R` package (maybe later).
So, you'll need to add the functions in the `R` directory to your working directory.
```r
source('getMetadata.R')
source('getAuthors.R')
source('makeDfFromXmlTxt.R')
source('nodeList2Df.R')

recordMetadata <-
  getMetadata(oneRecordCancer2020,
              metadata.list = c('keywordTerms','journal'))
```

```r
recordMetadata$keywordTerms

#                    text MajorTopicYN       id
#1 computational phantoms            N 34584772
#2    dose reconstruction            N 34584772
#3           late effects	         N 34584772
#4     pediatric phantoms	         N 34584772
```

## More examples
There are two tutorials that can be found here:

* [Example: Parsing PubMed Records Using Custom Functions](https://rpubs.com/juarpasi/1041859 "tutorial for pasing a single PubMed record")
* [How to parse multiple PubMed records](https://rpubs.com/juarpasi/1041863 "tutorial for parsing multiple PubMed records")

In this tutorial you'll find the metadata that currently can be extract with the `getMetadata`.
This include: abstract, title, authors, year, MeSH terms, Keywords, and more.