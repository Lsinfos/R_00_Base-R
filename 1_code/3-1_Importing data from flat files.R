# 1. IMPORT DATA FROM FLAT FILES WITH UTILS

# 1.1 read.csv ####
# Flat files are typically simple text files that display data as tables. The standard distribution of R provides functionality in built-in package "utils" to import flat files into R as a data frame.
# csv: flat file (comma separated values)
# Import the "states.csv" file with read.csv() function. 
df<- read.csv("states.csv", stringsAsFactors = TRUE)
# First argument: the imported file's path. 
# stringsAsFactors: chooses to import columns that contains strings as actual strings or factors. By default, stringsAsFactors = FALSE.
df # lists basic information on some US states that corresponds nicely to the csv file.
str(df) # first 2 columns are strings, not factors.
# Use dir() to list the files in the working directory:
dir()
# Import "swimming_pools.csv" which contains data on swimming pools in Brisbane, Australia:
pools <- read.csv("swimming_pools.csv")
str(pools)

# 1.2 read.delim ####
# Another common format of flat file data is the tab-delimited file, like "*.txt" file. Import the same "states" data but in txt format, with read.delim():
read.delim("states.txt")
# By default, read.delim sets the "sep" argument to "\t" (fields in a record are delimited by tabs) and the header argument to TRUE (the first row contains the field names). 
# Import "hotdogs.txt" which contains information on sodium and calorie levels in different hotdogs:
hotdogs <- read.delim("hotdogs.txt", header = FALSE) # variable names are not on the first line.
# Print out some summary statistics about all variables in the data frame:
summary(hotdogs)
# Specify the column types or column classes of the resulting data frame with colClasses argument:
hotdogs <- read.delim("hotdogs.txt", 
                      header = FALSE, 
                      col.names = c("type", "calories", "sodium"),
                      colClasses = c("factor", "NULL", "numeric"))
str(hotdogs) # If a column is set to "NULL" in the colClasses vector, this column will be skipped and will not be loaded into the data frame.

# 1.3 read.table ####
# read.table() allows you to read in any file in table format and create a data frame from it. E.g, the same states data with the values being separated by "/" instead of "," or tab. 
read.table("states2.txt",
           header = TRUE,
           sep = "/")
# "states2.txt": path to the imported file
# header: tells R the first row of the text file contains variable names. By default header = FALSE, which means the first row is always read as an observation.
# sep: specifies how fields in a record are separated. By default sep = " ".

# Import the "hotdogs.txt" again, this time with read.table() with an argument to name the columns:
hotdogs <- read.table("hotdogs.txt", 
           sep = "",
           col.names = c("type", "calories", "sodium"),
           stringsAsFactors = TRUE)
head(hotdogs)
# Next to calories and sodium, the hotdogs have one more variable: type. This is a categorical variable because it can be only one of three things: Beef, Meat, or Poultry. Select the hot dog with the least calories:
hotdogs[which.min(hotdogs$calories), ]
# Select the observation with the most sodium:
hotdogs[which.max(hotdogs$sodium), ]

# 1.4 Wrappers ####
# read.table() is the main function of the utils package. read.csv() and read.delim() are so called wrapper functions around read.table(). Behind the scenes, read.table() is called, but with different default arguments to match the specific formats.
read.csv("states.csv")
# is the same as:
read.table("states.csv", 
           header = TRUE, 
           sep = ",",
           stringsAsFactors = FALSE)
# So you don't have to specify manually these anymore. Wrappers are shorter and easier to read.
# Likewise read.delim() is the same as:
read.delim("states.txt",
           header = TRUE,
           sep = "\t")
# read.csv2() and read.delim2() exist to deal with regional differences in representing numbers. E.g, read.csv() doesn't always give the result we want, because the values are separated by a ";", not a ",".
read.csv("states_nay.csv")
# Try again with read.csv2():
read.csv2("states_nay.csv") 
# It works perfectly, because the default argument sep = ";".
# read.delim2() has a default argument to convert the European decimal system with "," into the US "."
read.delim("states_aye.txt")
read.delim2("states_aye.txt")

# 1.5 scan ####
# when reading in spreadsheets many things can go wrong. The file might have a multiline header, be missing cells, or it might use an unexpected encoding. Scan() helps you read-in each cell of a file.
scan("states.csv", sep = ",", what = "c")
