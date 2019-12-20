# Press releases by the German Federal Constitutional Court (FCC)

This repository provides the files necessary to replicate the analysis for the paper *"Judicial public relations: Determinants of press release publication by constitutional courts"* published in Politics (https://doi.org/10.1177/0263395719885753). In the folder in/prepareddata, you can find the final data set (finaldata_FCC_PR.csv), which is also uploaded on figshare (https://figshare.com/articles/Judicial_Public_Relations_of_the_Federal_German_Constitutional_Court_FCC_/7628729).

## Code (*in/code*)

prep.analysis.data.R:

- This script contains the code that is necessary to provide the basic data that is necessary for analysis. This script produces the *FCC_Press_Releases_data.csv*.

Analysis.rmd

- Is a markdown file where all the analyses are run. Includes the main analyses and some additional analysis to control for possible interactions (mentioned in the paper, but not reported).

prep.finaldata.R:

- This script contains the code that is necessary to produce the finaldata.csv. It uses the date from the *FCC_Press_Releases_data.csv* and renames the central variables, used for the analysis, in the way they were named in the paper and removes all other unused variables. This data is also uploaded on figshare in the rda format (https://figshare.com/articles/Judicial_Public_Relations_of_the_Federal_German_Constitutional_Court_FCC_/7628729).

## Data Sets (*in/data-input*)

This folder contains three data sets that are necessary to replicate my analyses.

FCC_PR_decisions.csv:

- This data set contains detailed information on all senate decisions issued by the FCC between 1996 and 2018, which are open to the public on the Court's website (https://www.bundesverfassungsgericht.de/SiteGlobals/Forms/Suche/Entscheidungensuche_Formular.html?language_=de). According to the Court, the webpage contains all *essential* (wesentlichen) decisions ruled by the Court since 1996. To create this data set, the full texts of the decisions and the basic information from the first layer of the decision webpage (which is organized as a table) was previously scraped. In detail, this data set contains information on the docket number, the decision date (as full date, but also as separate day, month, year variables), the decision-related press release, the senate and chamber which have issued the decision, unanimously, existence of separate opinions, oral hearings, status quo changes, lower court overrulings and proceeding types. 

FCC_Press.csv:

- This data set contains information on newspaper articles published by 36 German quality (daily national and regional and weekly) newspapers. The articles were previously retrieved from LexisNexis through a keyword search (using "Bundesverfassungsgericht", duplicates excluded) and converted into a CSV file by using the LexisNexisTools package (https://github.com/JBGruber/LexisNexisTools). In detail, the data set covers information regarding media outlets which has published the articles, the date of publication, the headlines, the section in which the articles were placed within the newspaper (if reported), and whether the article is a news agency report.

The data set is used to create the control variable *prior_attention*, which measures whether a decision was covered by a media outlet prior to the official judgment at least once.

FCC_Press_Releases_data.csv: 

- This data set is created by merging *FCC_Press.csv* and *FCC_PR_decisions.csv*. It contains all necessary information for the analysis. The creation of the data set is reported in *prep.analysis.data.R*.

## Outcome (out)

- The outcome folder contains jpg. Files illustrating tables and figures, which were created with the results reported in the Analysis.rmd and used in the final paper.

## General information on the finaldata_FCC_PR.csv (in/prepareddata)

The **finaldata_FCC_PR.csv** and accompanied codebooks can be found on figshare (https://figshare.com/articles/Judicial_Public_Relations_of_the_Federal_German_Constitutional_Court_FCC_/7628729). It can be used to run the analysis, but is mainly for data transparency and was created for the initial submission of the paper.

The **finaldata_FCC_PR.csv** contains the following variables:

- document_id:    Identification number court decision (date[yyyymmdd]_docketnumber)
- decision_year:    Year of court decision
- decision_date:    Date of court decision
- docket_number    Docket number of court decision
- decision_shorttext: Short text of court decision, covering the general topic
- pressrelease_publication: Existence of a decision-related press release: Is a press release published in the context of the respective decision? yes (1); no (0)
- pressrelease_date: Date of the decision-related press release
- pressrelease_number: Number of the press release (internal sequence number/year)
- dissenting_opinion: Existence of a dissenting opinion: Is the respective decision accompanied with a dissenting opinion? yes (1); no (0)
- oral_hearing: Existence of an oral hearing: Was an oral hearing held in the context of the respective decisions? yes (1); no (0)
- statusquo_change: Existence of a status quo change: Is the Court invalidating a statute with the respective decision? yes (1); no (0)
- lower_court_overruling: Existence of a lower court overruling: Does the Court overrules a lower court decision? yes (1); no (0)
- abstract_review:    Existence of an abstract review: Is the respective decision concerned with an abstract review (BvF)? yes (1); no (0)
- concrete_review:    Existence of a concrete review: Is the respective decision concerned with a concrete review (BvL)? yes (1); no (0)
- constitutional_complaint:    Existence of a constitution complaint: Is the respective decision concerned with a constitutional complaint (BvR)? yes (1); no (0)
- dispute_federalorgans:    Existence of a dispute between federal organs: Is the respective decision concerned with a dispute between federal organs (BvE)? yes (1); no (0)
- dispute_federation_land:    Existence of a dispute between the federation and a land: Is the respective decision concerned with a dispute between the federation and a land (BvE)? yes (1); no (0)
- second_senate:    Deciding court branch: Is the second senate the deciding court branch for the respective decision? yes (1); no (0)
- judgment:    Decision type: Is the respective decision a judgment rather and not an order? yes (1); no (0)
- decision_length:    Word count of court decision.
- prior_attention:    Decision was covered by the media prior to the official announcement at least once. yes (1); no (0)



## How to replicate the analyses

1. To replicate the results of the study, you first use the *prep.analysis.data.R* and follow the code. Once you have run this, you are ready to do the analysis. 

2. The *Analysis.rmd* is an RMarkdown containing all the code for the main analysis and some additional analyses. It also produces graphs and regression tables.