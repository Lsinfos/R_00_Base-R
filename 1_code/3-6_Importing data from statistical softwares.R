# 6. IMPORT DATA FROM STATISTICAL SOFTWARES

# 6.1 Statistical software packages ####
# Next to R, there are also other commonly used statistical software packages. Each of them has their own file format. 
# SAS (.sas7bdat, sas7bcat): most widely used in Business Analytics, Biostatistics and Medical Sciences.
# STATA (.dta): typical tool for economists.
# SPSS (.sav, .por): often used in Social Sciences.
# No matter which package the data comes from, it can be imported to R, most commonly with haven or foreign package.

# 6.2 haven ####
library(haven)
# haven can deal with SAS, STATA and SPSS data files.
sales <- read_sas("sales.sas7bdat") # data on the age, gender, income, and purchase level (0 = low, 1 = high) of 36 individuals.
str(sales) # each variable has a label attribute from SAS.
sales # shows a normal data frame without labels.

# Import .dta file from STATA with read_dta():
sugar <- read_dta("trade.dta") # data on yearly import and export numbers of sugar, both in USD and in weight. 
str(sugar)
# One column will be imported as a labelled vector, an R equivalent for the common data structure in other statistical environments.  Convert the variable of the class labelled to a factor with as_factor() in haeven.
sugar$Date <- as_factor(sugar$Date)
# Convert the date values to Date objects:
sugar$Date <- as.Date(sugar$Date)
str(sugar)
# Make a simple plot to see the relation between Import and Weight_I:
plot(sugar$Import, sugar$Weight_I) # rather positively correlated.
 
# Import data files from SPSS with read_sav() for .sav files or read_por() for .por files:
traits <- read_sav("person.sav") #  data on four of the Big Five personality traits for 434 persons.
# traits contains several missing values. Check it with summary():
summary(traits)
# Print out a subset of those individuals that scored high on Extroversion and on Agreeableness, i.e. scoring higher than 40 on each of these two categories.
subset(traits, traits$Extroversion > 40 & traits$Agreeableness > 40)
# With SPSS data files, it can also happen that some of the variables you import have the labelled class. Coerce these variables to factors or other standard R classes:
work <- read_sav("employee.sav") # data on information on employees and their demographic and economic attributes.
# Display the summary of the GENDER column of work:
summary(work$GENDER) # doesn't give a lot of useful information.
# Convert the GENDER column in work to a factor, the class to denote categorical variables in R:
work$GENDER <- as_factor(work$GENDER)
# Display summary of work$GENDER again:
summary(work$GENDER)

# 6.3 foreign ####
# foreign package is written by the R core team, which can work with all kinds of foreign data formats. It's also possible to export data again to various formats. 
install.packages("foreign")
library(foreign)
# foreign cannot import single SAS data files, such as .sas7bdat files. Only SAS library in .xport format can be read. 
# foreign package offers a simple function to import and read STATA data: read.dta()
florida <- read.dta("florida.dta") # data on the US presidential elections in the 2000. 
tail(florida)
# Data can be very diverse, going from character vectors to categorical variables, dates and more. Import a dataset that contains socio-economic measures and access to education for different individuals:
edu_equal_1 <- read.dta("edequality.dta") # already sufficient to import a dataset.
str(edu_equal_1) # automatically creates factors from labelled STATA values.
# Set the default argument convert.factors to FALSE:
edu_equal_2 <- read.dta("edequality.dta", convert.factors = FALSE)
str(edu_equal_2) # factors are converted to integers, but the information is stored in the data frame's attributes.
# convert.underscore argument converts "_" in Stata variable names to "." in R names.
edu_equal_3 <- read.dta("edequality.dta", convert.underscore = TRUE)
str(edu_equal_3)
# How many people have an age higher than 40 and are literate?
nrow(subset(edu_equal_1, age > 40 & literate == "yes"))

# read.spss(): reads SPSS data files. Adding to.data.frame argument returns a data frame instead of a list. 
demo <- read.spss("international.sav", to.data.frame = TRUE) # socio-economic variables from different countries.
# Create boxplot of gdp variable:
boxplot(demo$gdp)
# Calculate the correlation between two vectors with cor():
cor(demo$gdp, demo$f_illit) # negative correlation, but rather weak.
# use.value.labels: converts labelled SPSS values to R factors.
head(demo)
demo_2 <- read.spss("international.sav", to.data.frame = TRUE, use.value.labels = FALSE)
head(demo_2) 
# There are many more other arguments. Foreign aims at a specific treatment of different types of data files. This does not benefit the consistency, but provides full control over how actually data files are imported.