import mechanize
import csv
from bs4 import BeautifulSoup
import bs4

class Member(object):
    def __init__(self, PPID=None):
        self.street = ''
        self.city = ''
        self.borough
         
def mem_init():
    s = Member()
    return s

zipdict = \
    {'10001': 'Manhattan', '10002': 'Manhattan', '10003': 'Manhattan', '10004': 'Manhattan', '10005': 'Manhattan', \
    '10006': 'Manhattan', '10007': 'Manhattan', '10009': 'Manhattan', '10010': 'Manhattan', '10011': 'Manhattan', \
    '10012': 'Manhattan', '10013': 'Manhattan', '10014': 'Manhattan', '10015': 'Manhattan', '10016': 'Manhattan', \
    '10017': 'Manhattan', '10018': 'Manhattan', '10019': 'Manhattan', '10020': 'Manhattan', '10021': 'Manhattan', \
    '10022': 'Manhattan', '10023': 'Manhattan', '10024': 'Manhattan', '10025': 'Manhattan', '10026': 'Manhattan', \
    '10027': 'Manhattan', '10028': 'Manhattan', '10029': 'Manhattan', '10030': 'Manhattan', '10031': 'Manhattan', \
    '10032': 'Manhattan', '10033': 'Manhattan', '10034': 'Manhattan', '10035': 'Manhattan', '10036': 'Manhattan', \
    '10037': 'Manhattan', '10038': 'Manhattan', '10039': 'Manhattan', '10040': 'Manhattan', '10041': 'Manhattan', \
    '10044': 'Manhattan', '10045': 'Manhattan', '10048': 'Manhattan', '10055': 'Manhattan', '10060': 'Manhattan', \
    '10069': 'Manhattan', '10075': 'Manhattan', '10090': 'Manhattan', '10095': 'Manhattan', '10098': 'Manhattan', '10099': 'Manhattan', \
    '10103': 'Manhattan', '10104': 'Manhattan', '10105': 'Manhattan', '10106': 'Manhattan', '10107': 'Manhattan', \
    '10110': 'Manhattan', '10111': 'Manhattan', '10112': 'Manhattan', '10115': 'Manhattan', '10118': 'Manhattan', \
    '10119': 'Manhattan', '10120': 'Manhattan', '10121': 'Manhattan', '10122': 'Manhattan', '10123': 'Manhattan', \
    '10128': 'Manhattan', '10151': 'Manhattan', '10152': 'Manhattan', '10153': 'Manhattan', '10154': 'Manhattan', \
    '10155': 'Manhattan', '10158': 'Manhattan', '10161': 'Manhattan', '10162': 'Manhattan', '10165': 'Manhattan', \
    '10166': 'Manhattan', '10167': 'Manhattan', '10168': 'Manhattan', '10169': 'Manhattan', '10170': 'Manhattan', \
    '10171': 'Manhattan', '10172': 'Manhattan', '10173': 'Manhattan', '10174': 'Manhattan', '10175': 'Manhattan', \
    '10176': 'Manhattan', '10177': 'Manhattan', '10178': 'Manhattan', '10199': 'Manhattan', '10270': 'Manhattan', \
    '10271': 'Manhattan', '10278': 'Manhattan', '10279': 'Manhattan', '10280': 'Manhattan', '10281': 'Manhattan', \
    '10282': 'Manhattan', '10301': 'Staten', '10302': 'Staten', '10303': 'Staten', '10304': 'Staten', \
    '10305': 'Staten', '10306': 'Staten', '10307': 'Staten', '10308': 'Staten', '10309': 'Staten', \
    '10310': 'Staten', '10311': 'Staten', '10312': 'Staten', '10314': 'Staten', '10451': 'Bronx', \
    '10452': 'Bronx', '10453': 'Bronx', '10454': 'Bronx', '10455': 'Bronx', '10456': 'Bronx', \
    '10457': 'Bronx', '10458': 'Bronx', '10459': 'Bronx', '10460': 'Bronx', '10461': 'Bronx', \
    '10462': 'Bronx', '10463': 'Bronx', '10464': 'Bronx', '10465': 'Bronx', '10466': 'Bronx', \
    '10467': 'Bronx', '10468': 'Bronx', '10469': 'Bronx', '10470': 'Bronx', '10471': 'Bronx', \
    '10472': 'Bronx', '10473': 'Bronx', '10474': 'Bronx', '10475': 'Bronx', '11004': 'Queens', \
    '11101': 'Queens', '11102': 'Queens', '11103': 'Queens', '11104': 'Queens', '11105': 'Queens', \
    '11106': 'Queens', '11109': 'Queens', '11201': 'Brooklyn', '11203': 'Brooklyn', '11204': 'Brooklyn', \
    '11205': 'Brooklyn', '11206': 'Brooklyn', '11207': 'Brooklyn', '11208': 'Brooklyn', '11209': 'Brooklyn', \
    '11210': 'Brooklyn', '11211': 'Brooklyn', '11212': 'Brooklyn', '11213': 'Brooklyn', '11214': 'Brooklyn', \
    '11215': 'Brooklyn', '11216': 'Brooklyn', '11217': 'Brooklyn', '11218': 'Brooklyn', '11219': 'Brooklyn', \
    '11220': 'Brooklyn', '11221': 'Brooklyn', '11222': 'Brooklyn', '11223': 'Brooklyn', '11224': 'Brooklyn', \
    '11225': 'Brooklyn', '11226': 'Brooklyn', '11228': 'Brooklyn', '11229': 'Brooklyn', '11230': 'Brooklyn', \
    '11231': 'Brooklyn', '11232': 'Brooklyn', '11233': 'Brooklyn', '11234': 'Brooklyn', '11235': 'Brooklyn', \
    '11236': 'Brooklyn', '11237': 'Brooklyn', '11238': 'Brooklyn', '11239': 'Brooklyn', '11241': 'Brooklyn', \
    '11242': 'Brooklyn', '11243': 'Brooklyn', '11249': 'Brooklyn', '11252': 'Brooklyn', '11256': 'Brooklyn', \
    '11351': 'Queens', '11354': 'Queens', '11355': 'Queens', '11356': 'Queens', '11357': 'Queens', \
    '11358': 'Queens', '11359': 'Queens', '11360': 'Queens', '11361': 'Queens', '11362': 'Queens', \
    '11363': 'Queens', '11364': 'Queens', '11365': 'Queens', '11366': 'Queens', '11367': 'Queens', \
    '11368': 'Queens', '11369': 'Queens', '11370': 'Queens', '11371': 'Queens', '11372': 'Queens', \
    '11373': 'Queens', '11374': 'Queens', '11375': 'Queens', '11377': 'Queens', '11378': 'Queens', \
    '11379': 'Queens', '11385': 'Queens', '11411': 'Queens', '11412': 'Queens', '11413': 'Queens', \
    '11414': 'Queens', '11415': 'Queens', '11416': 'Queens', '11417': 'Queens', '11418': 'Queens', \
    '11419': 'Queens', '11420': 'Queens', '11421': 'Queens', '11422': 'Queens', '11423': 'Queens', \
    '11426': 'Queens', '11427': 'Queens', '11428': 'Queens', '11429': 'Queens', '11430': 'Queens', \
    '11432': 'Queens', '11433': 'Queens', '11434': 'Queens', '11435': 'Queens', '11436': 'Queens', \
    '11691': 'Queens', '11692': 'Queens', '11693': 'Queens', '11694': 'Queens', '11697': 'Queens', \
    '10451': 'Bronx', '10452': 'Bronx', '10453': 'Bronx', '10454': 'Bronx', '10455': 'Bronx', \
    '10456': 'Bronx', '10457': 'Bronx', '10458': 'Bronx', '10459': 'Bronx', '10460': 'Bronx', \
    '10461': 'Bronx', '10462': 'Bronx', '10463': 'Bronx', '10464': 'Bronx', '10465': 'Bronx', \
    '10466': 'Bronx', '10467': 'Bronx', '10468': 'Bronx', '10469': 'Bronx', '10470': 'Bronx', \
    '10471': 'Bronx', '10472': 'Bronx', '10473': 'Bronx', '10474': 'Bronx', '10475': 'Bronx', \
    '11201': 'Brooklyn', '11203': 'Brooklyn', '11204': 'Brooklyn', '11205': 'Brooklyn', '11206': 'Brooklyn', \
    '11207': 'Brooklyn', '11208': 'Brooklyn', '11209': 'Brooklyn', '11210': 'Brooklyn', '11211': 'Brooklyn', \
    '11212': 'Brooklyn', '11213': 'Brooklyn', '11214': 'Brooklyn', '11215': 'Brooklyn', '11216': 'Brooklyn', \
    '11217': 'Brooklyn', '11218': 'Brooklyn', '11219': 'Brooklyn', '11220': 'Brooklyn', '11221': 'Brooklyn', \
    '11222': 'Brooklyn', '11223': 'Brooklyn', '11224': 'Brooklyn', '11225': 'Brooklyn', '11226': 'Brooklyn', \
    '11228': 'Brooklyn', '11229': 'Brooklyn', '11230': 'Brooklyn', '11231': 'Brooklyn', '11232': 'Brooklyn', \
    '11233': 'Brooklyn', '11234': 'Brooklyn', '11235': 'Brooklyn', '11236': 'Brooklyn', '11237': 'Brooklyn', \
    '11238': 'Brooklyn', '11239': 'Brooklyn', '11241': 'Brooklyn', '11242': 'Brooklyn', '11243': 'Brooklyn', \
    '11249': 'Brooklyn', '11252': 'Brooklyn', '11256': 'Brooklyn', '10001': 'Manhattan', '10002': 'Manhattan', \
    '10003': 'Manhattan', '10004': 'Manhattan', '10005': 'Manhattan', '10006': 'Manhattan', '10007': 'Manhattan', \
    '10009': 'Manhattan', '10010': 'Manhattan', '10011': 'Manhattan', '10012': 'Manhattan', '10013': 'Manhattan', \
    '10014': 'Manhattan', '10015': 'Manhattan', '10016': 'Manhattan', '10017': 'Manhattan', '10018': 'Manhattan', \
    '10019': 'Manhattan', '10020': 'Manhattan', '10021': 'Manhattan', '10022': 'Manhattan', '10023': 'Manhattan', \
    '10024': 'Manhattan', '10025': 'Manhattan', '10026': 'Manhattan', '10027': 'Manhattan', '10028': 'Manhattan', \
    '10029': 'Manhattan', '10030': 'Manhattan', '10031': 'Manhattan', '10032': 'Manhattan', '10033': 'Manhattan', \
    '10034': 'Manhattan', '10035': 'Manhattan', '10036': 'Manhattan', '10037': 'Manhattan', '10038': 'Manhattan', \
    '10039': 'Manhattan', '10040': 'Manhattan', '10041': 'Manhattan', '10044': 'Manhattan', '10045': 'Manhattan', \
    '10048': 'Manhattan', '10055': 'Manhattan', '10060': 'Manhattan', '10069': 'Manhattan', '10090': 'Manhattan', \
    '10095': 'Manhattan', '10098': 'Manhattan', '10099': 'Manhattan', '10103': 'Manhattan', '10104': 'Manhattan', \
    '10105': 'Manhattan', '10106': 'Manhattan', '10107': 'Manhattan', '10110': 'Manhattan', '10111': 'Manhattan', \
    '10112': 'Manhattan', '10115': 'Manhattan', '10118': 'Manhattan', '10119': 'Manhattan', '10120': 'Manhattan', \
    '10121': 'Manhattan', '10122': 'Manhattan', '10123': 'Manhattan', '10128': 'Manhattan', '10151': 'Manhattan', \
    '10152': 'Manhattan', '10153': 'Manhattan', '10154': 'Manhattan', '10155': 'Manhattan', '10158': 'Manhattan', \
    '10161': 'Manhattan', '10162': 'Manhattan', '10165': 'Manhattan', '10166': 'Manhattan', '10167': 'Manhattan', \
    '10168': 'Manhattan', '10169': 'Manhattan', '10170': 'Manhattan', '10171': 'Manhattan', '10172': 'Manhattan', \
    '10173': 'Manhattan', '10174': 'Manhattan', '10175': 'Manhattan', '10176': 'Manhattan', '10177': 'Manhattan', \
    '10178': 'Manhattan', '10199': 'Manhattan', '10270': 'Manhattan', '10271': 'Manhattan', '10278': 'Manhattan', \
    '10279': 'Manhattan', '10280': 'Manhattan', '10281': 'Manhattan', '10282': 'Manhattan', '11101': 'Queens', \
    '11102': 'Queens', '11103': 'Queens', '11004': 'Queens', '11104': 'Queens', '11105': 'Queens', \
    '11106': 'Queens', '11109': 'Queens', '11351': 'Queens', '11354': 'Queens', '11355': 'Queens', \
    '11356': 'Queens', '11357': 'Queens', '11358': 'Queens', '11359': 'Queens', '11360': 'Queens', \
    '11361': 'Queens', '11362': 'Queens', '11363': 'Queens', '11364': 'Queens', '11365': 'Queens', \
    '11366': 'Queens', '11367': 'Queens', '11368': 'Queens', '11369': 'Queens', '11370': 'Queens', \
    '11371': 'Queens', '11372': 'Queens', '11373': 'Queens', '11374': 'Queens', '11375': 'Queens', \
    '11377': 'Queens', '11378': 'Queens', '11379': 'Queens', '11385': 'Queens', '11411': 'Queens', \
    '11412': 'Queens', '11413': 'Queens', '11414': 'Queens', '11415': 'Queens', '11416': 'Queens', \
    '11417': 'Queens', '11418': 'Queens', '11419': 'Queens', '11420': 'Queens', '11421': 'Queens', \
    '11422': 'Queens', '11423': 'Queens', '11426': 'Queens', '11427': 'Queens', '11428': 'Queens', \
    '11429': 'Queens', '11430': 'Queens', '11432': 'Queens', '11433': 'Queens', '11434': 'Queens', \
    '11435': 'Queens', '11436': 'Queens', '11691': 'Queens', '11692': 'Queens', '11693': 'Queens', \
    '11694': 'Queens', '11697': 'Queens', '10301': 'Staten', '10302': 'Staten', '10303': 'Staten', \
    '10304': 'Staten', '10305': 'Staten', '10306': 'Staten', '10307': 'Staten', '10308': 'Staten', \
    '10309': 'Staten', '10310': 'Staten', '10311': 'Staten', '10312': 'Staten', '10314': 'Staten'}


