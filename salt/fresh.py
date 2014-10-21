#!/usr/bin/python
# -*- coding: utf-8 -*-

import requests
import time
import urllib2
import re
import BeautifulSoup
#you need to install BeautifulSoup and requests modules from http://pypi.python.org/ manuelly

def main():
    url = 'http://www.sojiang.com/login.aspx'
    headers = {'content-type': 'application/x-www-form-urlencoded'}
    
    #use requests to keep the cookies
    session = requests.Session()
    response = session.get(url, headers=headers)
    
    #use beautifulsoup module to retrieve hidden postdata __VIEWSTATE and __EVENTVALIDATION
    soup = BeautifulSoup.BeautifulSoup(response.content)
    
    postdata = {
        '__VIEWSTATE': soup.find('input', id='__VIEWSTATE')['value'],
        '__EVENTVALIDATION': soup.find('input', id='__EVENTVALIDATION')['value'],
        'ctl00$ContentPlaceHolder1$UserName1': 'baixuan',
        'ctl00$ContentPlaceHolder1$Password1': '19810130',
        'ctl00$ContentPlaceHolder1$RememberMe1': 'on',
        'ctl00$ContentPlaceHolder1$LoginButton1.x': '46',
        'ctl00$ContentPlaceHolder1$LoginButton1.y': '0'
    }
    
    #login to the site
    response = session.post(url, data=postdata, headers=headers)
    print response
    search_file_write(response)
    
    #get the award survey page content
    output = session.get('http://www.sojiang.com/awardsurvey.aspx')
    print output
    search_file_write(output)
    respHtml = output.text
    #print respHtml
    #print type(respHtml)
    
    #check the webpage whether there have some survey
    #href="http://www.sojump.com/jq/3803790.aspx?sjuser=L8BqIhSvTUM%3d" target="_blank">问卷调查3803790</a>
    found_survey = re.search(u'http://www.sojump.com/jq/\d{7}.aspx\?sjuser=.{14}', respHtml)    
    #foundH1user = re.search(u'>问卷调查\d*</a>', respHtml)
    #print "found survey =",found_survey
    
    if(found_survey):
        #print the search result
        print "\033[1;32;40mThere have a new survey !\033[0m"
        survey_link = found_survey.group(0)
        print "URL=",survey_link
        #search_file_write(h1user)
    else:
        print "\033[1;31;40mno survey found.\033[0m"


def search_file_write(find_url):
    spath = "record.txt"
    f = open(spath,'a')
    f.write(u"%s  \n"  %find_url)
    f.close()

if __name__=="__main__":
    while True:
        main()
        time.sleep(300)
