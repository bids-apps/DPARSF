function y_Convert_BIDS2DPARSFA(InDir, OutDir, Options, SessionID)
% function y_Convert_BIDS2DPARSFA(InDir, OutDir, Options)
% Convert BIDS data structure to DPARSF data structure.
%   Input:
%     InDir  - Input dir with BIDS data.
%     OutDir - Output dir with DPARSF data.
%     Options - Options from command line
%     SessionID - Unique ID for a instance when using parralel computing
%___________________________________________________________________________
% Written by YAN Chao-Gan 171125.
% Key Laboratory of Behavioral Science and Magnetic Resonance Imaging Research Center, Institute of Psychology, Chinese Academy of Sciences, Beijing, China
% ycg.yan@gmail.com

fprintf('Converting BIDS to DPARSFA structure...\n');


if ~exist('SessionID','var')
    SessionID='';
end

Temp=strfind(Options,'--participant_label');
if ~isempty(Temp) %Subject list provided
    TempConfig=strfind(Options,'--config'); %Check if --config is given
    if isempty(TempConfig)
        TempStr=Options(Temp:end);
    else
        TempStr=Options(Temp:TempConfig-2);
    end
    Temp=strfind(TempStr,' ');
    SubID=[];
    for iSub=1:length(Temp)-1
        SubID{iSub,1}=['sub-',TempStr(Temp(iSub)+1:Temp(iSub+1)-1)];
    end
    SubID{length(Temp),1}=['sub-',TempStr(Temp(end)+1:end)];
else %Subject list not provided, process all the subjects
    Dir=dir([InDir,filesep,'sub*']);
    SubID=[];
    for i=1:length(Dir)
        SubID{i,1}=Dir(i).name;
    end
end

DirSessions=dir([InDir,filesep,SubID{1,1},filesep,'ses*']);
FunctionalSessionNumber=length(DirSessions);

%Single session data
if FunctionalSessionNumber==0
    mkdir([OutDir,filesep,'T1Img']);
    mkdir([OutDir,filesep,'FunImg']);
    for i=1:length(SubID)
        mkdir([OutDir,filesep,'T1Img',filesep,SubID{i},filesep]);
        DirFile=dir([InDir,filesep,SubID{i},filesep,'anat',filesep,SubID{i},'*_T1w.nii.gz']);
        copyfile([InDir,filesep,SubID{i},filesep,'anat',filesep,DirFile(1).name],[OutDir,filesep,'T1Img',filesep,SubID{i},filesep]);
        
        mkdir([OutDir,filesep,'FunImg',filesep,SubID{i},filesep]);
        DirFile=dir([InDir,filesep,SubID{i},filesep,'func',filesep,'*.nii.gz']);
        copyfile([InDir,filesep,SubID{i},filesep,'func',filesep,DirFile(1).name],[OutDir,filesep,'FunImg',filesep,SubID{i},filesep]);
    end
end


%Multiple session data
if FunctionalSessionNumber>=1
    FunSessionPrefixSet={''}; %The first session doesn't need a prefix. From the second session, need a prefix such as 'S2_';
    for iFunSession=2:FunctionalSessionNumber
        FunSessionPrefixSet=[FunSessionPrefixSet;{['S',num2str(iFunSession),'_']}];
    end
    
    mkdir([OutDir,filesep,'T1Img']);
    for i=1:length(SubID)
        mkdir([OutDir,filesep,'T1Img',filesep,SubID{i},filesep]);
        DirFile=dir([InDir,filesep,SubID{i},filesep,DirSessions(1).name,filesep,'anat',filesep,SubID{i},'*_T1w.nii.gz']);
        copyfile([InDir,filesep,SubID{i},filesep,DirSessions(1).name,filesep,'anat',filesep,DirFile(1).name],[OutDir,filesep,'T1Img',filesep,SubID{i},filesep]);
    end
    
    for iFunSession=1:FunctionalSessionNumber
        mkdir([OutDir,filesep,FunSessionPrefixSet{iFunSession},'FunImg']);
        for i=1:length(SubID)
            mkdir([OutDir,filesep,FunSessionPrefixSet{iFunSession},'FunImg',filesep,SubID{i},filesep]);
            DirFile=dir([InDir,filesep,SubID{i},filesep,DirSessions(iFunSession).name,filesep,'func',filesep,'*.nii.gz']);
            copyfile([InDir,filesep,SubID{i},filesep,DirSessions(iFunSession).name,filesep,'func',filesep,DirFile(1).name],[OutDir,filesep,FunSessionPrefixSet{iFunSession},'FunImg',filesep,SubID{i},filesep]);
        end
    end
