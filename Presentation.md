IMDB Movies Exploration Application 
========================================================
author: Saleh Moradi        
date: 11 September 2018
autosize: true

Agenda
========================================================

This presentation aims to explain the features and the making of an IMDB Movies Exploration Application.  
The application can be accessed via: RSTUDIO or GITHUB!

- Dataset Preparation (Behind the scene codes)
- A Quick Look at the Source Dataset
- Application Features

Dataset Preparation (Happened Behind the Scene)
========================================================
Here, I have presented the codes that have resulted in the source dataset behind the application.
<small>

```r
library(readr)
library(rvest)
library(dplyr)
library(tidyr)
movies <- read_tsv("https://datasets.imdbws.com/title.basics.tsv.gz", col_names = TRUE, quote = "\"", na = "\\N")
titles.info <- read_tsv("https://datasets.imdbws.com/title.akas.tsv.gz", col_names = TRUE, quote = "\"", na = "\\N")
ratings <- read_tsv("https://datasets.imdbws.com/title.ratings.tsv.gz", col_names = TRUE, quote = "\"", na = "\\N")
languageCodes.webpage <- read_html("https://www.loc.gov/standards/iso639-2/php/code_list.php")
langCodes_table <- html_nodes(languageCodes.webpage,"table")[[2]]
langCodes <- as_tibble(html_table(langCodes_table))
langCodes <- langCodes %>%
    rename(abbrev = 'ISO 639-1 Code') %>%
    rename(language = `English name of Language`) %>%
    filter(abbrev != "") %>%
    select(-1,-4:-5)
```
</small>

A Quick Look at the Source Dataset
========================================================
<small>

```r
full_info <- movies %>%
    filter(startYear >= 1940) %>%
    filter(startYear <= 2018) %>%
    filter(titleType == "movie") %>%
    select(-endYear) %>%
    mutate(isAdult = recode(as.character(isAdult), "0" = "No" , "1" = "Yes")) %>%
    left_join(titles.info, by = c("tconst" = "titleId", "originalTitle" = "title")) %>%
    select(-13:-15) %>%
    left_join(langCodes, by = c("language" = "abbrev")) %>%
    select(-language) %>%
    left_join(ratings, by = c("tconst" = "tconst")) %>%
    filter(is.na(averageRating) != TRUE) %>%
    filter(! duplicated(originalTitle)) %>%
    select(-titleType, - types, -ordering, -tconst) %>%
    rename(Language = language.y)
head(full_info)
```

```
# A tibble: 6 x 10
  primaryTitle originalTitle isAdult startYear runtimeMinutes genres region
  <chr>        <chr>         <chr>       <int>          <int> <chr>  <chr> 
1 Dama de noc… Dama de noche No           1993            102 Drama… MX    
2 Escape from… Escape from … No           1942             60 Adven… US    
3 Arizona Ter… Arizona Terr… No           1950             56 Weste… US    
4 Lebbra bian… Lebbra bianca No           1951            100 Drama  <NA>  
5 Pesn o gero… Pesn o geroy… No           1983             50 Docum… SUHH  
6 Houkutuslin… Houkutuslintu No           1946             84 Drama  <NA>  
# ... with 3 more variables: Language <chr>, averageRating <dbl>,
#   numVotes <int>
```
</small>

Application Features
========================================================

The application user interface (ui) allows entry of language, genre, production year (ranges between 1940-2018), IMDB rating (ranges between 1-10), and the number of movies to be returned, as well as the possibility to search by the movie's title.

The server, then, reads the source dataset prepared (see previous slides) and stored in the working directory, filter the rows according to the user's requested criteria, sort it by IMDB Rating, Number of Voters and the Production Year, and shows the table.

Finally, the user will see the results in a table and will be given the option to download the presented table in csv format.
