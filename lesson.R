# TODO: convert this into a bookdown document
# Welcome to R and RStudio
# R is the programming language. And RStudio is our integrated developer environment (IDE).
# Pound symbols indicate comments on the code, which the computer does not interpret.

# Move your cursor to any line in this file and hit Command  +  Enter/Return
# This also works for multi-line blocks.

# Getting started:

# Math
1 + 1
1 - 1
1 * 2
1 / 2
# Parentheses resolve first
(1 + 1) * 2

# Strings
'this is a string' #single quotes or double quotes are fine ('/")

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
round(-99.9)
sum(1,2,3,4,5)

# You can apply some functions to strings:
toupper('i am yelling') # upper as in uppercase
tolower('I AM NOT YELLING')

# You can assign the results of functions to variables:
yell <- toupper('i am yelling')
yell

# Booleans
# You can evaluate expressions as true or false:
2 < 3
2 == 3 # == tests equivalence
2 != 3 # != tests non-equivalence

# There are also special values for true and false:
TRUE
FALSE

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
myVector[1]
myVector[2]
myVector[3]

# Let's work with a poem:
son_18 <- "Shall I compare thee to a summer's day?
Thou art more lovely and more temperate:
Rough winds do shake the darling buds of May,
And summer's lease hath all too short a date:"
# Note how the line breaks are encoded: \n, which refers to a "newline" (hence the n)
son_18

# Let's split this poem into a vector, where each element is one line of the poem.
# First, we use the \n character to split by line.
# To do that, we need to pass multiple arguments to the function strsplit()
# The first argument, x, is the object to be acted on.
# The second, split, is the character to split by.
# Finally, we wrap that in the function unlist() to get the lines into a single vector:
lines <- unlist(strsplit(x = son_18, split = "\n"))
length(lines)
lines

# Text Cleaning
# put to lowercase for counting
lines.clean <- tolower(lines)
lines.clean[14]
# remove punctuation
# split lines into characters
lines.clean <- unlist(strsplit(lines.clean, ""))
lines.clean
lines.clean[1:5]
# find characters to remove
punct <- which(lines.clean %in% c('.', ',','?','!','&', ':', ';', '@','\"'))
punct
# to show the pieces of punctuation we will be removing:
lines.clean[punct]
# remove punctuation by requesting only those that are not in variable punct
lines.clean <- lines.clean[-punct]
lines.clean
# paste the text back together
lines.clean<-paste(lines.clean, collapse="")
# split text into words
words.clean<-unlist(strsplit(lines.clean, " "))
words.clean
sort(table(words.clean), decreasing = T)

# Scanning texts with R

# First we need to get a text
# This is Project Gutenberg's copy of Walden: http://www.gutenberg.org/files/205/205-0.txt
# Here's a programmatic way to get it to your desktop in the format we want:
# bash terminal only: curl http://www.gutenberg.org/files/205/205-0.txt >> ~/Desktop/walden.txt
# curl can be useful for batch downloading groups of files
# Depending on the type of file you're trying to pull text from (pdf, kindle, etc.)
# different techniques apply.

# Now we need to clean the Gutenberg text of errata.
# In this case, Gutenberg's headers, and other non-Walden texts.
# We can open the file in another tab of the RStudio editor.
# Front delete line: ctrl + k
# Select to end: cmd + shift + down arrow
# search for titles, select to bottom and delete. Be sure to save.

# Using R to interact with the filesystem
# Where am I?
getwd()
# "wd" is short for "working directory," i.e. the active folder
# Which files are there?
list.files()
# Not the one we need.
# How do I go somewhere else?
setwd('/Users/e/Desktop/')
# note that the path above will be different on your machine. My username is 'e'
list.files()
# we have to be in the same directory as the file in order to scan it by name, as shown below:
walden <- scan(file = 'walden.txt', what = 'character', encoding = 'utf8', sep = '\n')
# if not in the same directory but know where file is, the statement below is equivalent:
scan(file = '/Users/e/Desktop/walden.txt', what = 'character', encoding = 'utf8', sep = '\n')

