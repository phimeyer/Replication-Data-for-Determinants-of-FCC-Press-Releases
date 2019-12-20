require("plyr")
require("stringr")
require("stringi")
require("lubridate")
require("fuzzyjoin")
require("dplyr")

#### Step 1: Load the two data sets  

FCC_Press <- read.csv("in/data-input/FCC_Press.csv")
FCC_Data <- read.csv("in/data-input/FCC_PR_decisions.csv")


#### Step 2: Clean the press data variable names

FCC_Press$source <- NULL

#names(FCC_Press)[names(FCC_Press)=="docket_nb_press"] <- "docket_nb"
names(FCC_Press)[names(FCC_Press)=="date"] <- "news_date"
names(FCC_Press)[names(FCC_Press)=="document_id"] <- "news_id"
names(FCC_Press)[names(FCC_Press)=="Newspaper"] <- "source_news"
names(FCC_Press)[names(FCC_Press)=="sourcetype"] <- "news_type"
names(FCC_Press)[names(FCC_Press)=="date"] <- "news_date"
names(FCC_Press)[names(FCC_Press)=="Day"] <- "news_day"
names(FCC_Press)[names(FCC_Press)=="Month"] <- "news_month"
names(FCC_Press)[names(FCC_Press)=="Year"] <- "news_year"
names(FCC_Press)[names(FCC_Press)=="count"] <- "news_count"

#### Step 3: Create media outlet variables 

# create dummy for newspaper type

FCC_Press$regional <- ifelse(FCC_Press$news_type == "Regional", 1,0)
FCC_Press$national <- ifelse(FCC_Press$news_type == "National", 1,0)
FCC_Press$business <- ifelse(FCC_Press$news_type == "Business", 1,0)
FCC_Press$weekly <- ifelse(FCC_Press$news_type == "Weekly", 1,0)
FCC_Press$tabloid <- ifelse(FCC_Press$news_type == "Tabloid", 1,0)

# create a page variable
FCC_Press$page <-  str_extract(FCC_Press$Section, "[[:digit:]]{1,2}$")
FCC_Press$page <- as.numeric(FCC_Press$page)

# create front page variables

FCC_Press$front_page <- ifelse(FCC_Press$page == 1, 1,0)

# delet all without page mentioning

FCC_Press <- FCC_Press[complete.cases(FCC_Press$page), ]

#### Step 4: Checking and cleaning up the newspapers and newspapertypes variable 

# checking the newspaper and the newspaper types

r <- as.data.frame(table(FCC_Press$source_news))

b <- as.data.frame(table(FCC_Press$news_type))

# delet useless data sets
rm(b,r)

#### Step 5: Join the press articles by 10 days range to the court decisions 

# prior attempts to  have created three NAs

FCC_Data$date[FCC_Data$docket_nb == "2 BvC 7/18"] <- "20.12.2018"
FCC_Data$date[FCC_Data$docket_nb == "2 BvC 12/18"] <- "20.12.2018"
FCC_Data$date[FCC_Data$docket_nb == "2 BvL 4/11"] <- "11.12.2018"

FCC_Data$date <- dmy(FCC_Data$date)

# create a hypothetical end date 

FCC_Data$hyp_time_minus <- as.Date(FCC_Data$date) - 10

# transform the date variables 
FCC_Data <- transform(FCC_Data
                , date = as.POSIXct(date)
                , hyp_time_minus = as.POSIXct(hyp_time_minus)
)

FCC_Press <- transform(FCC_Press
                       , news_date = as.POSIXct(news_date)
)

# first create 2 new columns so start and end match press date
FCC_Data_p <- FCC_Data %>% mutate(Start_Time = as.POSIXct(hyp_time_minus),
                      End_Time =  as.POSIXct(date))

# use fuzzy join and join everything together and roll up.
result <- fuzzy_left_join(FCC_Data_p, FCC_Press, c(Start_Time = "news_date", End_Time = "news_date"),
                          list(`<=`,`>=`)) %>% 
  group_by(Start_Time, End_Time)

result$front_page[is.na(result$front_page)] <- 0
result$legalcitation[is.na(result$legalcitation)] <- 0

#### Step 6: Create a pre-ruling media attention variable 

r <- table(result$doc_id, result$front_page)
r <- as.data.frame(r)
s <- subset(r, r$Var2 == "1")
s <- subset(s, s$Freq > "0")

colnames(s)[1] <- "doc_id"
colnames(s)[2] <- "prior_attention"

s$doc_id <- as.character(s$doc_id)
s$prior_attention <- as.numeric(s$prior_attention)

# strange but the 1 get transfored to a 2
s$prior_attention <- s$prior_attention -1

# merge s in df
FCC_Data$prior_attention <- FCC_Data$doc_id %in% s$doc_id

FCC_Data$prior_attention[FCC_Data$prior_attention == "FALSE"] <- "0"
FCC_Data$prior_attention[FCC_Data$prior_attention == "TRUE"] <- "1"

FCC_Data$prior_attention <- as.numeric(FCC_Data$prior_attention)

table(FCC_Data$prior_attention)

#### Step 8: Create a variable which indicates that lower court are overturned 

s <- table(FCC_Data$doc_id, FCC_Data$bvl, FCC_Data$uncons)
s <- as.data.frame(s)

s <- subset(s, s$Var2 == "1")
s <- subset(s, s$Var3 == "1")
s <- subset(s, s$Freq > "0")

colnames(s)[1] <- "doc_id"

s$doc_id <- as.character(s$doc_id)

# merge s in df
FCC_Data$lower_co_uncons <- FCC_Data$doc_id %in% s$doc_id

FCC_Data$lower_co_uncons[FCC_Data$lower_co_uncons == "FALSE"] <- "0"
FCC_Data$lower_co_uncons[FCC_Data$lower_co_uncons == "TRUE"] <- "1"

FCC_Data$lower_co_uncons <- as.numeric(FCC_Data$lower_co_uncons)

FCC_Data$status_quo <- ifelse(FCC_Data$lower_co_uncons == 1, 0, FCC_Data$uncons)

write.csv(FCC_Data,file="FCC_Press_Releases_data.csv")


