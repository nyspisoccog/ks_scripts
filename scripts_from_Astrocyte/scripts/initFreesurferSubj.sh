
echo "Please enter the subject number (unprocessed)"
read subj_no
echo "You entered: $subj_no"

: <<'END'
This is how you comment out a block of text
END

set `find /home/astrocyte/Desktop/BulimiaSubjects/$subj_no/* -maxdepth 1 -type d`
echo $1 
 echo $2

a=$1
b=$2


set `find $a/* -maxdepth 0`
echo $1
c=$1

set `find $b/* -maxdepth 0`
echo $1
d=$1



recon-all -i $c -i $d -subjid s$subj_no











