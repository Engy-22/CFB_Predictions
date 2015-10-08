from bs4 import BeautifulSoup
import requests
import csv


espn_rankings_url_2015 = 'http://espn.go.com/college-football/statistics/teamratings'
espn_rankings_2015_week_1 = 'espn_power_ranking_2015'
espn_rankings_url_2014 = 'http://web.archive.org/web/20150131231156/http://espn.go.com/college-football/statistics/teamratings'
espn_rankings_2014 = 'espn_power_ranking_2014.csv'

with open(espn_rankings_2014, 'wb+') as csv_file:
    writer = csv.writer(csv_file)
    url = espn_rankings_url_2014
    r  = requests.get(url)
    data = r.text

    soup = BeautifulSoup(data, "html.parser")
    table = soup.find('table', class_ = "tablehead")
    tr = table.findAll('tr')
    for trs in tr:
        tds = trs.find_all('td')
        row = [elem.text.strip().encode('utf-8') for elem in tds]
        writer.writerow(row)




with open(espn_rankings_2015, 'wb+') as csv_file:
    writer = csv.writer(csv_file)

    url = espn_rankings_url_2015
        
    r  = requests.get(url)
    data = r.text
    soup = BeautifulSoup(data, "html.parser")
    tr = soup.findAll('tr')

    for trs in tr:
        tds = trs.find_all('td')
        row = [elem.text.strip().encode('utf-8') for elem in tds]
        writer.writerow(row)
