import urllib, urllib2, re, mechanize

br = mechanize.Browser()

br.open("http://192.168.71.65/new_tracking/")

br.select_form(name="logon_form")

br["login"] = 'surrenc'
br["password"] = '2std.dev'

response1 = br.submit()

##values = {'login' : 'surrenc',
##          'password' : '2std.dev',
##          'B1': 'Log On'}

##data = urllib.urlencode(values)
##req = urllib2.Request(url, data)
##response = urllib2.urlopen(req)
the_page = response1.read()

print the_page

