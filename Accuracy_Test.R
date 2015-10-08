#Read Schedule with scraped outcomes
schedule <- read.csv("2015_Schedule.csv")

#Clean up formatting of schedule. Remove rankings, etc.
schedule$Winner.Tie <- gsub(";", "", schedule$Winner.Tie)
schedule$Loser.Tie <- gsub(";", "", schedule$Loser.Tie)
schedule$Winner.Tie <- gsub("^\\s*\\(.*\\)\\s*", "", schedule$Winner.Tie)
schedule$Winner.Tie <- gsub(";", "", schedule$Winner.Tie)
schedule$Loser.Tie <- gsub("^\\s*\\(.*\\)\\s*", "", schedule$Loser.Tie)
schedule$Loser.Tie <- gsub(";", "", schedule$Loser.Tie)

#Create Home and Away columns from Loser and Winner columns
schedule$Home_Team <- ifelse(schedule$Home.Away == "@", schedule$Loser.Tie, schedule$Winner.Tie)
schedule$Away_Team <- ifelse(schedule$Home.Away == "@", schedule$Winner.Tie, schedule$Loser.Tie)
schedule$Home_Team_Pts <- ifelse(schedule$Home.Away == "@", schedule$Loser.Pts, schedule$Winner.Pts)
schedule$Away_Team_Pts <- ifelse(schedule$Home.Away == "@", schedule$Winner.Pts, schedule$Loser.Pts)

#Change abbreviations to match cfb_stats.com school names
schedule$Home_Team <- gsub("FL", "Florida", schedule$Home_Team)
schedule$Away_Team <- gsub("FL", "Florida", schedule$Away_Team)

schedule$Home_Team <- gsub("OH", "Ohio", schedule$Home_Team)
schedule$Away_Team <- gsub("OH", "Ohio", schedule$Away_Team)

#subset schedule to include only relevant variables and subset for relevant week
schedule <- schedule[c("Rk",  "Wk", "Time", "Day", "Home_Team","Home_Team_Pts", "Away_Team", "Away_Team_Pts")]
schedule <- subset(schedule, schedule$Wk == 5)

#Create a binary for win or loss
schedule$Win <- ifelse(schedule$Home_Team_Pts > schedule$Away_Team_Pts ,1 ,0)

#Load predictions
prediction <- read.csv("/Users/patrick/Dropbox/Summer 2015/CFB_Stats/week_5_predictions_SoS.csv")

#Merge actual outcomes and predictions
schedule <- merge(schedule, prediction, by.x = "Home_Team", by.y = "Home.Team")

#Create binary for predicted winner
schedule$predicted <- ifelse(as.numeric(schedule$Home.Team.Odds) > as.numeric(schedule$Away.Team.Odds), 1, 0)

#Compare actual versus predicted and print percentage correct
schedule$correct <- ifelse(schedule$Win == schedule$predicted, 1, 0)
sum(schedule$correct) / nrows(schedule)
