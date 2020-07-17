# Welcome to R and RStudio
# R is the programming language. And RStudio is our integrated developer environment (IDE).
# Pound symbols indicate comments on the code, which the computer does not interpret.

# You can pass any line in this file directly to the console below:
# Command (Mac) or Ctrl (Windows/Linux) + Enter/Return to run it.

# Getting started:

# Math
1 + 1
1 - 1
1 * 2
1 / 2
# Parentheses resolve first 
#(R follows the order of operations you may have learned as PEMDAS)
(1 + 1) * 2

# Strings
'This is a string.' #single quotes or double quotes are equivalent ('/")

# Variables
# You can store objects in variables using the <- symbol:
myVariable <- 'my string'
myVariable

# NB: in the "Environment" panel in RStudio, you can see your variables and content ->

# New data overwrites existing:
myVariable <- 3
# You can use variables in calculations:
myVariable / 3

# Functions
# A function performs operations on the object(s) you pass it.
# Some functions are built-in:
abs(-100) # absolute value
# Arguments to functions have variable names:
abs(x = -100) # equivalent to above
round(99.9)
sum(1,2,3,4,5)

# Built-in functions have documentation explaining what they do.
# Type a function's name in the editor, hit tab, and you will see the arguments it can take:
round()
# To view the documentation for a function, hit F1
# You can also select Help in the bottom-right panel, and search the function name.

# You can apply some functions to strings:
toupper('i am yelling') # upper as in uppercase
tolower('I AM NOT YELLING')

# Functions can take multiple arguments, e.g.:
strsplit(x = 'I AM NOT YELLING', split = ' ') # splits string by the space character
# Note that strsplit() outputs a list, denoted with [[1]]

# You can assign the *results* of functions to variables:
yell <- toupper('i am yelling')
yell

# Booleans
# You can evaluate expressions as true or false:
2 < 3 # x less than y
2 == 3 # == tests equivalence
2 != 3 # != tests non-equivalence

# There are also reserved words for true and false:
TRUE == T
FALSE == F

# Vectors
# Vectors are one-dimensional groupings of objects
# : creates a vector of integers from x to y by 1
0:10
# Vectors can be arranged in any order
# R's concatenate function, c(), creates and manipulates vectors
c(5,0,19)

# You can do math on vectors
# Note that the operation is performed on each element, left to right
0:10 + 6
# The same is true for Boolean operations:
c(6,3,1) < 5

# Indices
# Vectors have indexes, which are integers corresponding to positions in the vector
# N.B. R indexes begin with 1. Some other languages like Python index from 0.
myVector <- c('apple', 'banana', 'cantaloupe')
myVector[1]
myVector[2]
myVector[3]

# Subsetting Vectors
# You can extract a subset of any vector using [] notation
2:3
myVector[2:3]

# Subsets needn't be sequential:
c(1,3)
myVector[c(1,3)]

# Text Mining!

# Let's start with a poem, Gwendolyn Brooks's "We Real Cool"
# Text source: https://poets.org/poem/we-real-cool
cool <- "                   THE POOL PLAYERS.
                   SEVEN AT THE GOLDEN SHOVEL.

We real cool. We
Left school. We

Lurk late. We
Strike straight. We

Sing sin. We
Thin gin. We

Jazz June. We
Die soon."

cool

# Note how the line breaks are encoded: \n, which is a "newline"
# \ is an escape character

# Let's split this poem into a vector, where each element is one line of the poem.
# We wrap strsplit() in unlist() to get the lines into a vector:
cool <- unlist(strsplit(x = cool, split = "\n"))
cool

# We may want to get rid of empty lines, since we won't be counting any words there.
# First we have to identify our blank lines:
cool != ''
subsetter <- cool != ''
# We can then use the T/F vector above to filter them out:
cool <- cool[subsetter]
cool

# Let's do sentiment analysis with the SentimentAnalysis package:
install.packages('SentimentAnalysis')
library('SentimentAnalysis')
# NB. if it asks to compile packages, you can choose No.
# You can also manage your packages in RStudio's Packages tab in the bottom-right ->

sentiment <- analyzeSentiment(cool)

