#!/bin/bash

SRCDIR='~/lab/amy_raw'

host='192.168.71.250'
user='lab'
passwd='star2go'

destdir='/tmp'

list_exams=''


lftp "echo $dir for dir in $SRCDIR; " -u $user,$passwd $host

#for exam in 5384 5153 5261 5461 5662 5675 5746 6232 6660 6928 7355 7434 7468 7484 7899 7975 7996 8031 8124 8147 8150 8271 7974
    #do
    #for dir in 'find $SRCDIR -name $exam'
        #do
        #echo $dir
        #if [ -d $dir] ; then
        #destdirname=$dir
        #cd $DESTDIR
        #mkdir $destdirname
        #lftp -c "open -u $USER,$PASSWD sftp://$HOST ; mirror -R $dir,$DESTDIR"
        #fi


#lftp -e 'set net:timeout 10; get yourfile.mp4 -o /local/path/yourfile.mp4; bye' -u user,password ftp.foo.com

EOF