borough_dict = {'Manhattan':['1'], 'Bronx':['2'], 'Brooklyn':['3'], 'Queens':['4'], 'Staten':['5']}

fname = '/home/katie/Documents/CallListForTwitter.csv'

records = []



with open(fname, 'rb') as csvfile:
    reader = csv.DictReader(csvfile, dialect='excel', delimiter=',')
    for row in reader:
        print row
        street = row['Street(supporter)']
        city = row['City(supporter)']
        zipcode = row['Zip(supporter)'][0:5]
        try:
            borough = zipdict[zipcode]
        except KeyError, e:
            print "Are you sure ", e, " is an NYC zip code?"
            borough = 'NotNYC'
            council = 'None'
            print row
            continue
        br = mechanize.Browser()
        br.open("http://council.nyc.gov/html/members/members.shtml")
        br.select_form('member_lookup')
        br['lookup_address'] = street
        br['lookup_borough'] = borough_dict[borough]
        for j in range(25):
            try:
                req = br.submit()
                break
            except:
                pass
        ans = req.read()
        soup = BeautifulSoup(ans)
        #print row['First']
        #print row['Last']
        #print street
        #print city
        #print zipcode
        #print borough
        #print borough_dict[borough]
        soup.findAll 
        for td in soup.findAll('td', attrs={'class': 'inside_top_text'}):
            try:
                council =  ''.join([x for x in td.h1.contents \
                                 if isinstance(x, bs4.element.NavigableString)])
            except AttributeError, e:
                try:
                    council = ''.join([x for x in td.em.contents \
                                 if isinstance(x, bs4.element.NavigableString)])
                except AttributeError, f:
                    print f
                    council = 'None'

        line = row
        line['Council'] = council
        records.append(line)

outfile = '/home/katie/Downloads/TwitterRalleyListCouncil.csv'

with open(outfile,'w') as fou:
    fieldnames=reader.fieldnames
    fieldnames.append('Council')
    print fieldnames
    dw = csv.DictWriter(fou, delimiter=',', dialect='excel', fieldnames=reader.fieldnames)
    dw.writerow(dict((fn,fn) for fn in reader.fieldnames))
    for row in records:
        dw.writerow(row)       
