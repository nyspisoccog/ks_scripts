dirList = dir('/ifs/scratch/pimri/soccog/7412/anat/s1353221_160_s12/dicoms');
for i=1:length(dirList)
   %check if not directory
   if ~dirList(i).isdir
       %check if dicom file
       str=dirList(i).name;
       extension=[str(length(str)-2) str(length(str)-1) str(length(str))];
       if extension == 'dcm'
           info=dicominfo(['/ifs/scratch/pimri/soccog/7412/anat/s1353221_160_s12/dicoms/' dirList(i).name]);
           info.StudyDate='00000000';
           info.SeriesDate='00000000';
           info.AcquisitionDate='00000000';
           info.ContentDate='00000000';
           info.InstitutionName='anon';
           info.InstitutionAddress='anon';
           info.StationName='anon';
           info.StudyDescription='anon';
           info.PerformingPhysicianName.FamilyName='anon';
           info.OperatorName.FamilyName='anon';
           info.PatientName.FamilyName='anon';
           info.PatientID='anon';
           info.PatientBirthDate='00000000';
           info.PatientAge='000Y';
           info.DeviceSerialNumber='00000';
           info.RequestedProcedureDescription='anon';
           info.PerformedProcedureStepStartDate='00000000';
           info.PerformedProcedureStepStartTime='000000.000000';
           info.PerformedProcedureStepID='0000000000';
           info.DateOfLastCalibration='0000000000';
           info.BitDepth=12;
           info.BitsStored=12;
           info.HighBit=11;
           d=dicomread(['/ifs/scratch/pimri/soccog/7412/anat/s1353221_160_s12/dicoms/' dirList(i).name]);
           mkdir('/ifs/scratch/pimri/soccog/7412/anat/s1353221_160_s12/dicoms/anonout');
           dicomwrite(d, ['/ifs/scratch/pimri/soccog/7412/anat/s1353221_160_s12/dicoms/anonout/' dirList(i).name], info, 'createmode', 'copy', 'BitDepth', 12, 'BitsStored', 12, 'HighBit', 11);
       end
   end
end
exit()