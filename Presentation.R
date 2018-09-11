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

# Preparing the "full information" dataset
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
write_csv(full_info, "~/Desktop/R/Data Science Specialization/Course 9/final_project/App/movies.csv")


#Preparing the input vectors 
split_genres = data.frame(do.call("rbind", strsplit(full_info$genres, ",")))
genres <- sort(unique(unique(split_genres$X1),
                      unique(split_genres$X2),
                      unique(split_genres$X3)))
titles <- unique(full_info$titleType)
languages <- sort(unique(full_info$Language))
