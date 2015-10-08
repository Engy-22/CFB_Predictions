
library(SortableHTMLTables)
library(plyr)

#Add logos to predictions
schedule_2015 <- read.csv("/Users/patrick/Dropbox/Summer 2015/CFB_Stats/VS_FBS_ONLY/WEEK_5/schedule/2015_Schedule_Week_5.csv")
schedule_2015$Winner.Tie <- gsub(";", "", schedule_2015$Winner.Tie)
schedule_2015$Loser.Tie <- gsub(";", "", schedule_2015$Loser.Tie)
schedule_2015$Winner.Tie <- gsub("^\\s*\\(.*\\)\\s*", "", schedule_2015$Winner.Tie)
schedule_2015$Winner.Tie <- gsub(";", "", schedule_2015$Winner.Tie)
schedule_2015$Loser.Tie <- gsub("^\\s*\\(.*\\)\\s*", "", schedule_2015$Loser.Tie)
schedule_2015$Loser.Tie <- gsub(";", "", schedule_2015$Loser.Tie)

schedule_2015$Home_Team <- ifelse(schedule_2015$Home.Away == "@", schedule_2015$Loser.Tie, schedule_2015$Winner.Tie)
schedule_2015$Away_Team <- ifelse(schedule_2015$Home.Away == "@", schedule_2015$Winner.Tie, schedule_2015$Loser.Tie)
schedule_2015$Home_Team_Pts <- ifelse(schedule_2015$Home.Away == "@", schedule_2015$Loser.Pts, schedule_2015$Winner.Pts)
schedule_2015$Away_Team_Pts <- ifelse(schedule_2015$Home.Away == "@", schedule_2015$Winner.Pts, schedule_2015$Loser.Pts)

schedule_2015$Home_Team <- gsub("FL", "Florida", schedule_2015$Home_Team)
schedule_2015$Away_Team <- gsub("FL", "Florida", schedule_2015$Away_Team)

schedule_2015$Home_Team <- gsub("OH", "Ohio", schedule_2015$Home_Team)
schedule_2015$Away_Team <- gsub("OH", "Ohio", schedule_2015$Away_Team)
schedule_2015 <- schedule_2015[c("Rk",  "Wk", "Time", "Day", "Home_Team", "Away_Team")]

#Create variable with path for logos for each team
schedule_2015$Home_Team_Logo <- tolower(schedule_2015$Home_Team)
schedule_2015$Home_Team_Logo <- gsub(" ", "-",schedule_2015$Home_Team_Logo)
schedule_2015$Home_Team_Logo <- paste( schedule_2015$Home_Team_Logo, "-sm.png",sep="")
schedule_2015$Home_Name_Logo <- paste("<img src = ","/wp-content/sports-img/", schedule_2015$Home_Team_Logo,' align="middle"> ', schedule_2015$Home_Team, sep = "")

schedule_2015$Away_Team_Logo <- tolower(schedule_2015$Away_Team)
schedule_2015$Away_Team_Logo <- gsub(" ", "-",schedule_2015$Away_Team_Logo)
schedule_2015$Away_Team_Logo <- paste( schedule_2015$Away_Team_Logo, "-sm.png",sep="")
schedule_2015$Away_Name_Logo <- paste("<img src = ","/wp-content/sports-img/", schedule_2015$Away_Team_Logo,' align="middle"> ', schedule_2015$Away_Team, sep = "")
schedule_2015_final <- schedule_2015[c("Wk", "Time", "Day", "Home_Team", "Away_Team", "Home_Name_Logo", "Away_Name_Logo")]
schedule_2015_final <- subset(schedule_2015_final, schedule_2015_final$Wk == 6)
schedule_2015_week_6 <- schedule_2015_final[c("Home_Team", "Away_Team", "Time", "Day", "Home_Name_Logo", "Away_Name_Logo")]
predictions <- read.csv("/Users/patrick/Dropbox/Summer 2015/CFB_Stats/Week_5_Predictions_SoS_norm.csv")

