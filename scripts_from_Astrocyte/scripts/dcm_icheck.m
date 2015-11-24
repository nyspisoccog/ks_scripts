%DICOM HEADER CHECK

function [] = fix_file(dcmIN)

    str=dcmIN;
   % extension=[str(length(str)-2) str(length(str)-1) str(length(str))];
   % if extension == 'dcm'
        disp(['===DICOM HEADER INFORMATION: ' dcmIN ' ==='])
        info=dicominfo([dcmIN])
        disp('Patient Name');
        mat=info.PatientName
        mat=info.SoftwareVersion
   % end