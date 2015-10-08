setwd("/Users/patrick/Dropbox/Summer 2015/CFB_Stats/VS_FBS_ONLY/WEEK_5")
library(plyr)
paths <- c("/Users/patrick/Dropbox/Summer 2015/CFB_Stats/VS_FBS_ONLY/WEEK_5/data")
matchup_2014 <- read.csv("/Users/patrick/Dropbox/Summer 2015/CFB_Stats/matchup_2014_data_9_14.csv")

espn_sos <- read.csv("/Users/patrick/Dropbox/Summer 2015/CFB_Stats/VS_FBS_ONLY/WEEK_5/FPI/espn_power_ranking_2015_week_5.csv")

schedule_week_5 <- read.csv("/Users/patrick/Dropbox/Summer 2015/CFB_Stats/VS_FBS_ONLY/WEEK_5/schedule/2015_Schedule_Week_5.csv")


#Clean data and Load the cfbstats.com data as separate datasets
clean_data <- function(){
  files <- list.files(path=paths, pattern="*.csv")
  stats_list <- files
  stats_list <- gsub(".csv", "", stats_list)
  stats_list <- stats_list[grepl("clean",stats_list)]
for (path in paths){
  setwd(paths)
  files <- list.files(path=paths, pattern="*.csv")
  stats_list <- files
  stats_list <- gsub(".csv", "", stats_list)
  #Change abbreviations to match schedule dataset
  for (f in files){
    dataset <- read.csv(f)
    
    dataset$Name <- gsub("USC", "Southern California",dataset$Name)
    dataset$Name <- gsub("UCF", "Central Florida",dataset$Name)
    dataset$Name <- gsub("SMU", "Southern Methodist",dataset$Name)
    #dataset$Name <- gsub("Miami (Florida)", "Central Florida",dataset$Name)
    dataset$Name <- gsub("TCU", "Texas Christian",dataset$Name)
    dataset$Name <- gsub("UAB", "Alabama-Birmingham",dataset$Name)
    dataset$Name <- gsub("Middle Tennessee", "Middle Tennessee State",dataset$Name)
    dataset$Name <- gsub("UTSA", "Texas-San Antonio",dataset$Name)
    dataset$Name <- gsub("UTEP", "Texas-El Paso",dataset$Name)
    dataset$Name <- gsub("BYU", "Brigham Young",dataset$Name)
    #dataset$Name <- gsub("Miami (Ohio)", "Central Florida",dataset$Name)
    dataset$Name <- gsub("Bowling Green", "Bowling Green State",dataset$Name)
    dataset$Name <- gsub("UNLV", "Nevada-Las Vegas",dataset$Name)
    dataset$Name <- gsub("Hawai'i", "Hawaii",dataset$Name)
    dataset$Name <- gsub("LSU", "Louisiana State",dataset$Name)
    dataset$Name <- gsub("State State State", "State", dataset$Name)
    # dataset$Name <- gsub("Charlotte", )
    write.csv(file = paste("clean_",f,sep = ""), x= dataset)
    
    }
  }
}
clean_data()

#Need to fix this function
merge_data <- function(){

  merged_data <- Reduce(function(x, y) merge(x, y, by.x = "Name",by.y = "Name", all=TRUE), list(clean_Pass_Def_2015_week_5, clean_Pass_Off_2015_week_5, clean_Rush_Def_2015_week_5,clean_Rush_Off_2015_week_5,
                                                                                                clean_Turnover_Margin_2015_week_5))
  merged_data <- subset(merged_data,select = c("Name", "Pass.Offense.Yards.G" ,"Pass.Defense.Yards.G","Rush.Offense.Yards.G",
                                               "Rush.Defense.Yards.G","Margin.G"))
  return(merged_data)
}

