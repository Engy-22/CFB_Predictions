from bs4 import BeautifulSoup
import requests
import csv



'''
Scrape Rushing/Passing Offense/Defense Stats by Conference
'''

conferences = ['905', '823', '821', '25354', '827', '24312', '99001', '875', '5486', '911', '818']
rush_off = 'Rush_Off_'
rush_off_headers =  ['Rank','Name','G','Att', 'Yards','Avg','TD',  'Att/G','Rush Offense Yards/G']

# pass_off = 'Pass_Off.csv'
pass_off = 'Pass_Off_'
pass_off_headers = ['Rank','Name', 'G', 'Att', 'Comp', 'Pct', 'Yards', 'Yards/Att', 'TD',  'Int', 'Rating',  'Att/G', 'Pass Offense Yards/G']

# rush_def = 'Rush_Def.csv'
rush_def = 'Rush_Def_'
rush_def_headers = ['Rank','Name','G', 'Att', 'Yards', 'Avg', 'TD', 'Att/G', 'Rush Defense Yards/G']

# pass_def = 'Pass_Def.csv'
pass_def = 'Pass_Def_'
pass_def_headers = ['Rank', 'Name', 'G', 'Att', 'Comp', 'Pct.', 'Yards', 'Yards/Att', 'TD', 'Int', 'Rating', 'Att/G', 'Pass Defense Yards/G']

# turnover_margin = 'Turnover_Margin.csv'
turnover_margin = 'Turnover_Margin_'
turnover_margin_headers = [ 'Rank', 'Name', 'G',   'Fum. Gain',   'Int. Gain',   'Total Gain',  'Fum. Lost', 'Int. Lost', 'Total Lost',  'Margin',  'Margin/G']

# scoring_offense = 'Scoring_Off.csv'
scoring_offense = 'Scoring_Off_'
scoring_offense_headers = ['Rank', 'Name', 'G', 'TD',  'FG',  '1XP', '2XP', 'Safety',  'Points',  'Points/G']

stats_list = [ scoring_offense, rush_off, rush_def, pass_def, pass_off, turnover_margin]
stat_list_headers = [rush_off_headers, rush_def_headers, pass_def_headers, pass_off_headers, turnover_margin_headers, scoring_offense_headers]

years = ['2008','2009','2010','2011','2012','2013','2014', '2015']


