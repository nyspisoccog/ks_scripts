cd /media/katie/SocCog/
help asciiread
help acsvread
t = acsvread('7403', char(9), struct('asmatrix', 1, 'convert', true));
t(1:5,:)
t(:,2:2:end) = [];
t(1:20, :)
t = acsvread('7403', char(9), struct('asmatrix', 1, 'convert', false));
t(:,2:2:end) = [];
t(1:20, :)
t = acsvread('7403', char(9), struct('asmatrix', 1));
t(:,2:2:end) = [];
t(1:20, :)
tnum = ~isemptycell(regexp(t, '^\d+$'));
t(tnum) = cellfun(@str2num, t(tnum),
help cellfun
t(tnum) = cellfun(@str2num, t(tnum), 'UniformOutput', false);
t(1:20, :)
runs = unique(t(2:end,2))
edit
onsetfolder = '/media/katie/SocCog';
onsetfiles = findfiles(onsetfolder, '7*', 'depth=1');
onsetfiles
t(1,:)
prt = xff('new:prt')
prt.Help('AddCond')
unique(t(:, 3))
condcols = { ...
... % learning conditions
'SRneg',  [255,  64,  32]; ... %     significant, relevant,    negative
'SRpos',  [255,  32,  64]; ... %     significant, relevant,    positive
'SI',     [224,  96,  96]; ... %     significant, irrelevant,  no valence
'YRneg',  [ 64,  32, 255]; ... %     yoked,       relevant,    negative
'YRpos',  [ 32,  64, 255]; ... %     yoked,       relevant,    positive
'YI',     [ 96,  96, 224]; ... %     yoked,       irrelevant,  no valence
'NDneg',  [ 64, 224,  32]; ... % non-significant, descriptive, negative
'NDpos',  [ 32, 224,  64]; ... % non-significant, descriptive, positive
'NIneg',  [ 96, 192,  64]; ... % non-significant, irrelevant,  negative
'NIpos',  [ 64, 192,  96]; ... % non-significant, irrelevant,  positive
... % memory conditions
'STRneg', [224,  96,  64]; ... %     significant,     taught, relevant,    negative
'STRpos', [224,  64,  96]; ... %     significant,     taught, relevant,    positive
'STI',    [192, 128, 128]; ... %     significant,     taught, irrelevant,  no valence
'SNRneg', [192, 128,  96]; ... %     significant, not taught, relevant,    negative
'SNRpos', [192,  96, 128]; ... %     significant, not taught, relevant,    positive
'SNI',    [192, 160, 160]; ... %     significant, not taught, irrelevant,  no valence
'YTRneg', [ 96,  64, 224]; ... %     yoked,           taught, relevant,    negative
'YTRpos', [ 64,  96, 224]; ... %     yoked,           taught, relevant,    positive
'YTI',    [128, 128, 192]; ... %     yoked,           taught, irrelevant,  no valence
'YNRneg', [128,  96, 192]; ... %     yoked,       not taught, relevant,    negative
'YNRpos', [ 96, 128, 192]; ... %     yoked,       not taught, relevant,    positive
'YNI',    [160, 160, 192]; ... %     yoked,       not taught, irrelevant,  no valence
'NTDneg', [ 96, 224,  64]; ... % non-significant,     taught, descriptive, negative
'NTDpos', [ 64, 224,  96]; ... % non-significant,     taught, descriptive, positive
'NTIneg', [128, 192,  96]; ... % non-significant,     taught, irrelevant,  negative
'NTIpos', [ 96, 192, 128]; ... % non-significant,     taught, irrelevant,  positive
'NNDneg', [128, 160,  96]; ... % non-significant, not taught, descriptive, negative
'NNDpos', [ 96, 160, 128]; ... % non-significant, not taught, descriptive, positive
'NNIneg', [160, 128, 128]; ... % non-significant, not taught, irrelevant,  negative
'NNIpos', [128, 128, 160]; ... % non-significant, not taught, irrelevant,  positive
};
help colorpicker
colorpicker(cat(1, condcols{:,2}), condcols(:,1))
condcols = { ...
... % learning conditions
'SRneg',  [255,  80,   0]; ... %     significant, relevant,    negative
'SRpos',  [255,   0,  80]; ... %     significant, relevant,    positive
'SI',     [224,  96,  96]; ... %     significant, irrelevant,  no valence
'YRneg',  [ 80,   0, 255]; ... %     yoked,       relevant,    negative
'YRpos',  [  0,  80, 255]; ... %     yoked,       relevant,    positive
'YI',     [ 96,  96, 224]; ... %     yoked,       irrelevant,  no valence
'NDneg',  [ 80, 224,   0]; ... % non-significant, descriptive, negative
'NDpos',  [  0, 224,  80]; ... % non-significant, descriptive, positive
'NIneg',  [128, 192,  32]; ... % non-significant, irrelevant,  negative
'NIpos',  [ 32, 192, 128]; ... % non-significant, irrelevant,  positive
... % memory conditions
'STRneg', [224,  96,  64]; ... %     significant,     taught, relevant,    negative
'STRpos', [224,  64,  96]; ... %     significant,     taught, relevant,    positive
'STI',    [192, 128, 128]; ... %     significant,     taught, irrelevant,  no valence
'SNRneg', [192, 128,  96]; ... %     significant, not taught, relevant,    negative
'SNRpos', [192,  96, 128]; ... %     significant, not taught, relevant,    positive
'SNI',    [192, 160, 160]; ... %     significant, not taught, irrelevant,  no valence
'YTRneg', [ 96,  64, 224]; ... %     yoked,           taught, relevant,    negative
'YTRpos', [ 64,  96, 224]; ... %     yoked,           taught, relevant,    positive
'YTI',    [128, 128, 192]; ... %     yoked,           taught, irrelevant,  no valence
'YNRneg', [128,  96, 192]; ... %     yoked,       not taught, relevant,    negative
'YNRpos', [ 96, 128, 192]; ... %     yoked,       not taught, relevant,    positive
'YNI',    [160, 160, 192]; ... %     yoked,       not taught, irrelevant,  no valence
'NTDneg', [ 96, 224,  64]; ... % non-significant,     taught, descriptive, negative
'NTDpos', [ 64, 224,  96]; ... % non-significant,     taught, descriptive, positive
'NTIneg', [128, 192,  96]; ... % non-significant,     taught, irrelevant,  negative
'NTIpos', [ 96, 192, 128]; ... % non-significant,     taught, irrelevant,  positive
'NNDneg', [128, 160,  96]; ... % non-significant, not taught, descriptive, negative
'NNDpos', [ 96, 160, 128]; ... % non-significant, not taught, descriptive, positive
'NNIneg', [160, 128, 128]; ... % non-significant, not taught, irrelevant,  negative
'NNIpos', [128, 128, 160]; ... % non-significant, not taught, irrelevant,  positive
};
colorpicker(cat(1, condcols{:,2}), condcols(:,1))
!rm SocCog_onsets
SocCog_onsets
dbquit
SocCog_onsets
filecont(1:20,:)
uniqueruns
SocCog_onsets
!ls -lrt|tail
!cat 7401_1M1.prt
dbquit
!rm 7401_1M1.prt
dbclear all
SocCog_onsets
!mv soccogfunc-edforJochen SubjectData
cd SubjectData/
cd 7534
cd ..
vtcs = findfiles([pwd '/7*'], '*.vtc', 'depth=1');
vtcs
whos
prts = findfiles([pwd '/7*'], '*.prt', 'depth=1');
whos
cd 7403
ls -l
cd functional/
ls -l
cd preproc/
!du -sm *
cd ..
cd orig/
!du -sm *
cd 1L4
cd ..
cd 1L1
cd ..
cd 1L4
ls
ls -l
!rm m00??-???????*.*
cd ..
cd 1L1
cd ..
cd 7408
cd functional/
cd orig/
cd 1L1
cd ..
mkdir Unused
!mv 7403 Unused
vtcs = findfiles([pwd '/7*'], '*.vtc', 'depth=1');
prts = findfiles([pwd '/7*'], '*.prt', 'depth=1');
whos
subs = findfiles(pwd, '7*', 'dirs=1', 'depth=1');
vtcs = subs;
prts = subs;
for sc = 1:numel(subs), vtcs{sc} = findfiles(subs{sc}, '*.vtc', 'depth=1'); end
for sc = 1:numel(subs), prts{sc} = findfiles(subs{sc}, '*.prt', 'depth=1'); end
whos
vtcs
prts
[subs, vtcs, prts]
subs{1}
[strrep(subs, '/media/katie/SocCog/SubjectData/', ''), vtcs, prts]
!mkdir Issues
!mv 7404 7418 7432 7436 7443 7548 7480 7521 7533 7561 7562 7619 7641 7659 Issues/
!mv 7458 7726 Issues/
subs = findfiles(pwd, '7*', 'dirs=1', 'depth=1');
for sc = 1:numel(subs), vtcs{sc} = findfiles(subs{sc}, '*.vtc', 'depth=1'); end
for sc = 1:numel(subs), prts{sc} = findfiles(subs{sc}, '*.prt', 'depth=1'); end
[strrep(subs, '/media/katie/SocCog/SubjectData/', ''), vtcs, prts]
vtcs = subs;
prts = subs;
for sc = 1:numel(subs), vtcs{sc} = findfiles(subs{sc}, '*.vtc', 'depth=1'); end
for sc = 1:numel(subs), prts{sc} = findfiles(subs{sc}, '*.prt', 'depth=1'); end
[strrep(subs, '/media/katie/SocCog/SubjectData/', ''), vtcs, prts]
vtcs = findfiles([pwd '/7*'], '*.vtc', 'depth=1');
prts = findfiles([pwd '/7*'], '*.prt', 'depth=1');
whos
mdm = xff('new:mdm');
mdm.XTC_RTC = [vtcs, prts];
mdm.NrOfStudies = 576;
mdm
glm = mdm.ComputeGLM;
glm.SaveAs('SocCog_24subjects_test.glm');
ls -rtl
glm.SaveRunTimeVars;
ls -l
!rm *.mat
save test filecont
ls -lrt
!rm test.mat
save /tmp/test.mat filecont
!mount
cd /tmp
!rm test.mat
glm.SaveAs('SocCog_24subjects_test.glm');
!mv SocCog_24subjects_test.* /media/katie/SocCog/SubjectData/
ls -l
df -m
!df -m .
!df -m
!ls -rtl
cd /media/katie/SocCog/SubjectData/
ls -l
!rm SocCog_24subjects_test.*
glm.Browse;
figure; scaleimage(glm.Study(1).RunTimeVars.SDMMatrix)
figure; scaleimage(glm.Study(7).RunTimeVars.SDMMatrix)
figure; scaleimage(glm.Study(12).RunTimeVars.SDMMatrix)
figure; scaleimage(glm.Study(18).RunTimeVars.SDMMatrix)
figure; scaleimage(glm.Study(24).RunTimeVars.SDMMatrix)
mdm.XTC_RTC(1:24,2)
glm
glm.GLMData
mdm
vtc = xff(mdm.XTC_RTC{1});
vtc
vtc.Browse
vtc.ClearObject;
prt = xff(mdm.XTC_RTC{1,2});
c = prt.Cond;
c(1)
cat(1, c.NrOfOnOffsets)
c(4).OnOffsets
c(5).OnOffsets
c(6).OnOffsets
lonoff = zeros(576, 2);
for c=1:576, prt = xff(mdm.XTC_RTC{c,2}); cc = prt.Cond; ci = find(cat(1, cc.NrOfOnOffsets)>0); for cic = 1:numel(ci), lonoff(c, :) = max(lonoff(c, :), prt.Cond(ci(cic)).OnOffsets(end,:)); end, prt.ClearObject; end
lonoff(1:24,:)
vtc = xff(mdm.XTC_RTC{7});
vtc.NrOfVolumes
165*2.2
56*2.2
vtcs = findfiles([pwd '/7*'], '*.vtc', 'depth=1');
vtc.ClearObject;
vtc = xff(vtcs{1}, 'T');
vtc
vtc.TR(1)
t = vtc.TR;
whos
t(1) = 2200;
vtc.ClearObject;
vtc = xff(vtcs{1}, 'T');
vtc
vtc.ClearObject;
for c = 1:576, vtc = xff(vtcs{c}, 'T'); vtc.TR(1) = 2200; vtc.ClearObject; end
cd Issues/
vtcs = findfiles([pwd '/7*'], '*.vtc', 'depth=1');
whos
for c = 1:320, vtc = xff(vtcs{c}, 'T'); vtc.TR(1) = 2200; vtc.ClearObject; end
cd ..