# SentimentAnalysis computes many different sentiment scores:
sentiment
# We can simplify this output for our purposes.
# GI is for Harvard General Inquirer, which we'll use here
# More info about HGI: http://www.wjh.harvard.edu/~inquirer/homecat.htm
hgiCols <- c('WordCount', 'SentimentGI', 'NegativityGI', 'PositivityGI')
cbind(cool, sentiment[hgiCols]) #cbind() is "column bind"

# Expanding to a larger corpus
# There are packages designed for this, such as tm (short for text mining)
install.packages('tm') # this also installs dependencies
library('tm') # this loads the package into our current environment

# You can point tm at a directory of folders to create a corpus.
# The path below may need to be changed for your computer!
path <- '/Users/e/code/R_CESTA/corpus'
# Windows paths use forward slashes (\) instead of backslashes (/):
# path <- 'C:\\Users\\Nichole\\Documents\\GitHub\\R_CESTA\\corpus'
newCorp <- Corpus(DirSource(path))

# Let's clean it up using standard tm tools:
newCorp <- tm_map(newCorp, content_transformer(removePunctuation))
newCorp <- tm_map(newCorp, content_transformer(removeNumbers))
newCorp <- tm_map(newCorp, content_transformer(tolower))
newCorp <- tm_map(newCorp, content_transformer(removeWords), stopwords('en'))
newCorp <- tm_map(newCorp, content_transformer(stripWhitespace))

# Here is the vector of default English stopwords:
stopwords('en')

# We'll attach metadata to our Corpus object using the meta() function:
meta(newCorp, 'filename') <- list.files(path)
# We can add any amount of metadata using this method:
rep('a rose is a rose is', 10)
meta(newCorp, 'president') <- c(rep('Obama', 4), rep('Trump', 4))

# Let's get the Harvard General Inquirer categories for these:
sentiments <- analyzeSentiment(newCorp) # displays warnings about what tm is doing

data <- cbind(meta(newCorp), sentiments[hgiCols]) # attach our metadata to our sentiments
data

# How do you interpret these results?
# What claims might you make based on this data?
# Do these results conform to your expectations?
# What directions for future research/testing do these results suggest?

###################
# Bonus tidbits!

# Let's aggregate HGI sentiment by president:

aggregate(x = data[,3:length(data)], # all rows, columns 3 through the number of columns in data
          by = list(data$president),
          FUN = mean)

# Documentation for aggregate (or any function):
?aggregate()
?Corpus()

# What are the word-counts in our corpus?
dtm <- DocumentTermMatrix(newCorp)
inspect(dtm)

# Which words are most frequent across the whole corpus?
findFreqTerms(dtm, lowfreq = 100) #lowfreq sets the minimum number of times a term must appear

# Which words are most frequent within each document?
findMostFreqTerms(dtm)

# Which words correlate with a given term?
findAssocs(dtm, 'job', corlimit = 0.8)

# syuzhet is another R package for sentiment analysis.
install.packages('syuzhet')
library('syuzhet')

# syuzhet includes several different methods, which we can compare below:
afinn <- lapply(cool, get_sentiment, method = 'afinn')
bing <- lapply(cool, get_sentiment, method = 'bing')
nrc <- lapply(cool, get_sentiment, method = 'nrc') # displays a warning
syu <- lapply(cool, get_sentiment, method = 'syuzhet') #package default

# Let's look at all of these side-by-side:
cbind(cool, afinn, bing, nrc, syu)

# For some questions, we might want to stem the corpus
# Stemming reduces words to their root form.
# For example, display, displayed, and displaying would all be stemmed to display.
install.packages('SnowballC')
library('SnowballC')
newCorp <- tm_map(newCorp, content_transformer(stemDocument))

# Suppose you want to import or export a csv into R:
data
# export:
write.csv(data, file = '~/Downloads/my_data.csv')

# and you can import an existing file like so:
importedData <- read.csv(file = '~/Downloads/my_data.csv')

# tm has two different Corpus types:
# VCorpus, for character vectors (e.g. the Brooks poem)
# Corpus, for texts read in from files (e.g. the State of the Union addresses)
corp <- VCorpus(VectorSource(cool))