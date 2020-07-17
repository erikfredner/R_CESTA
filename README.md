# Intro to R for CESTA
A one-hour introduction to text mining in R for the summer research internship at [CESTA](https://cesta.stanford.edu).

The lesson results in a sentiment analysis of a small corpus, currently the last eight US State of the Union addresses.

## Setup
Participants need to install two pieces of free software:

1. [The R language and interpreter](https://mirrors.nics.utk.edu/cran/).
2. [RStudio](https://rstudio.com/products/rstudio/download/#download), an integrated developer environment for R.

The lesson also depends on several R packages such as [`tm`](https://cran.r-project.org/web/packages/tm/index.html), which we will install as we go.

### Testing your setup
Once you have installed both R and RStudio, open RStudio. If you want to test your installation, type the following at the `>` prompt:
`print('hello, world')`

If it works, you should see the following:
```R
> print('hello, world')
[1] "hello, world"
```

## Additional resources
Students who are interested in learning more about R may wish to check out some of these books:

### Data Analysis
- [Wickham and Grolemund, *R for Data Science*](https://r4ds.had.co.nz)
- [Long and Teetor, *R Cookbook, 2nd Edition*](https://searchworks.stanford.edu/view/13463372)

### Text Mining
- [Jockers, *Text Analysis with R for Students of Literature*](https://searchworks.stanford.edu/view/13575408)
- [Silge, *Text Mining with R: A Tidy Approach*](https://www.tidytextmining.com)