prep_schedule <- function(schedule,week){
  schedule$Winner.Tie <- gsub(";", "", schedule$Winner.Tie)
  schedule$Loser.Tie <- gsub(";", "", schedule$Loser.Tie)
  schedule$Winner.Tie <- gsub("^\\s*\\(.*\\)\\s*", "", schedule$Winner.Tie)
  schedule$Winner.Tie <- gsub(";", "", schedule$Winner.Tie)
  schedule$Loser.Tie <- gsub("^\\s*\\(.*\\)\\s*", "", schedule$Loser.Tie)
  schedule$Loser.Tie <- gsub(";", "", schedule$Loser.Tie)
  
  schedule$Home_Team <- ifelse(schedule$Home.Away == "@", schedule$Loser.Tie, schedule$Winner.Tie)
  schedule$Away_Team <- ifelse(schedule$Home.Away == "@", schedule$Winner.Tie, schedule$Loser.Tie)
  schedule$Home_Team_Pts <- ifelse(schedule$Home.Away == "@", schedule$Loser.Pts, schedule$Winner.Pts)
  schedule$Away_Team_Pts <- ifelse(schedule$Home.Away == "@", schedule$Winner.Pts, schedule$Loser.Pts)
  
  schedule$Home_Team <- gsub("FL", "Florida", schedule$Home_Team)
  schedule$Away_Team <- gsub("FL", "Florida", schedule$Away_Team)
  
  schedule$Home_Team <- gsub("OH", "Ohio", schedule$Home_Team)
  schedule$Away_Team <- gsub("OH", "Ohio", schedule$Away_Team)
  schedule <- schedule[c("Rk",  "Wk", "Time", "Day", "Home_Team","Home_Team_Pts", "Away_Team", "Away_Team_Pts")]
  schedule <- subset(schedule, schedule$Wk == week)
}

