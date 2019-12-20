
rm(list=ls(all=T))

library(questionr) #package for easy renaming variables
library(tibble) # package for easy reordnering variables
library(stringi)


#### Step 1: Load the data set 

df <- read.csv("in/data-input/FCC_Press_Releases_data.csv")

#### Step 2: rename the variables used for analysis

df <- rename.variable(df, "pr_dummy","pressrelease_publication")
df <- rename.variable(df, "sep_op", "dissenting_opinion")
df <- rename.variable(df, "oral","oral_hearing")
df <- rename.variable(df, "status_quo","statusquo_change")
df <- rename.variable(df, "lower_co_uncons","lower_court_overruling")
df <- rename.variable(df, "bvf","abstract_review")
df <- rename.variable(df, "bvl", "concrete_review")
df <- rename.variable(df, "bvr","constitutional_complaint")
df <- rename.variable(df, "bve","dispute_federalorgans")
df <- rename.variable(df, "bvg","dispute_federation_land")

df <- rename.variable(df, "second_senate_dummy","second_senate")
df <- rename.variable(df, "decision_type","judgment")

#### Step 3: rename meta data variables

df <- rename.variable(df, "doc_id","document_id")
df <- rename.variable(df, "date","decision_date")
df <- rename.variable(df, "pr_nr","pressrelease_number")
df <- rename.variable(df, "pr_date","pressrelease_date")
df <- rename.variable(df, "short_text","decision_shorttext")
df <- rename.variable(df, "docket_nb","docket_number")
df <- rename.variable(df, "year","decision_year")
df <- rename.variable(df, "count","decision_length")

#### Step 4: delet all variables not used for analysis

df$bvq <- NULL
df$bvc <- NULL
df$bvb <- NULL
df$bvk <- NULL
df$bvh <- NULL
df$bvm <- NULL
df$bvn <- NULL
df$pbvu <- NULL
df$bvp <- NULL
df$unsuc_dec <- NULL
df$Date <- NULL
df$unanimous <- NULL
df$chamber_decision <- NULL
df$uncons <- NULL
df$hyp_time_minus <- NULL 
df$X.1 <- NULL
df$X <- NULL

# rearrange data variable order

col_order <- c("document_id", "decision_year", "decision_date", "docket_number"
               , "decision_shorttext", "pressrelease_publication"
               , "pressrelease_date","pressrelease_number", "dissenting_opinion"
               , "oral_hearing", "statusquo_change","lower_court_overruling", "abstract_review"
               , "concrete_review", "constitutional_complaint"
               , "dispute_federalorgans", "dispute_federation_land"
               , "second_senate", "judgment", "decision_length", "prior_attention")

FCC_PressRelease_Data <- df[, col_order]


#### Step 5: Save the dataset 
 
write.csv(FCC_PressRelease_Data,file="finaldata_FCC_PR.csv")


