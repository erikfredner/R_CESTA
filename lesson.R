# Welcome to R and RStudio
# R is the programming language. And RStudio is our integrated developer environment (IDE).
# Pound symbols indicate comments on the code, which the computer does not interpret.

# Move your cursor to any line in this file and hit Command (ctrl on Windows) + Enter/Return to run it.

# Getting started:

# Math
1 + 1
1 - 1
1 * 2
1 / 2
# Parentheses resolve first (aka R follows the order of operations you may have learned as PEMDAS)
(1 + 1) * 2

# Strings
'This is a string.' #single quotes or double quotes are fine ('/")

# Variables
# You can store objects in variables using the <- symbol:
myVariable <- 'my string'
myVariable
# New data overwrites existing:
myVariable <- 3
myVariable
# You can use variables in calculations:
myVariable / 3

# Functions
# A function performs operations on the object(s) you pass it.
# Some functions are built-in:
abs(-100) # absolute value
round(99.9)
sum(1,2,3,4,5)

# You can apply some functions to strings:
toupper('i am yelling') # upper as in uppercase
tolower('I AM NOT YELLING')

# You can assign the results of functions to variables:
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
0:10
# Vectors can be arranged in any order
# e.g. R's concatenate function, c(), creates and manipulates vectors
c(5,0,19)
# You can do math on vectors
# Note that the operation is performed on each element, left to right
0:10 + 6
# The same is true for Boolean operations:
c(6,3,1) < 5
# Vectors have indexes, which are integers corresponding to positions in the vector
# N.B. R indexes begin with 1. Some other languages like Python index from 0.
myVector <- c('apple', 'banana', 'cantaloupe')
myVector
myVector[1]
myVector[2]
myVector[3]
myVector[2:3]

# Text Mining in R

# Let's work with a poem, Gwendolyn Brooks's "We Real Cool"
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

# Note how the line breaks are encoded: \n, which refers to a "newline" (hence the n)
cool

# Let's split this poem into a vector, where each element is one line of the poem.
# First, we'll use the \n character to split by line.
# To do that, we need to pass multiple arguments to the function strsplit()
# The first argument, x, is the object to be acted on.
# The second argument, split, is the character to split by.
# Finally, we wrap that in the function unlist() to get the lines into a single vector:
cool <- unlist(strsplit(x = cool, split = "\n"))
# We may want to get rid of empty lines, since we won't be counting any words there.
# First we have to identify our blank lines:
cool != ''
# We can then use the T/F vector above to filter them out:
cool <- cool[cool != '']
cool

# Text Cleaning
# We could do all this manually, but there are packages designed for this such as tm.
install.packages('tm')
library('tm') # this loads the package
# We're going to use the tm VCorpus object to create a Corpus out of the Brooks poem:
corp <- VCorpus(VectorSource(cool))

# Now that we have the corp object in the form tm expects, we can clean it up:
corp <- tm_map(corp, content_transformer(removePunctuation))
corp <- tm_map(corp, content_transformer(removeNumbers))
corp <- tm_map(corp, content_transformer(tolower))
corp <- tm_map(corp, content_transformer(removeWords), stopwords('en')) # English stopwords
corp <- tm_map(corp, content_transformer(stripWhitespace))

# What does our text look like after cleaning?
lapply(corp, as.character) #lapply applies the function as.character to our vector

# Note that by removing stopwords, the word "we" gets removed.
# Here is the list of default English stopwords; you can customize it if you wish:
stopwords('en')

# Create a document-term matrix
# In this example, each "document" is a line of the poem.
# In subsequent examples, each document will be a text: a novel, poem, transcript, etc.
dtm <- DocumentTermMatrix(corp)
inspect(dtm)

# Sentiment analysis with SentimentAnalysis
install.packages('SentimentAnalysis')
library('SentimentAnalysis')
# lines <- unlist(lapply(corp, as.character))
sentiment <- analyzeSentiment(corp)
sentiment
# This provides a lot of output, which we can simplify
# GI is for Harvard General Inquirer, which is probably most interesting for poetry
columns <- c('WordCount', 'SentimentGI', 'NegativityGI', 'PositivityGI')
cbind(lines, sentiment[columns])

# There are many ways of computing sentiment scores
# syuzhet includes other sentiment dictionaries
install.packages('syuzhet')
library('syuzhet')
lines <- unlist(lapply(corp, as.character))

# syuzhet includes several different methods, which we can compare below:
afinn <- lapply(lines, get_sentiment, method = 'afinn')
bing <- lapply(lines, get_sentiment, method = 'bing')
nrc <- lapply(lines, get_sentiment, method = 'nrc') # displays a warning
syu <- lapply(lines, get_sentiment, method = 'syuzhet') #package default

# Let's look at all of these side-by-side:
cbind(lines, afinn, bing, nrc, syu)

# Expanding to a larger corpus
# You can also point tm at a directory of folders to create a corpus:
path <- '/Users/e/code/R_CESTA/corpus' # this needs to be changed for your computer! (For Windows: after copying the path, change '\' to '/')
newCorp <- Corpus(DirSource(path))

# Let's clean it the same way we did before:
newCorp <- tm_map(newCorp, content_transformer(removePunctuation))
newCorp <- tm_map(newCorp, content_transformer(removeNumbers))
newCorp <- tm_map(newCorp, content_transformer(tolower))
newCorp <- tm_map(newCorp, content_transformer(removeWords), stopwords('en')) # English stopwords
newCorp <- tm_map(newCorp, content_transformer(stripWhitespace))

# We'll attach a little metadata this time:
meta(newCorp, 'filename') <- list.files(path)
meta(newCorp)
# We can add arbitrary amounts of metadata using this method
meta(newCorp, 'president') <- c(rep('Obama', 4), rep('Trump', 4))

# Let's get the Harvard General Inquirer categories for these:
sentiments <- analyzeSentiment(newCorp) # displays a warning about what tm is doing

data <- cbind(meta(newCorp), sentiments[columns]) # attach our metadata to our sentiments
data

# Let's aggregate HGI sentiment by president:

#overall
aggregate(x = data$SentimentGI,
          by = list(data$president),
          FUN = mean)

#negativity
aggregate(x = data$NegativityGI,
          by = list(data$president),
          FUN = mean)

#positivity
aggregate(x = data$PositivityGI,
          by = list(data$president),
          FUN = mean)

# Not what I would have expected! Do other sentiment dictionaries provide different results?

# Bonus tidbits about tm:

# What are the most frequent non-stopwords in our corpus?
dtm <- DocumentTermMatrix(newCorp)
inspect(dtm)

# Which words are frequent?
findFreqTerms(dtm, lowfreq = 100) #lowfreq sets the minimum number of times a term must appear

# Which words correlate with a given term?
findAssocs(dtm, 'job', corlimit = 0.9)

# In some cases, we might want to stem the corpus
# Stemming reduces words to their root form.
# For example, display, displayed, and displaying would all be stemmed to display.
install.packages('SnowballC')
library('SnowballC')
newCorp <- tm_map(newCorp, content_transformer(stemDocument))