#Add in correct times data and then clean the names then merge it in and replace the times
game_times <- read.csv("game_time_week_6.csv")

game_times$Home_Team <- gsub("OH", "Ohio",game_times$Home_Team)
game_times$Home_Team <- gsub("FL", "Florida",game_times$Home_Team)
game_times$Home_Team <- gsub("SMU", "Southern Methodist",game_times$Home_Team)
game_times$Home_Team <- gsub("OSU", "Ohio State",game_times$Home_Team)
game_times$Home_Team <- gsub("TCU", "Texas Christian",game_times$Home_Team)
game_times$Home_Team <- gsub("LSU", "Louisiana State",game_times$Home_Team)
game_times$Home_Team <- gsub("Ole Miss", "Mississippi",game_times$Home_Team)
game_times$Home_Team <- gsub("USC", "Southern California",game_times$Home_Team)
game_times$Home_Team <- gsub("FSU", "Florida State",game_times$Home_Team)
game_times$Home_Team <- gsub("VT", "Virginia Tech",game_times$Home_Team)
game_times$Home_Team <- gsub("UNC", "North Carolina",game_times$Home_Team)
game_times$Home_Team <- gsub("Cal", "California",game_times$Home_Team)
game_times$Home_Team <- gsub("Miss St", "Mississippi State",game_times$Home_Team)
game_times$Home_Team <- gsub("Pitt", "Pittsburgh",game_times$Home_Team)
game_times$Home_Team <- gsub("NC State", "North Carolina State",game_times$Home_Team)
game_times$Home_Team <- gsub("LA Tech", "Louisiana Tech",game_times$Home_Team)
game_times$Home_Team <- gsub("BYU", "Brigham Young",game_times$Home_Team)
game_times$Home_Team <- gsub("Washington St", "Washington State",game_times$Home_Team)
game_times$Home_Team <- gsub("W Kentucky", "Western Kentucky",game_times$Home_Team)
game_times$Home_Team <- gsub("UVA", "Virginia",game_times$Home_Team)
game_times$Home_Team <- gsub("W Michigan", "Western Michigan",game_times$Home_Team)
game_times$Home_Team <- gsub("Appalachian St", "Appalachian State",game_times$Home_Team)
game_times$Home_Team <- gsub("Ga Southern", "Georgia Southern",game_times$Home_Team)
game_times$Home_Team <- gsub("UCF", "Central Florida",game_times$Home_Team)
game_times$Home_Team <- gsub("N Illinois", "Northern Illinois",game_times$Home_Team)
game_times$Home_Team <- gsub("ECU", "East Carolina",game_times$Home_Team)
game_times$Home_Team <- gsub("Mid Tennessee", "Middle Tennessee State",game_times$Home_Team)
game_times$Home_Team <- gsub("Bowling Green", "Bowling Green State",game_times$Home_Team)
game_times$Home_Team <- gsub("LA-Lafayette", "Louisiana-Lafayette",game_times$Home_Team)
game_times$Home_Team <- gsub("FIU", "Florida International",game_times$Home_Team)
game_times$Home_Team <- gsub("UMass", "Massachusetts",game_times$Home_Team)
game_times$Home_Team <- gsub("Southern Miss", "Southern Mississippi",game_times$Home_Team)
game_times$Home_Team <- gsub("Cent Michigan", "Central Michigan",game_times$Home_Team)
game_times$Home_Team <- gsub("USF", "South Florida",game_times$Home_Team)
game_times$Home_Team <- gsub("UL Monroe", "Louisiana-Monroe",game_times$Home_Team)
game_times$Home_Team <- gsub("FAU", "Florida Atlantic",game_times$Home_Team)
game_times$Home_Team <- gsub("New Mexico St", "New Mexico State",game_times$Home_Team)
game_times$Home_Team <- gsub("UTEP", "Texas-El Paso",game_times$Home_Team)
game_times$Home_Team <- gsub("UConn", "Connecticut",game_times$Home_Team)
game_times$Home_Team <- gsub("UTSA", "Texas-San Antonio",game_times$Home_Team)
game_times$Home_Team <- gsub("E Michigan", "Eastern Michigan",game_times$Home_Team)
game_times$Home_Team <- gsub("UNLV", "Nevada-Las Vegas",game_times$Home_Team)
game_times$Home_Team <- gsub("Southern Californiaifornia", "Southern California",game_times$Home_Team)
game_times$Home_Team <- gsub("Californiaifornia", "California",game_times$Home_Team)
game_times$Home_Team <- gsub("Mississippi St", "Mississippi State",game_times$Home_Team)
game_times$Home_Team <- gsub("Pittsburghsburgh", "Pittsburgh",game_times$Home_Team)
game_times$Home_Team <- gsub("Florida Atl", "Florida Atlantic",game_times$Home_Team)
game_times$Away_Team <- gsub("Stateate", "State",game_times$Away_Team)


