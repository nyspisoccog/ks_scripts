"""eprime: class for working with eprime log files

Written for Python 3.2

Robert H. Olson, Ph.D., rolson@waisman.wisc.edu
January 10, 2012

"""
    

class LogData(object):
    """Read log (.txt) file produced by E-Prime

    a = eprime.LogData(logfilename)
    a.header # dictionary from header block
    a.blocks # list of dictionaries, one per LogFrame block
    
    """
    def __init__(self, eprime_filename):
        self.header = {} # empty dictionary
        self.blocks = [] # empty list
        self.readeprimelog(eprime_filename)
    
    def readeprimelog(self, fname):
        currdict = {}
        with open(fname, 'r') as epfile:
            epline = epfile.readline()
            while epline != '':
                epline = epline.strip()
                if epline.startswith('***'):
                    if epline == '*** Header Start ***':
                        currdict = self.header
                    elif epline == '*** Header End ***':
                        levelline = epfile.readline().strip()
                    elif epline == '*** LogFrame Start ***':
                        currdict = {} # new working dictionary
                        kv = levelline.split(': ', 1)
                        currdict[kv[0]] = kv[1]
                    elif epline == '*** LogFrame End ***':
                        self.blocks.append(currdict)
                        levelline = epfile.readline().strip()
                else:
                    # add a key:value pair to the current dictionary
                    kv = epline.split(': ', 1)
                    if len(kv) == 2:
                        currdict[kv[0]] = kv[1]
                    else:
                        currdict[kv[0]] = ''
                epline = epfile.readline()






                