# What do we have?
walden
typeof(walden)
length(walden)
# a character vector containing 8,642 items, which represent instances of newlines ('\n')
# we can count the words using the same methods on a smaller text
# add spaces before and after newlines to avoid word collapse
walden.clean <- tolower(walden)
# note that tolower strips whitespace, which we need to retain in this case
walden.clean <- paste(' ', walden.clean, ' ')
# split to characters to find rogue punctuation
walden.clean <- unlist(strsplit(x = walden.clean, split = ""))
# check
head(walden.clean)
tail(walden.clean)
punct <- which(walden.clean %in% c('.', ',','?','!','&', ':', ';', '@','\"', '-', '_', '\t'))
head(punct)
walden.clean <- walden.clean[-punct]
walden.clean <- paste(walden.clean, collapse = '')
# split to words
walden.clean <- unlist(strsplit(x = walden.clean, split = ' '))
# delete blanks
blanks <- which(walden.clean == '')
walden.clean <- walden.clean[-blanks]
# check
head(walden.clean)
tail(walden.clean)

# basic word counting
# total words in text
length(walden.clean)
# vocabulary size
length(unique(walden.clean))
# type-token ratio for text
length(unique(walden.clean))/length(walden.clean)
table(walden.clean)
sort(table(walden.clean), decreasing = T)[1:50]

# finding locations of keywords
which(walden.clean %in% 'pond')
# which gives us the accurate but useless:
walden.clean[which(walden.clean %in% 'pond')]


# finding keywords with their contexts
# set directory
setwd('~/Desktop/')
# text cleaning
t <- scan('walden.txt', what = 'character', sep = '\n', encoding = 'UTF-8')
t <- paste(t, collapse = ' ')
t <- tolower(t)
t <- unlist(strsplit(t, split = ''))
# get rid of everything not a-z or space
# note that 'letters' is a default variable containing a-z lowercase
keepers <- which(t %in% c(letters, ' '))
t <- t[keepers]
t <- paste(t, collapse = '')
t <- unlist(strsplit(t, split = ' '))
blanks <- which(t == '')
t <- t[-blanks]
head(sort(table(t), decreasing = T))
tail(sort(table(t), decreasing = T))

# to start, let's figure out how to get one example of what we want
# once we have that, we can figure out how to do it programmatically

# locations of words ('kw' stands for 'keyword'; 'hz' horizon)
kw <- which(t %in% 'her')
# now, what we want is the words around each of our keywords
# let's start with just the first one
kw[length(kw)]
t[kw[length(kw)]]
start <- kw[length(kw)] - 10
end <- kw[length(kw)] + 10
paste(t[start:end], collapse = ' ')

# how would we apply this to the entire vector? first, create start and endpoint vectors:
start <- kw - 10
end <- kw + 10

# now we need to match start/end points against text
# since we're moving stepwise through a vector, we need an apply statement
# there are many types of apply statements
# the one we'll be using is called 'sapply,' which can be read as 'simplified apply'

# example sapply statement
# figure out the FUN argument
sapply(X = 1:10, FUN = function(x) print(x))
# why is this different from:
1:10

# print the letters of the alphabet one at a time in order
sapply(X = seq(1:length(letters)), FUN = function(x) print(letters[x]))
# again, different from in that it produces 26 vectors containing individual letters
print(letters)

# apply statements are useful for bringing multiple pieces of information together
# print letters in order along with their number in the alphabet
sapply(X = seq(1:length(letters)), FUN = function(x) print(c(letters[x], 'which is letter number', x)))

# finding our contexts
# we can use an apply to make this since we need to walk stepwise through a vector
cx <- sapply(X = seq(1:length(start)), FUN = function(x) t[start[x]:end[x]])
# what did we make?
typeof(cx)
dim(cx)
# we need to collapse each column (which is one observation of the keyword) into a character vector
cx <- sapply(X = seq(1:ncol(cx)), FUN = function(x) paste(cx[,x], collapse = ' '))

# we could use the original format to figure out
# which entries contain two shared keywords within the horizon
cx <- sapply(X = seq(1:length(start)), FUN = function(x) t[start[x]:end[x]])
cx
waldens <- which(cx %in% 'walden')
# we're working with a two-dimensional array, so we need the positions of our waldens
waldens <- arrayInd(waldens, dim(cx))
# this represents the column numbers containing both 'walden' and 'pond'
waldens[,2]
# to extract just these
waldenponds <- cx[ , waldens[,2]]
# collapse to legible strings
waldenponds <- sapply(X = seq(1:ncol(waldenponds)), FUN = function(x) paste(waldenponds[,x], collapse = ' '))

# saving
write.csv(waldenponds)

# using functions to repeat tasks with different arguments
# goal: write a function that performs the above steps for any pair of words, with custom params

# first we're going to write a function that will clean texts for us
# you can name the variable in a `function()` call whatever you like.
# whatever you pass it when you call the function will replace
# the variable name within the function when executed
# the `path` variable refers to a filepath, e.g. ~/Desktop/walden.txt

