import re, mechanize, csv
from bs4 import BeautifulSoup

##login = raw_input("login: ")
##pw = raw_input("password: ")

login = "superlab"
pw = "newpi69"

br = mechanize.Browser()
br.open('http://192.168.71.211:8000/admin/ppid/person/')
br.select_form(nr=0)
br["username"] = login
br["password"] = pw
response1 = br.submit()

PPIDs = ['BDGWQV', 'LOFXHT', 'TQETMR', 'JONEGQ', 'QATKNZ', 'RFJORG', 'GGBATA',\
         'EUYTGK', 'PGHJHN', 'RCUESE', 'TSDQIX', 'VDSVAT', 'PXNNOZ', 'HJPUPS',\
         'YTNRVG', 'YZSQSR', 'TSRVOD', 'DSDWZA', 'MKNFAR', 'FODTFR', 'LEGWYW',\
         'AFUWNP', 'ZCGPXI', 'FCQJTU', 'JXMQLI', 'DQVDJK', 'PIOGDD', 'FQFLQT',\
         'XLWHED', 'NHWNQO', 'CIMITU', 'UUIWUF', 'BDGWQV', 'UUIWUF', 'OKKANN',\
         'NHWNQO', 'EVXZHS', 'ZGXDAF', 'QQSVBH', 'IJLPEV', 'ESKKPX', 'POPXUN',\
         'OZVIDL', 'VABAKV', 'LKPGQM', 'ZLVWZH', 'URHDVU', 'WKPYIV', 'ZMGULT',\
         'VWJJKU', 'YNDJGW', 'LNIMCU', 'XRXOLK', 'PXUBDT', 'CVWMPU', 'JNWOGT',\
         'SNPOGY', 'SUSTFV', 'GLVSLW', 'OYWXGS', 'DIKWHZ', 'GSTCVV', 'UZHBTY',\
         'VJRYJY', 'XTLGUG', 'RMCCMB', 'PUTXQU', 'CYIALU', 'JVZYPY', 'IPUGCV']


for PPID in PPIDs:
    br.select_form(nr=0)
    br["q"] = PPID
    response2 = br.submit()
    page2 = response2.read()
    soup2 = BeautifulSoup(page2)
    tag_list = []
    [tag_list.append(t) for t in soup2.find_all('td')]
    first = tag_list[1].get_text()
    last = tag_list[2].get_text()
    text = soup2.get_text()
    text = text.split()
    print PPID, "\t", first, "\t", last
    for i, t in enumerate(text):
        if "Created By" in t:
            newPPID = t[i+1][0:6]
            break
br.back()