game_times$Away_Team <- gsub("OH", "Ohio",game_times$Away_Team)
game_times$Away_Team <- gsub("FL", "Florida",game_times$Away_Team)
game_times$Away_Team <- gsub("SMU", "Southern Methodist",game_times$Away_Team)
game_times$Away_Team <- gsub("OSU", "Ohio State",game_times$Away_Team)
game_times$Away_Team <- gsub("TCU", "Texas Christian",game_times$Away_Team)
game_times$Away_Team <- gsub("LSU", "Louisiana State",game_times$Away_Team)
game_times$Away_Team <- gsub("Ole Miss", "Mississippi",game_times$Away_Team)
game_times$Away_Team <- gsub("USC", "Southern California",game_times$Away_Team)
game_times$Away_Team <- gsub("FSU", "Florida State",game_times$Away_Team)
game_times$Away_Team <- gsub("VT", "Virginia Tech",game_times$Away_Team)
game_times$Away_Team <- gsub("UNC", "North Carolina",game_times$Away_Team)
game_times$Away_Team <- gsub("Cal", "California",game_times$Away_Team)
game_times$Away_Team <- gsub("Miss St", "Mississippi State",game_times$Away_Team)
game_times$Away_Team <- gsub("Pitt", "Pittsburgh",game_times$Away_Team)
game_times$Away_Team <- gsub("NC State", "North Carolina State",game_times$Away_Team)
game_times$Away_Team <- gsub("LA Tech", "Louisiana Tech",game_times$Away_Team)
game_times$Away_Team <- gsub("BYU", "Brigham Young",game_times$Away_Team)
game_times$Away_Team <- gsub("Washington St", "Washington State",game_times$Away_Team)
game_times$Away_Team <- gsub("W Kentucky", "Western Kentucky",game_times$Away_Team)
game_times$Away_Team <- gsub("UVA", "Virginia",game_times$Away_Team)
game_times$Away_Team <- gsub("W Michigan", "Western Michigan",game_times$Away_Team)
game_times$Away_Team <- gsub("Appalachian St", "Appalachian State",game_times$Away_Team)
game_times$Away_Team <- gsub("Ga Southern", "Georgia Southern",game_times$Away_Team)
game_times$Away_Team <- gsub("UCF", "Central Florida",game_times$Away_Team)
game_times$Away_Team <- gsub("N Illinois", "Northern Illinois",game_times$Away_Team)
game_times$Away_Team <- gsub("ECU", "East Carolina",game_times$Away_Team)
game_times$Away_Team <- gsub("Mid Tennessee", "Middle Tennessee State",game_times$Away_Team)
game_times$Away_Team <- gsub("Bowling Green", "Bowling Green State",game_times$Away_Team)
game_times$Away_Team <- gsub("LA-Lafayette", "Louisiana-Lafayette",game_times$Away_Team)
game_times$Away_Team <- gsub("FIU", "Florida International",game_times$Away_Team)
game_times$Away_Team <- gsub("UMass", "Massachusetts",game_times$Away_Team)
game_times$Away_Team <- gsub("Southern Miss", "Southern Mississippi",game_times$Away_Team)
game_times$Away_Team <- gsub("Cent Michigan", "Central Michigan",game_times$Away_Team)
game_times$Away_Team <- gsub("USF", "South Florida",game_times$Away_Team)
game_times$Away_Team <- gsub("UL Monroe", "Louisiana-Monroe",game_times$Away_Team)
game_times$Away_Team <- gsub("FAU", "Florida Atlantic",game_times$Away_Team)
game_times$Away_Team <- gsub("New Mexico St", "New Mexico State",game_times$Away_Team)
game_times$Away_Team <- gsub("UTEP", "Texas-El Paso",game_times$Away_Team)
game_times$Away_Team <- gsub("UConn", "Connecticut",game_times$Away_Team)
game_times$Away_Team <- gsub("UTSA", "Texas-San Antonio",game_times$Away_Team)
game_times$Away_Team <- gsub("E Michigan", "Eastern Michigan",game_times$Away_Team)
game_times$Away_Team <- gsub("UNLV", "Nevada-Las Vegas",game_times$Away_Team)
game_times$Away_Team <- gsub("Southern Californiaifornia", "Southern California",game_times$Away_Team)
game_times$Away_Team <- gsub("Californiaifornia", "California",game_times$Away_Team)
game_times$Away_Team <- gsub("Mississippi St", "Mississippi State",game_times$Away_Team)
game_times$Away_Team <- gsub("Pittsburghsburgh", "Pittsburgh",game_times$Away_Team)
game_times$Away_Team <- gsub("Florida Atl", "Florida Atlantic",game_times$Away_Team)
game_times$Away_Team <- gsub("Stateate", "State",game_times$Away_Team)
# setdiff(game_times$Home_Team,matchup_week_6$Home_Team)






