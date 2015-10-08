from bs4 import BeautifulSoup
import requests
import csv
import re
game_time_week_5 = 'game_time_week_5.csv'
game_time_week_6 = 'game_time_week_6.csv'
game_time_headers = ['Home_Team', "Away_Team", 'Time']
url = "http://www.foxsports.com/college-football/schedule?season=2015&seasonType=1&week=6&group=-3" #Change URL to match current week
all_teams = []
game_times = []


with open(game_time_week_6, 'wb+') as csv_file:
	writer = csv.DictWriter(csv_file, fieldnames = game_time_headers, delimiter = ',')
	writer.writeheader()
	writer = csv.writer(csv_file)

	r  = requests.get(url)
	data = r.text
	soup = BeautifulSoup(data, "html.parser")

	teams = soup.find_all('label',class_ = "wisfb_fullLocation")
	times = soup.find_all('div',class_ = "wisfb_primary")

	for team in teams:
		row = team.string 
		all_teams.append(row)


	for time in times:
		row = time.string 
		game_times.append(row)

	away_teams = all_teams[1:][::2]
	home_teams = all_teams[0:][::2]

	rows = zip(home_teams,away_teams,game_times)
	for row in rows:
		writer.writerow(row)