# first we need a function to get a text from somewhere:
# (note that this is similar to the sapply syntax sapply(X = ..., FUN = function(x)...)
get_text <- function(path) {
  print('scanning utf8 .txt file by newlines')
  t <- scan(path, what = 'character', sep = '\n', encoding = 'UTF-8')
  return(t)
}

# before using it, we have to "source" the function.
# we can do that from the editor
# move the cursor to the top line of the block (here, 519) and hit command+enter
# get_text will appear in your environment as a function

# let's test it:
get_text('~/Desktop/walden.txt')
# running the function prints to standard out (the console window):
# so we need to save results to variables:
walden <- get_text('~/Desktop/walden.txt')
head(walden)
# we can save whatever we `return()` to a variable
# at the end of the function we `return(t)`, which we assign to the variable `walden`

# now we need a separate function to tokenize the text
# why separate?
# because we are also going to need to tokenize strings from other sources, not just files
# example: we want to look for 'riotous vines'. we need to tokenize that string to search for it.

# this is the same process as earlier
tokenize <- function(x) {
  t <- paste(x, collapse = ' ')
  t <- tolower(t)
  t <- unlist(strsplit(t, split = ''))
  keepers <- which(t %in% c(letters, ' '))
  t <- t[keepers]
  t <- paste(t, collapse = '')
  t <- unlist(strsplit(t, split = ' '))
  blanks <- which(t == '')
  t <- t[-blanks]
  return(t)
}

# test with text we just got from get_text:
tokenize(walden)
# test with another use case:
tokenize('This should work, right?')
# ???
# we can figure out what went wrong by checking our values line-by-line and printing them

tokenize <- function(x) {
  t <- paste(x, collapse = ' ')
  t <- tolower(t)
  t <- unlist(strsplit(t, split = ''))
  print(head(t))
  keepers <- which(t %in% c(letters, ' '))
  print(head(keepers))
  t <- t[keepers]
  t <- paste(t, collapse = '')
  t <- unlist(strsplit(t, split = ' '))
  print(head(t))
  blanks <- which(t == '')
  print(blanks)
  t <- t[-blanks]
  print('final value of t is:')
  return(t)
}

x <- 'Why doesn\'t this work?'
tokenize(x)

# looking at the results, we realize we have a problem with `blanks`:
# when there are no blanks, as in `x`, the variable blanks zeroes out our text
# (programmatically, we are asking for none of the elements in t)
# we could get rid of the `blanks` fix
# but we also want to deal with blanks when (and only when) they are present
# so we're going to need a conditional to check for edge cases

# basic conditional flow
if (1 < 2) { letters }
# note what it does if we give it a false condition
if (1 > 2) { letters }
# doing nothing can be the correct option
# but frequently you want to do one thing if true, another thing if false:
if (1 > 2) { letters } else { rev(letters) }
# for clarity, conditionals are usually broken up across multiple lines
# below is equal to the line above:
if (1 > 2) {
  letters
} else {
  rev(letters)
}

# you can also have multiple conditions
if (1 == 2) {
  print('conditional one is true')
} else if (2 == 1) {
  print('conditional two is true')
} else {
  print('nothing is true')
}

# change around the booleans to see each result

# note that there are ways to combine boolean operators with conditional flows
# grammatically we might think of this nesting as something like "if this AND that, THEN..."
if (1 < 2) {
  if (2 == 1){
    print('both work')
  } else {
    print('second statement false')
  }
}

# of course we can do this with booleans that are not numbers:

'pond' %in% c('walden', 'pond')

if ('pond' %in% c('walden','pond')) {
  print('pond present')
} else {
  print('pond not present')
}

if ('pond' %in% c('wide', 'wide', 'world')) {
  print('pond present')
} else {
  print('pond not present')
}

# so, let's see why we would need a conditional in a function

tokenize <- function(x) {
  t <- paste(x, collapse = ' ')
  t <- tolower(t)
  t <- unlist(strsplit(t, split = ''))
  keepers <- which(t %in% c(letters, ' '))
  t <- t[keepers]
  t <- paste(t, collapse = '')
  t <- unlist(strsplit(t, split = ' '))
  blanks <- which(t == '')
  if (length(blanks) != 0) {
    t <- t[-blanks]
  }
  return(t)
}

tokenize(x)


# the great thing about functions is that they can be used to repeat processes
# so we're going to get a new text to tokenize
# below is the R equivalent of curl:
# the url points to "The Wide Wide World"
download.file(url = 'https://www.gutenberg.org/files/28376/28376-0.txt',
              destfile = '~/Desktop/wide.txt')

