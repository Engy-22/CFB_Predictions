from bs4 import BeautifulSoup
import requests
import csv


schedule_2014 = '2014_Schedule.csv'
schedule_2014_headers = ['Rk', 'Wk', 'Date', 'Time', 'Day', 'Winner/Tie',  'Winner Pts', 'Home/Away',  'Loser/Tie', 'Loser Pts', 
                            'TV',  'Notes']
schedule_2014_url = 'http://www.sports-reference.com/cfb/years/2014-schedule.html'

schedule_2015 = '2015_Schedule.csv'
schedule_2015_headers = ['Rk', 'Wk', 'Date', 'Time', 'Day', 'Winner/Tie',  'Winner Pts', 'Home/Away',  'Loser/Tie', 'Loser Pts', 
                            'TV',  'Notes']
schedule_2015_url = 'http://www.sports-reference.com/cfb/years/2015-schedule.html'

years = ['2008','2009','2010','2011','2012','2013','2014']





with open(schedule_2014, 'wb+') as csv_file:
    writer = csv.DictWriter(csv_file, fieldnames = schedule_2014_headers, delimiter = ',')
    writer.writeheader()

    writer = csv.writer(csv_file)

    url = schedule_2014_url
        
    r  = requests.get(url)


    data = r.text
    #print data

    soup = BeautifulSoup(data, "html.parser")
    table = soup.find('table', {'class': 'sortable  stats_table'})
    #print table

    for trs in table.find_all('tr'):
        tds = trs.find_all('td')
        row = [elem.text.strip().encode('utf-8') for elem in tds]
        #final_data.append(row)
        writer.writerow(row)

with open(schedule_2015, 'wb+') as csv_file:
    writer = csv.DictWriter(csv_file, fieldnames = schedule_2015_headers, delimiter = ',')
    writer.writeheader()

    writer = csv.writer(csv_file)

    url = schedule_2015_url
        
    r  = requests.get(url)


    data = r.text

    soup = BeautifulSoup(data, "html.parser")
    table = soup.find('table', {'class': 'sortable  stats_table'})

    for trs in table.find_all('tr'):
        tds = trs.find_all('td')
        row = [elem.text.strip().encode('utf-8') for elem in tds]
        writer.writerow(row)