# Get data sets

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

# Read train data
x_train <- read.table(file = "train/x_train.txt")
y_train <- read.table(file = "train/y_train.txt")
subject_train <- read.table(file = "train/subject_train.txt")

# Read test data
x_test <- read.table(file = "test/x_test.txt")
y_test <- read.table(file = "test/y_test.txt")
subject_test <- read.table(file = "test/subject_test.txt")

# Read features and activity information
feature <- read.table(file = "features.txt")
activity_labels <- read.table(file = "activity_labels.txt")
colnames(activity_labels) <- c("id", "name")

################################################################################

# 1. Merges the training and the test sets to create one data set.
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

# 2. Extracts only the measurements on the mean and standard deviation 
#    for each measurement. 
selected_cols <- grep("-(mean|std).*", feature[, 2])
selected_cols_names <- feature[selected_cols, 2]
selected_cols_names <- gsub("-mean", "Mean", selected_cols_names)
selected_cols_names <- gsub("-std", "Std", selected_cols_names)
selected_cols_names <- gsub("[-()]", "", selected_cols_names)

# 3. Uses descriptive activity names to name the activities in the data set
x_data <- x_data[,selected_cols]
data <- cbind(subject_data, y_data, x_data)
colnames(data) <- c("Subject", "Activity", selected_cols_names)

# 4. Appropriately labels the data set with descriptive variable names. 
data$Subject <- as.factor(data$Subject)
data$Activity <- factor(data$Activity, 
                        levels = activity_labels$id, 
                        labels = activity_labels$name)

# 5. From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.
library(dplyr)
data <- gather(data, key = "Variable", value = "Valor", -c("Subject", "Activity"))

data <- data %>% group_by(Subject, Activity, Variable) %>% 
  summarise(media = mean(Valor)) %>%
  spread(Variable, media)

setwd("../../Outputs")
write.table(x = data, file = "result.txt", sep = ",")
