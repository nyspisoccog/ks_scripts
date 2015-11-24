#!/bin/bash

export FREESURFER_HOME=/usr/local/freesurfer
echo "starting freesurfer"
echo $FREESURFER_HOME
export SUBJECTS_DIR="/media/katie/PanicPTSD/data/anat_data/Panic/proc_data"
source $FREESURFER_HOME/SetUpFreeSurfer.sh
echo $SUBJECTS_DIR


