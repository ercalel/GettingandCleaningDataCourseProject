# Descarga de los archivos

setwd("Data/")

file_name <- "getdata_projectfiles_UCI HAR Dataset.zip"
if(!file.exists(file_name)) {
  url_file <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url = url_file, 
                destfile = file_name, 
                method = "curl")
} else {
  print("El archivo ya existe...")
}

if(file.exists(file_name)) {
  unzip(zipfile = file_name)
} else {
  print("El archivo no existe...")
}

setwd("UCI HAR Dataset")