#Merge predictions with the matchups this week
publish_version <- merge(predictions, schedule_2015_week_6, by.x = c("Home.Team", "Away.Team"), by.y = c("Home_Team", "Away_Team"))
publish_version <- merge(publish_version, game_times, by.x = "Home.Team", by.y = "Away_Team", all = TRUE)
publish_version <- na.omit(publish_version)

#Adjust the times for PST
publish_version$Time.y <- gsub("p ET"," PM",publish_version$Time.y)
publish_version$Time_POSIX <- as.POSIXct(publish_version$Time.y,format="%I:%M %p")
publish_version$Time_PST <- publish_version$Time_POSIX - 10800
publish_version$Time_PST <- strftime(publish_version$Time_PST, format = "%I:%M %p")
publish_version$Time <- publish_version$Time_PST

#Order by day and subset to keep relevant columns
days <- c('Sun','Mon','Tues','Wed','Thu','Fri','Sat')
publish_version$Day <- factor(publish_version$Day, levels = days)
publish_version <- publish_version[order(publish_version$Day, publish_version$Time),]
publish_version<- publish_version[c("Day", "Time", "Home_Name_Logo", "Away_Name_Logo", "Home.Team.Odds", "Away.Team.Odds")]


#R doesn't like displaying percentages with the % symbol..
publish_version$Home.Team.Spread <- (publish_version$Away.Team.Odds-0.5111)/0.0246
publish_version$Home.Team.Spread <- round(publish_version$Home.Team.Spread * 2)/2
publish_version$Home.Team.Odds <- paste(round(publish_version$Home.Team.Odds * 100, 2), "%", sep="")
publish_version$Away.Team.Odds <- paste(round(publish_version$Away.Team.Odds * 100, 2), "%", sep="")

#Clean up column names and make HTML table to publish results
colnames(publish_version) <- c("Day", "Time","Home Team", "Away Team", "Home Team Odds", "Away Team Odds", "Spread")
publish_version_spread <- publish_version[c("Day", "Time","Home Team", "Away Team", "Spread")]
sortable.html.table(publish_version_spread, 'week_6_predictions_spread.html')
sortable.html.table(publish_version, 'week_6_predictions.html')