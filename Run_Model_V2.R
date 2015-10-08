

#Load datasets from past weeks and make sure variable names match with most recent week
matchup_2015_week_5 <- read.csv("matchup_2015_week_5.csv")
matchup_2014 <- read.csv("matchup_2014_data_9_14.csv")
matchup_2014 <- subset(matchup_2014, ,select = intersect(colnames(matchup_2014), colnames(matchup_2015_week_5)))
matchup_2015_week_1 <- read.csv("matchup_2015_week_1_9_14.csv")
matchup_2015_week_1 <- subset(matchup_2015_week_1, ,select = intersect(colnames(matchup_2015_week_1), colnames(matchup_2015_week_5)))
matchup_2015_week_2 <- read.csv("matchup_2015_week_2_9_14.csv")
matchup_2015_week_2 <- subset(matchup_2015_week_2, ,select = intersect(colnames(matchup_2015_week_2), colnames(matchup_2015_week_5)))
matchup_2015_week_3 <- read.csv("matchup_2015_week_3.csv")
matchup_2015_week_3 <- subset(matchup_2015_week_3, ,select = intersect(colnames(matchup_2015_week_3), colnames(matchup_2015_week_5)))
matchup_2015_week_4 <- read.csv("matchup_2015_week_4.csv")
matchup_2015_week_4 <- subset(matchup_2015_week_3, ,select = intersect(colnames(matchup_2015_week_4), colnames(matchup_2015_week_5)))
schedule_week_5 <- read.csv("2015_Schedule_Week_5.csv")

#Make datasets for model
data_combined <- Reduce(function(x, y) rbind(x,y), list(matchup_2014,matchup_2015_week_1,matchup_2015_week_2,matchup_2015_week_3,matchup_2015_week_4))
data_combined$Win <- ifelse(data_combined$Home_Team_Pts > data_combined$Away_Team_Pts, 1,0)
data_combined <- na.omit(data_combined)
data_combined <- subset(data_combined, !is.na(data_combined$SoS_Home) & !is.na(data_combined$SoS_Away))
data_combined$norm_SoS_Home <- (data_combined$SoS_Home-min(data_combined$SoS_Home))/(max(data_combined$SoS_Home)-min(data_combined$SoS_Home))
data_combined$norm_SoS_Away <- (data_combined$SoS_Away-min(data_combined$SoS_Away))/(max(data_combined$SoS_Away)-min(data_combined$SoS_Away))
data_combined$adj_SoS_Home <- abs(min(data_combined$SoS_Home)) + data_combined$SoS_Home
data_combined$adj_SoS_Away <- abs(min(data_combined$SoS_Away)) + data_combined$SoS_Away

#Create matchups for that week

schedule <- prep_schedule(schedule_week_5,PUT WEEK HERE) 

matchup_week_6 <- merge(schedule, merged_data_home, by.x = "Home_Team", by.y = "Home_Name", all = TRUE)
matchup_week_6 <- merge(matchup_week_6, merged_data_away, by.x = "Away_Team", by.y = "Away_Name", all = TRUE)
matchup_week_6 <- merge(matchup_week_6, espn_sos_Home, by.x = "Home_Team", by.y = "Name", all = TRUE)
matchup_week_6 <- merge(matchup_week_6, espn_sos_Away, by.x = "Away_Team", by.y = "Name", all = TRUE)
matchup_week_6 <- merge(matchup_week_6, SoS_2015_Home_Team, by.x = "Home_Team", by.y = "Home_Team", all = TRUE)
matchup_week_6 <- merge(matchup_week_6, SoS_2015_Away_Team, by.x = "Away_Team", by.y = "Away_Team", all = TRUE)
matchup_week_6 <- subset(matchup_week_6, !is.na(matchup_week_6$Home_Team) & !is.na(matchup_week_6$Away_Team))
matchup_week_6 <- subset(matchup_week_6, !is.na(matchup_week_6$SoS_Home) & !is.na(matchup_week_6$SoS_Away))

#Coerce FPI variables to be numeric because Reduce command is making them factors??
matchup_week_6$Home_FPI <- as.numeric(matchup_week_6$Home_FPI)
matchup_week_6$Away_FPI <- as.numeric(matchup_week_6$Away_FPI)

#Create normalized and adjust SoS measures
matchup_week_6$norm_SoS_Home <- (matchup_week_6$SoS_Home-min(matchup_week_6$SoS_Home))/(max(matchup_week_6$SoS_Home)-min(matchup_week_6$SoS_Home))
matchup_week_6$norm_SoS_Away <- (matchup_week_6$SoS_Away-min(matchup_week_6$SoS_Away))/(max(matchup_week_6$SoS_Away)-min(matchup_week_6$SoS_Away))
matchup_week_6$adj_SoS_Home <- abs(min(matchup_week_6$SoS_Home)) + matchup_week_6$SoS_Home
matchup_week_6$adj_SoS_Away <- abs(min(matchup_week_6$SoS_Away)) + matchup_week_6$SoS_Away



#Run regressions
test_model_FPI_SoS <- glm(Win~Home_Pass.Offense.Yards.G + Away_Pass.Offense.Yards.G+  Home_Pass.Defense.Yards.G+	Away_Pass.Defense.Yards.G +
                            Home_Rush.Offense.Yards.G +	Away_Rush.Offense.Yards.G +	Home_Rush.Defense.Yards.G +	Away_Rush.Defense.Yards.G +
                            Home_Margin.G +	Away_Margin.G + Home_FPI + Away_FPI + SoS_Home + SoS_Away , data = data_combined, family = binomial)

