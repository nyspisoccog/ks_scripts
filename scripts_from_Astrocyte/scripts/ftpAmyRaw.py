import ftplib, os, sys, time, re
from datetime import datetime

exam_list = ['5384', '5153', '5261', '5461', '5662', '5675', '5746',
             '6232', '6660', '6928', '7355', '7434', '7468', '7484',
             '7899', '7975', '7996', '8031', '8124', '8147', '8150',
             '8271', '7974']

"""
ftpwalk -- Walk a hierarchy of files using FTP (Adapted from os.walk()).
"""

def ftpwalk(ftp, top, topdown=True, onerror=None):
    """
    Generator that yields tuples of (root, dirs, nondirs).
    """
    # Make the FTP object's current directory to the top dir.
    ftp.cwd(top)

    # We may not have read permission for top, in which case we can't
    # get a list of the files the directory contains.  os.path.walk
    # always suppressed the exception then, rather than blow up for a
    # minor reason when (say) a thousand readable directories are still
    # left to visit.  That logic is copied here.
    try:
        dirs, nondirs = _ftp_listdir(ftp)
    except os.error, err:
        if onerror is not None:
            onerror(err)
        return

    if topdown:
        yield top, dirs, nondirs
    for entry in dirs:
        dname = entry[0]
        path = os.path.join(top, dname)
        try:
            for x in ftpwalk(ftp, path, topdown, onerror):
                yield x
        except ftplib.error_perm:
            print path, ": not a directory"
    if not topdown:
        yield top, dirs, nondirs

_calmonths = dict( (x, i+1) for i, x in
                   enumerate(('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                              'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')) )

def _ftp_listdir(ftp):
    """
    List the contents of the FTP opbject's cwd and return two tuples of

       (filename, size, mtime, mode, link)

    one for subdirectories, and one for non-directories (normal files and other
    stuff).  If the path is a symbolic link, 'link' is set to the target of the
    link (note that both files and directories can be symbolic links).

    Note: we only parse Linux/UNIX style listings; this could easily be
    extended.
    """
    dirs, nondirs = [], []
    listing = []
    ftp.retrlines('LIST', listing.append)
    for line in listing:
        # Parse, assuming a UNIX listing
        words = line.split(None, 8)
        if len(words) < 6:
            print >> sys.stderr, 'Warning: Error reading short line', line
            continue

        # Get the filename.
        filename = words[-1].lstrip()
        if filename in ('.', '..'):
            continue

        # Get the link target, if the file is a symlink.
        extra = None
        i = filename.find(" -> ")
        if i >= 0:
            # words[0] had better start with 'l'...
            extra = filename[i+4:]
            filename = filename[:i]

        # Get the file size.
        size = int(words[4])

        # Get the date.
        year = datetime.today().year
        month = _calmonths[words[5]]
        day = int(words[6])
        mo = re.match('(\d+):(\d+)', words[7])
        if mo:
            hour, min = map(int, mo.groups())
        else:
            mo = re.match('(\d\d\d\d)', words[7])
            if mo:
                year = int(mo.group(1))
                hour, min = 0, 0
            else:
                raise ValueError("Could not parse time/year in line: '%s'" % line)
        dt = datetime(year, month, day, hour, min)
        mtime = time.mktime(dt.timetuple())

        # Get the type and mode.
        mode = words[0]

        entry = (filename, size, mtime, mode, extra)
        if mode[0] == 'd' or mode[0] == 'l':
            dirs.append(entry)
        else:
            nondirs.append(entry)
    return dirs, nondirs

def downloadFiles(path,destination):
#path & destination are str of the form "/dir/folder/something/"
#path should be the abs path to the root FOLDER of the file tree to download
    try:
        ftp.cwd(path)
        #clone path to destination
        os.chdir(destination)
        os.mkdir(destination[0:len(destination)-1]+path)
        print destination[0:len(destination)-1]+path+" built"
    except OSError:
        #folder already exists at destination
        pass
    except ftplib.error_perm:
        #invalid entry (ensure input form: "/dir/folder/something/")
        print "error: could not change to "+path
        sys.exit("ending session")

    #list children:
    filelist=ftp.nlst()

    for file in filelist:
        try:
            #this will check if file is folder:
            ftp.cwd(path+file+"/")
            #if so, explore it:
            downloadFiles(path+file+"/",destination)
        except ftplib.error_perm:
            #not a folder with accessible content
            #download & return
            os.chdir(destination[0:len(destination)-1]+path)
            #possibly need a permission exception catch:
            ftp.retrbinary("RETR "+file, open(os.path.join(destination,file),"wb").write)
            print file + " downloaded"
    return


path_list = []

ftp = ftplib.FTP('192.168.71.250', 'lab','star2go')

for root, dirs, nondirs in ftpwalk(ftp, '~/amy_raw/', topdown=True, onerror=None):
    for exam in exam_list:
        if exam in root:
            path_list.append(root)

for path in path_list:
    downloadFiles(path,'/tmp')