for year in years:
    print year
    with open(rush_off+year+'.csv', 'wb+') as csv_file:
        writer = csv.DictWriter(csv_file, fieldnames = rush_off_headers, delimiter = ',')
        writer.writeheader()
        writer = csv.writer(csv_file)
        for conference in conferences:
            url = "http://www.cfbstats.com/"+year+"/leader/"+conference+"/team/offense/split20/category01/sort01.html" #VS FBS TEAMS ONLY
            # url = 'http://www.cfbstats.com/' +year +'/leader/' + conference +'/team/offense/split01/category01/sort01.html' #VS ALL TEAMS
                
            r  = requests.get(url)

            data = r.text

            soup = BeautifulSoup(data, "html.parser")

            table = soup.find('table')
            # print conference + " rush offense done"
            for trs in table.find_all('tr'):
                tds = trs.find_all('td')
                row = [elem.text.strip().encode('utf-8') for elem in tds]
                #final_data.append(row)
                writer.writerow(row)
        print "rush offense done"


    with open(pass_off+year+'.csv', 'wb+') as csv_file:
        writer = csv.DictWriter(csv_file, fieldnames = pass_off_headers, delimiter = ',')
        writer.writeheader()
        writer = csv.writer(csv_file)
        for conference in conferences:
            url = 'http://www.cfbstats.com/'+year +'/leader/' + conference +'/team/offense/split20/category02/sort01.html' #VS FBS TEAMS ONLY
            # url = 'http://www.cfbstats.com/'+year +'/leader/' + conference +'/team/offense/split01/category02/sort01.html' #VS ALL TEAMS
                
            r  = requests.get(url)

            data = r.text

            soup = BeautifulSoup(data, "html.parser")

            table = soup.find('table')
            # print conference + " pass offense done"
            for trs in table.find_all('tr'):
                tds = trs.find_all('td')
                row = [elem.text.strip().encode('utf-8') for elem in tds]
                #final_data.append(row)
                writer.writerow(row)
        print "pass offense done"


    with open(rush_def+year+'.csv', 'wb+') as csv_file:
        writer = csv.DictWriter(csv_file, fieldnames = rush_def_headers, delimiter = ',')
        writer.writeheader()
        writer = csv.writer(csv_file)
        for conference in conferences:
            #Vs. FBS Teams only
            url = 'http://www.cfbstats.com/'+year +'/leader/' + conference +'/team/defense/split20/category01/sort01.html'
            # url = 'http://www.cfbstats.com/'+year +'/leader/' + conference +'/team/defense/split01/category01/sort01.html'
                
            r  = requests.get(url)

            data = r.text

            soup = BeautifulSoup(data, "html.parser")

            table = soup.find('table')
            #print conference + " rush defense done"
            for trs in table.find_all('tr'):
                tds = trs.find_all('td')
                row = [elem.text.strip().encode('utf-8') for elem in tds]
                #final_data.append(row)
                writer.writerow(row)
        print "rush defense done"


    #team/defense/split01/category02/sort01.html
    with open(pass_def+year+'.csv', 'wb+') as csv_file:
        writer = csv.DictWriter(csv_file, fieldnames = pass_def_headers, delimiter = ',')
        writer.writeheader()
        writer = csv.writer(csv_file)
        for conference in conferences:
            #Vs. FBS Teams only
            url = 'http://www.cfbstats.com/'+year +'/leader/' + conference +'/team/defense/split20/category02/sort01.html'

            #All Teams
            # url = 'http://www.cfbstats.com/'+year +'/leader/' + conference +'/team/defense/split01/category02/sort01.html'
                
            r  = requests.get(url)

            data = r.text

            soup = BeautifulSoup(data, "html.parser")

            table = soup.find('table')
            #print conference + " pass defense done"
            for trs in table.find_all('tr'):
                tds = trs.find_all('td')
                row = [elem.text.strip().encode('utf-8') for elem in tds]
                #final_data.append(row)
                writer.writerow(row)
        print "pass defense done"

    #http://www.cfbstats.com/2014/leader/905/team/offense/split01/category12/sort01.html


    with open(turnover_margin+year+'.csv', 'wb+') as csv_file:
        writer = csv.DictWriter(csv_file, fieldnames = turnover_margin_headers, delimiter = ',')
        writer.writeheader()
        writer = csv.writer(csv_file)
        for conference in conferences:
            url = 'http://www.cfbstats.com/'+year +'/leader/' + conference +'/team/offense/split20/category12/sort01.html' #VS FBS TEAMS ONLY

            # url = 'http://www.cfbstats.com/'+year +'/leader/' + conference +'/team/offense/split01/category12/sort01.html' #VS ALL TEAMS
                
            r  = requests.get(url)

            data = r.text

            soup = BeautifulSoup(data, "html.parser")

            table = soup.find('table')
            for trs in table.find_all('tr'):
                tds = trs.find_all('td')
                row = [elem.text.strip().encode('utf-8') for elem in tds]
                writer.writerow(row)
        print "turnover margin done"

    #http://www.cfbstats.com/2014/leader/823/team/offense/split01/category09/sort01.html

    with open(scoring_offense+year+'.csv', 'wb+') as csv_file:
        writer = csv.DictWriter(csv_file, fieldnames = scoring_offense_headers, delimiter = ',')
        writer.writeheader()
        writer = csv.writer(csv_file)
        for conference in conferences:
            url = 'http://www.cfbstats.com/'+year +'/leader/' + conference +'/team/offense/split20/category09/sort01.html' #VS FBS TEAMS ONLY
            # url = 'http://www.cfbstats.com/'+year +'/leader/' + conference +'/team/offense/split01/category09/sort01.html' #VS ALL TEAMS
                
            r  = requests.get(url)

            data = r.text

            soup = BeautifulSoup(data, "html.parser")

            table = soup.find('table')
            for trs in table.find_all('tr'):
                tds = trs.find_all('td')
                row = [elem.text.strip().encode('utf-8') for elem in tds]
                writer.writerow(row)
        print "scoring offense done"
