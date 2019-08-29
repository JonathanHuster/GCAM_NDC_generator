#this document takes a xml and cleans it of '&quote'

clean_xml <- function(xml_path, output_path = xml_path){
  library(readr)
  library(dplyr)
  read_file(xml_path) %>%
    gsub("&quot;", "", .) %>%
    gsub('>\\"', ">", .) %>%
    gsub('"<', "<", .) %>%
    write_file(output_path)
  return(TRUE)

}

clean_xml_dir <- function(dir){
  for(file in list.files(dir)[grepl(".xml", list.files(dir))]){
    clean_xml(paste0(dir, file))
  }
}


clean_xml_dir("../output/")