prep_FPI <- function(location,year,week){
  espn_sos$TEAM <- gsub(";", "", espn_sos$TEAM)
  espn_sos$TEAM <- gsub(",.*", "", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("OH", "Ohio", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("FL", "Florida", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("SMU", "Southern Methodist", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("OSU", "Ohio State", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("TCU", "Texas Christian", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("LSU", "Louisiana State", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("Ole Miss", "Mississippi", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("USC", "Southern California", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("FSU", "Florida State", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("VT", "Virginia Tech", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("UNC", "North Carolina", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("Cal", "California", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("Miss St", "Mississippi State", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("Pitt", "Pittsburgh", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("NC State", "North Carolina State", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("LA Tech", "Louisiana Tech", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("BYU", "Brigham Young", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("Washington St", "Washington State", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("W Kentucky", "Western Kentucky", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("UVA", "Virginia", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("W Michigan", "Western Michigan", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("Appalachian St", "Appalachian State", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("Ga Southern", "Georgia Southern", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("UCF", "Central Florida", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("N Illinois", "Northern Illinois", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("ECU", "East Carolina", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("Mid Tennessee", "Middle Tennessee State", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("Bowling Green", "Bowling Green State", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("LA-Lafayette", "Louisiana-Lafayette", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("FIU", "Florida International", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("UMass", "Massachusetts", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("Southern Miss", "Southern Mississippi", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("Cent Michigan", "Central Michigan", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("USF", "South Florida", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("UL Monroe", "Louisiana-Monroe", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("FAU", "Florida Atlantic", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("New Mexico St", "New Mexico State", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("UTEP", "Texas-El Paso", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("UConn", "Connecticut", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("Charlotte", "", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("UTSA", "Texas-San Antonio", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("E Michigan", "Eastern Michigan", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("UNLV", "Nevada-Las Vegas", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("Southern Californiaifornia", "Southern California", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("Californiaifornia", "California", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("Mississippi St", "Mississippi State", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("Pittsburghsburgh", "Pittsburgh", espn_sos$TEAM)
  espn_sos$TEAM <- gsub("Florida Atl", "Florida Atlantic", espn_sos$TEAM)
  espn_sos <- subset(espn_sos, select = c("TEAM", "FPI"))
  
  espn_sos_Home <- espn_sos
  colnames(espn_sos_Home) <- paste("Home", colnames(espn_sos_Home), sep = "_")
  espn_sos_Away <- espn_sos
  colnames(espn_sos_Away) <- paste("Away", colnames(espn_sos_Away), sep = "_")
  
#   year = "2015_"
#   week = "week_3"
  write.csv(file = paste(location,"espn_Home_FPI_",year,week,".csv", sep = ''), x = espn_sos_Home)
  write.csv(file = paste(location, "espn_Away_FPI_",year,week,".csv", sep = ''), x = espn_sos_Away)
  
  
}

files <- list.files(path=paths, pattern="*.csv")
for(file in files){
  perpos <- which(strsplit(file, "")[[1]]==".")
  assign( gsub(" ","",substr(file, 1, perpos-1)), 
          read.csv(paste(file)))
}

#The week the data is relevant for
schedule <- prep_schedule(schedule_week_5,5)
prep_FPI("/Users/patrick/Dropbox/Summer 2015/CFB_Stats/VS_FBS_ONLY/WEEK_5/FPI/","2015_","week_6")

merged_data <-merge_data() #Make sure list of dataframes matches what you want to merge
merged_data_home <- merged_data
colnames(merged_data_home) <- paste("Home", colnames(merged_data_home), sep = "_")
merged_data_away <- merged_data
colnames(merged_data_away) <- paste("Away", colnames(merged_data_away), sep = "_")

espn_sos_Away <- read.csv("/Users/patrick/Dropbox/Summer 2015/CFB_Stats/VS_FBS_ONLY/WEEK_5/FPI/espn_Away_FPI_2015_week_5.csv")
colnames(espn_sos_Away) <- c("Rank", "Name", "Away_FPI")
espn_sos_Away <- subset(espn_sos_Away, select = c("Name", "Away_FPI"))
espn_sos_Away$Name <- gsub("^$|^ $", "Charlotte", espn_sos_Away$Name) 
espn_sos_Away$Name <- gsub("Stateate", "State", espn_sos_Away$Name)

espn_sos_Home <- read.csv("/Users/patrick/Dropbox/Summer 2015/CFB_Stats/VS_FBS_ONLY/WEEK_5/FPI/espn_Home_FPI_2015_week_5.csv")
colnames(espn_sos_Home) <- c("Rank", "Name", "Home_FPI")
espn_sos_Home <- subset(espn_sos_Home, select = c("Name", "Home_FPI"))
espn_sos_Home$Name <- gsub("^$|^ $", "Charlotte", espn_sos_Home$Name) 
espn_sos_Home$Name <- gsub("Stateate", "State", espn_sos_Home$Name)

matchup <- merge(schedule, merged_data_home, by.x = "Home_Team", by.y = "Home_Name", all = TRUE)
matchup <- merge(matchup, merged_data_away, by.x = "Away_Team", by.y = "Away_Name", all = TRUE)
matchup <- merge(matchup, espn_sos_Home, by.x = "Home_Team", by.y = "Name", all = TRUE)
matchup <- merge(matchup, espn_sos_Away, by.x = "Away_Team", by.y = "Name", all = TRUE)
matchup <- subset(matchup, !is.na(matchup$Home_Team) & !is.na(matchup$Away_Team))
# matchup <- na.omit(matchup)

matchup_2015_week_1 <- read.csv("/Users/patrick/Dropbox/Summer 2015/CFB_Stats/matchup_2015_week_1_9_14.csv")
matchup_2015_week_1 <- subset(matchup_2015_week_1, ,-c(X,SoS_Home, SoS_Away))
matchup_2015_week_2 <- read.csv("/Users/patrick/Dropbox/Summer 2015/CFB_Stats/matchup_2015_week_2_9_14.csv")
matchup_2015_week_2 <- subset(matchup_2015_week_2, ,-c(X,SoS_Home, SoS_Away))
matchup_2015_week_3 <- read.csv("/Users/patrick/Dropbox/Summer 2015/CFB_Stats/matchup_2015_week_3.csv")
matchup_2015_week_3 <- subset(matchup_2015_week_3, ,-c(X,SoS_Home, SoS_Away))
#HOW TO CALCULATE SoS FOR WEEK 2??
# full_1_2 <- rbind(matchup_2015_week_1,matchup_2015_week_2)
# full_1_2_3 <- rbind(full_1_2, matchup_2015_week_3)
all_matchups <- Reduce(function(x, y) rbind(x,y), list(matchup_2015_week_1,matchup_2015_week_2,matchup_2015_week_3))

#Create SoS
home_games_2015 <- count(all_matchups, vars ="Home_Team")
home_games_2015$Num_Home_Games <- home_games_2015$freq
home_games_2015 <- subset(home_games_2015, select = c('Home_Team', 'Num_Home_Games'))
Home_Opp_FPI_2015 <- aggregate(Away_FPI ~ Home_Team, data = all_matchups, FUN = sum)
colnames(Home_Opp_FPI_2015) <- c("Home_Team", "SoS_Home")
home_games_2015 <- merge(home_games_2015, Home_Opp_FPI_2015, by = "Home_Team", all = TRUE)

away_games_2015 <- count(all_matchups, vars=c("Away_Team"))
away_games_2015$Num_Away_Games <- away_games_2015$freq
away_games_2015 <- subset(away_games_2015, select = c('Away_Team', 'Num_Away_Games'))
Away_Opp_FPI_2015 <- aggregate(Home_FPI ~ Away_Team, data = all_matchups, FUN = sum)
colnames(Away_Opp_FPI_2015) <- c("Away_Team", "SoS_Away")
away_games_2015 <- merge(away_games_2015, Away_Opp_FPI_2015, by = "Away_Team")

#FIX THIS OR JUST HAVE MISSING VALUES BE ZERO
SoS_2015 <- merge(home_games_2015, away_games_2015, by.x = "Home_Team", by.y = "Away_Team", all = TRUE)
# SoS_2015_week_3 <- merge(SoS_2015_week_3, away_games_2015_week_3, by.x = "Home_Team", by.y = "Away_Team")
SoS_2015$Num_Home_Games <- ifelse(is.na(SoS_2015$Num_Home_Games), 0, SoS_2015$Num_Home_Games)
SoS_2015$Num_Away_Games <- ifelse(is.na(SoS_2015$Num_Away_Games), 0, SoS_2015$Num_Away_Games)
SoS_2015$SoS_Home <- ifelse(is.na(SoS_2015$SoS_Home), SoS_2015$SoS_Home[SoS_2015$Home_Team %in% matchup_2014$Home_Team],SoS_2015$SoS_Home)
SoS_2015$SoS_Away <- ifelse(is.na(SoS_2015$SoS_Away), SoS_2015$SoS_Away[SoS_2015$Home_Team %in% matchup_2014$Away_Team],SoS_2015$SoS_Away)
SoS_2015$SoS_Home <- ifelse(is.na(SoS_2015$SoS_Home), 0, SoS_2015$SoS_Home)
SoS_2015$SoS_Away <- ifelse(is.na(SoS_2015$SoS_Away), 0, SoS_2015$SoS_Away)
SoS_2015 <- na.omit(SoS_2015)


SoS_2015$weighted_avg <- ((SoS_2015$SoS_Home) + (SoS_2015$SoS_Away))/(SoS_2015$Num_Home_Games + SoS_2015$Num_Away_Games)
SoS_2015$SoS <- SoS_2015$weighted_avg
SoS_2015$Away_Team <- SoS_2015$Home_Team
SoS_2015_Home_Team <- subset(SoS_2015, select = c("Home_Team", "SoS"))
SoS_2015_Away_Team <- subset(SoS_2015, select = c("Away_Team", "SoS"))
SoS_2015_Home_Team$SoS_Home <- SoS_2015_Home_Team$SoS
SoS_2015_Home_Team <- subset(SoS_2015_Home_Team, select = c("Home_Team", "SoS_Home"))
SoS_2015_Away_Team$SoS_Away <- SoS_2015_Away_Team$SoS
SoS_2015_Away_Team <- subset(SoS_2015_Away_Team, select = c("Away_Team", "SoS_Away"))



matchup <- merge(matchup, SoS_2015_Home_Team, by.x = "Home_Team", by.y = "Home_Team", all = TRUE)
matchup <- merge(matchup, SoS_2015_Away_Team, by.x = "Away_Team", by.y = "Away_Team", all = TRUE)
matchup <- subset(matchup, !is.na(matchup$Home_Team) & !is.na(matchup$Away_Team))
# matchup <- read.csv("/Users/patrick/Dropbox/Summer 2015/CFB_Stats/VS_FBS_ONLY/WEEK_5/matchup_2015_week_5.csv")
matchup <- subset(matchup, !is.na(matchup$SoS_Home) & !is.na(matchup$SoS_Away))
matchup$norm_SoS_Home <- (matchup$SoS_Home-min(matchup$SoS_Home))/(max(matchup$SoS_Home)-min(matchup$SoS_Home))
matchup$norm_SoS_Away <- (matchup$SoS_Away-min(matchup$SoS_Away))/(max(matchup$SoS_Away)-min(matchup$SoS_Away))

write.csv(file = "/Users/patrick/Dropbox/Summer 2015/CFB_Stats/VS_FBS_ONLY/WEEK_5/matchup_2015_week_5.csv", x = matchup)