# let's make sure the download worked:
setwd('~/Desktop/')
# two options:
'wide.txt' %in% list.files()
# %in% is a shorthand for a `match()` function like so:
match(x = 'wide.txt', table = list.files())
list.files()[match(x = 'wide.txt', table = list.files())]

# tokenize our new text
wide <- get_text('~/Desktop/wide.txt')
wide <- tokenize(wide)
head(wide)

# obviously we have some gutenberg stuff in wide world. how would we clean it in R?
# find unique start and endpoint strings. this is going to be useful for n-gram match later
# let's look at the file:
file.edit('~/Desktop/wide.txt')
# let's say the start of section we want is: "Chapter I"
# ending unique words: "eyes the end" (remember these are tokenized)
# a fast way of doing this is checking one word at a time for possible valid matches
first_word <- which(wide == 'chapter')
second_word <- which(wide[first_word + 1] == 'i')
book_start <- first_word[second_word]
# check:
wide[(book_start-5):(book_start + 5)]
# how to delete everything prior?
wide <- wide[book_start:length(wide)]
# check
head(wide)
# now we need to do the same for ending points
first_word <- which(wide == 'eyes')
length(first_word)
second_word <- which(wide[first_word + 1] == 'the')
length(second_word)
# because second_word is greater than 1, we need to go to the third word for a unique match
possibilities <- first_word[second_word]
third_word <- which(wide[possibilities + 2] == 'end')
# once length of validation == 1, we know we have an exact match
length(third_word)
# so then we need to get the absolute position of that in the text to finish cleaning it:
ending <- (possibilities[third_word] + 2)
tail(wide[1:ending])
# and finally reassign to save:
wide <- wide[1:ending]
# optional, to save to computer:
setwd(dir = '~/Desktop/')
write.csv(x = wide, file = 'wide_tokens.csv')

# basic comparisons between these texts
# type-token ratio
get_ttr <- function(t) {
  t_types <- length(unique(t))
  t_tokens <- length(t)
  t_ttr <- t_types / t_tokens
  print(paste(c('type-token ratio for', deparse(substitute(t)), 'is:', t_ttr), collapse = ' '))
  return(t_ttr)
}

wide_ttr <- get_ttr(wide)
walden_ttr <- get_ttr(walden)
walden_ttr > wide_ttr
# a higher ttr implies a more diverse vocabulary; lower implies more repetition
# this suggests the importance of length on this measure: wide is much longer than walden
# longer text provides more opportunities for repetition

# absolute word frequency
get_freqs <- function(t) {
  t_freqs <- sort(table(t), decreasing = TRUE)
  print(paste(c('top terms of', deparse(substitute(t))), collapse = ' '))
  print(head(t_freqs))
  return(t_freqs)
}

wide_freqs <- get_freqs(wide)
walden_freqs <- get_freqs(walden)
# note that these are not accurately comparable because of differences in length
# so we need measures of word frequency that account for text length

get_scaled_freqs <- function(t) {
  t_freqs <- sort(table(t), decreasing = TRUE)
  t_words <- length(t)
  t_scaled_freqs <- t_freqs / t_words
  print(paste(c('top scaled terms of', deparse(substitute(t))), collapse = ' '))
  print(head(t_scaled_freqs))
  return(t_scaled_freqs)
}

wide_scaled <- get_scaled_freqs(wide)
walden_scaled <- get_scaled_freqs(walden)
# so we can see that, proportionally, Thoreau uses *way* more "the"s than Warner
# this is generally considered the most reliable way to handle disparities in length

# if it's easier to think about these as percentages just multiply the vector by 100
head(wide_scaled * 100)
# can read the result as, for instance, ~3.9% of the words in "wide" are "the"

############
# ngram matcher
# search for instances of 'riotous' within n words of 'vines' within a corpus
# add positive matches to a table with filename and match string
############

# function that gets all instances of a 1-gram within a corpus within a fixed range
# appends them all to a matrix with filenames attached
# *then* look for the second term within proximity

# we need to be able to do everything in one move:
# get a text, tokenize it, scan it for keywords, isolate instances
# and we need to be able to repeat this for a large number of files

get_text <- function(path) {
  print('scanning utf8 .txt file by newlines')
  t <- scan(path, what = 'character', sep = '\n', encoding = 'UTF-8')
  return(t)
}

tokenize <- function(x) {
  t <- paste(x, collapse = ' ')
  t <- tolower(t)
  t <- unlist(strsplit(t, split = ''))
  keepers <- which(t %in% c(letters, ' '))
  t <- t[keepers]
  t <- paste(t, collapse = '')
  t <- unlist(strsplit(t, split = ' '))
  blanks <- which(t == '')
  if (length(blanks) != 0) {
    t <- t[-blanks]
  }
  return(t)
}