end


%Save SubID file
SubID_File=[OutDir,filesep,'SubID.txt'];
fid = fopen(SubID_File,'w');
for iSub=1:length(SubID)
    fprintf(fid,'%s\n',SubID{iSub});
end
fclose(fid);

%delete previous TRInfo.tsv
delete([OutDir,filesep,'TRInfo.tsv']);

%Setup DPARSFA Cfg
MATPATH=fileparts(mfilename('fullpath'));
load([MATPATH,filesep,'Template_V4_CalculateInMNISpace_Warp_DARTEL_docker.mat'])
Cfg.SubjectID=SubID;
Cfg.DataProcessDir=OutDir;

%Change the default normalizing strategy to using the T1 image segment information
Cfg.IsNormalize=2; %1. Normalization by using the EPI template directly; 2. Normalization by using the T1 image segment information; 3. Normalization by using DARTEL

Cfg.IsCalFC=0; %Functional Connectivity
Cfg.IsExtractROISignals=1; %Extract ROI Signals. Will calculate the FC and zFC between the ROIs as well
Cfg.CalFC.IsMultipleLabel=1; %1: There are multiple labels in the ROI mask file. Will extract each of them. (e.g., for aal.nii, extract all the time series for 116 regions); 0 (default): All the non-zero values will be used to define the only ROI
Cfg.CalFC.ROIDef = {[MATPATH,filesep,'aal.nii'];...
    [MATPATH,filesep,'HarvardOxford-cort-maxprob-thr25-2mm_YCG.nii'];...
    [MATPATH,filesep,'HarvardOxford-sub-maxprob-thr25-2mm_YCG.nii'];...
    [MATPATH,filesep,'CC200ROI_tcorr05_2level_all.nii'];...
    [MATPATH,filesep,'Zalesky_980_parcellated_compact.nii'];...
    [MATPATH,filesep,'Dosenbach_Science_160ROIs_Radius5_Mask.nii'];...
    [MATPATH,filesep,'BrainMask_05_91x109x91.img'];... %YAN Chao-Gan, 161201. Add global signal.
    [MATPATH,filesep,'Power_Neuron_264ROIs_Radius5_Mask.nii']}; %YAN Chao-Gan, 170104. Add Power 264.

Cfg.FunctionalSessionNumber=FunctionalSessionNumber;
if Cfg.FunctionalSessionNumber==0
    Cfg.FunctionalSessionNumber=1;
end

Cfg.IsAllowGUI=0;

UseNoCoT1Image=1; %Prevent the dialog asking confirm use no co t1 images.


T1SourceFileSet = cell(length(SubID),1); %For group level
Temp=strfind(Options,' group_dartel '); %Check if at group level
if ~isempty(Temp)
    for i=1:length(SubID)
        SourceDir=dir([OutDir,filesep,'T1ImgNewSegment',filesep,SubID{i},filesep,'sub*.nii']);
        T1SourceFileSet{i} = [OutDir,filesep,'T1ImgNewSegment',filesep,SubID{i},filesep,SourceDir(1).name];
    end
end

save('-v7',[OutDir,filesep,'DPARSFACfg',SessionID,'.mat'],'Cfg','UseNoCoT1Image','T1SourceFileSet');

TempConfig=strfind(Options,'--config'); %Check if --config is given
if ~isempty(TempConfig)
    TempStr=Options(TempConfig:end);
    Temp=strfind(TempStr,' ');
    if length(Temp==1)
        FileName=TempStr(Temp(1)+1:end);
    else
        FileName=TempStr(Temp(1)+1:Temp(2)-1);
    end
    copyfile(FileName,[OutDir,filesep,'Config_DPARSF',SessionID,'.m'])
    cd(OutDir)
    eval(['Config_DPARSF',SessionID,'([OutDir,filesep,''DPARSFACfg',SessionID,'.mat'']);']);
end

% if exist([OutDir,filesep,'Config_DPARSF.m']) %Config DPARSF parameters use users setting
%     cd(OutDir)
%     Config_DPARSF([OutDir,filesep,'DPARSFACfg.mat']);
% end