test_model_SoS <- glm(Win~Home_Pass.Offense.Yards.G + Away_Pass.Offense.Yards.G+  Home_Pass.Defense.Yards.G+	Away_Pass.Defense.Yards.G +
                        Home_Rush.Offense.Yards.G +	Away_Rush.Offense.Yards.G +	Home_Rush.Defense.Yards.G +	Away_Rush.Defense.Yards.G +
                        Home_Margin.G +	Away_Margin.G + SoS_Home + SoS_Away , data = data_combined, family = binomial)

test_model <- glm(Win~Home_Pass.Offense.Yards.G + Away_Pass.Offense.Yards.G+  Home_Pass.Defense.Yards.G+	Away_Pass.Defense.Yards.G +
                    Home_Rush.Offense.Yards.G +	Away_Rush.Offense.Yards.G +	Home_Rush.Defense.Yards.G +	Away_Rush.Defense.Yards.G +
                    Home_Margin.G +	Away_Margin.G, data = data_combined, family = binomial)

test_model_SoS_adj <- glm(Win~Home_Pass.Offense.Yards.G + Away_Pass.Offense.Yards.G+  Home_Pass.Defense.Yards.G+	Away_Pass.Defense.Yards.G +
                        Home_Rush.Offense.Yards.G +	Away_Rush.Offense.Yards.G +	Home_Rush.Defense.Yards.G +	Away_Rush.Defense.Yards.G +
                        Home_Margin.G +	Away_Margin.G + adj_SoS_Home + adj_SoS_Away , data = data_combined, family = binomial)

test_model_SoS_norm <- glm(Win~Home_Pass.Offense.Yards.G + Away_Pass.Offense.Yards.G+  Home_Pass.Defense.Yards.G+	Away_Pass.Defense.Yards.G +
                            Home_Rush.Offense.Yards.G +	Away_Rush.Offense.Yards.G +	Home_Rush.Defense.Yards.G +	Away_Rush.Defense.Yards.G +
                            Home_Margin.G +	Away_Margin.G + adj_SoS_Home + adj_SoS_Away , data = data_combined, family = binomial)




#Predict that week's matchup and create data frame with the odds for each team
#Slightly redundant to do 1- home odds but easier for readers to understand
predict_model_FPI_SoS <- predict(test_model_FPI_SoS, type = "response", newdata = matchup_week_6)

model_results_FPI_SoS <- data.frame(matchup_week_6$Home_Team, matchup_week_6$Away_Team, predict_model_FPI_SoS)
model_results_FPI_SoS$AwayOdds <- NA
model_results_FPI_SoS$AwayOdds <- 1 - model_results_FPI_SoS$predict_model_FPI_SoS
model_results_FPI_SoS <- na.omit(model_results_FPI_SoS)
colnames(model_results_FPI_SoS) <- c("Home Team", "Away Team", "Home Team Odds", "Away Team Odds")

predict_model_SoS <- predict(test_model_SoS, type = "response", newdata = matchup_week_6)

model_results_SoS <- data.frame(matchup_week_6$Home_Team, matchup_week_6$Away_Team, predict_model_SoS)
model_results_SoS$AwayOdds <- NA
model_results_SoS$AwayOdds <- 1 - model_results_SoS$predict_model_SoS
model_results_SoS <- na.omit(model_results_SoS)
colnames(model_results_SoS) <- c("Home Team", "Away Team", "Home Team Odds", "Away Team Odds")

predict_model <- predict(test_model, type = "response", newdata = matchup_week_6)

model_results <- data.frame(matchup_week_6$Home_Team, matchup_week_6$Away_Team, predict_model)
model_results$AwayOdds <- NA
model_results$AwayOdds <- 1 - model_results$predict_model
model_results <- na.omit(model_results)
colnames(model_results) <- c("Home Team", "Away Team", "Home Team Odds", "Away Team Odds")

predict_model_SoS_adj <- predict(test_model_SoS_adj, type = "response", newdata = matchup_week_6)

model_results_SoS_adj <- data.frame(matchup_week_6$Home_Team, matchup_week_6$Away_Team, predict_model_SoS_adj)
model_results_SoS_adj$AwayOdds <- NA
model_results_SoS_adj$AwayOdds <- 1 - model_results_SoS_adj$predict_model_SoS_adj
model_results_SoS_adj <- na.omit(model_results_SoS_adj)
colnames(model_results_SoS_adj) <- c("Home Team", "Away Team", "Home Team Odds", "Away Team Odds")

predict_model_SoS_norm <- predict(test_model_SoS_norm, type = "response", newdata = matchup_week_6)

model_results_SoS_norm <- data.frame(matchup_week_6$Home_Team, matchup_week_6$Away_Team, predict_model_SoS_norm)
model_results_SoS_norm$AwayOdds <- NA
model_results_SoS_norm$AwayOdds <- 1 - model_results_SoS_norm$predict_model_SoS_norm
model_results_SoS_norm <- na.omit(model_results_SoS_norm)
colnames(model_results_SoS_norm) <- c("Home Team", "Away Team", "Home Team Odds", "Away Team Odds")

write.csv("Week_5_Predictions_SoS.csv", x = model_results_SoS)
write.csv("Week_5_Predictions_SoS_norm.csv", x = model_results_SoS_norm)
write.csv("Week_5_Predictions_SoS_adj.csv", x = model_results_SoS_adj)
write.csv("Week_5_Predictions_SoS_FPI.csv", x = model_results_FPI_SoS)