# unlike our previous functions, this one takes three arguments:
# `text`, `word`, `hz` (horizon)
# hz is an integer representing the number of words we want on either side of our keyword
# we're going to start with a function that gets the contexts for the first word of the ngram

get_onegram <- function(text, word, hz) {
  # no point in checking unless word is in the text
  if (word %in% text) {
    anchors <- which(text %in% word)
    starts <- anchors - hz
    ends <- anchors + hz
    cx <- sapply(X = seq(1:length(starts)), FUN = function(x) text[starts[x]:ends[x]])
    print(paste(c(ncol(cx), 'instance(s)', 'of', word), collapse = ' '))
    return(cx)
  } else {
    # would be nice to add filename for 'no instances' cases
    print(paste(c('no instance(s) of', word), collapse = ' '))
  }
}

# `ngram_matcher` requires variable `cx` in form returned by `get_onegram`
ngram_matcher <- function(cx, word) {
  locs <- which(cx %in% word)
  # convert match vector to positions to retrieve all rows and select columns:
  locs <- arrayInd(ind = locs, .dim = dim(cx))
  # unique call below is necessary. if you have a word that appears multiple times
  # in the selection, you get multiple columns repeated:
  cx <- cx[ , unique(locs[,2])]
  print(paste(c(ncol(cx), 'instance(s)', 'of', word), collapse = ' '))
  return(cx)
}

# now, we can call sourced functions inside of other functions, like so:

find_ngram <- function(text, ngram, hz) {
  text <- get_text(text)
  text <- tokenize(text)
  ngram <- tokenize(ngram)
  cx <- get_onegram(text = text, word = ngram[1], hz = hz)
  # if it's only one word, we can stop here
  # otherwise:
  if (length(ngram) > 1) {
    for (x in 2:length(ngram)) {
      cx <- ngram_matcher(cx = cx, word = ngram[x])
    }
  }
  # collapse results into more readable strings
  if (length(cx) > 0) {
    cx <- sapply(X = seq(1:ncol(cx)), FUN = function(x) paste(cx[,x], collapse = ' '))
  }
  return(cx)
}

# now we need a way to run this on a big batch of files:
# `dir` refers to the directory where the file of texts is located
# note that the value for `dir` should be typed without the final /
corpus_ngrams <- function(dir, ngram, hz) {
  files <- list.files(path = dir, pattern = '.txt', full.names = T)
  quotes_out <- character()
  names_out <- character()
  for (x in 1:length(files)) {
    result <- find_ngram(text = files[x], ngram = ngram, hz = hz)
    # this gets us just the filename
    fn <- unlist(strsplit(list.files(dir, pattern = '.txt')[x], split = '.txt'))
    # produce a vector of filenames equal to the length of result
    names <- rep(fn, length(result))
    names_out <- append(x = names_out, values = names)
    quotes_out <- append(x = quotes_out, values = result)
  }
  # result of find_ngram is a vector of matches
  output <- cbind(names_out, quotes_out)
  return(output)
}

# update variable `cx` to only retain matched columns
# repeat with next term against existing `cx` for third...nth term




###############


# we can expand this formulation

kwic <- function(text, kword, hz){
  textScanned <- scan(text, what = 'character', sep = '\n', encoding = 'UTF-8')
  textScanned <- paste(textScanned, collapse = ' ')
  textScanned <- tolower(textScanned)
  
  textTokenized <- unlist(strsplit(textScanned, split = ' '))
  if(kword %in% textTokenized){
    textIndex <- which(textTokenized == kword)
    print(length(textIndex))
    if(textIndex[1] < hz){
      textIndex[1] = hz
    }
    if(textIndex[length(textIndex)] + hz > length(textTokenized)){
      textIndex[length(textIndex)] = length(textTokenized) - hz
    }
    indexStart <- textIndex - hz
    indexEnd <- textIndex + hz
    stringList <- mapply(function(x,y) pullString(x,y,textTokenized = textTokenized), indexStart, indexEnd)
    stringList <- unlist(stringList)
    return(stringList)
  }
}

pullString <- function(indexStart, indexEnd, textTokenized){
  newString <- textTokenized[indexStart:indexEnd]
  newString <- paste(newString, collapse = ' ')
  return(newString)
}

# notifies you if one of the text files is very small:
if (length(text) < 1000) {
  print(paste(c(deparse(substitute(text))), 'is short'), collapse = ' ')
}