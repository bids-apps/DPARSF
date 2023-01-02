function y_CopyDARTELTemplate(InDir, OutDir, Options)
% function y_CopyDARTELTemplate(InDir, OutDir, Options)
% Copy DARTEL Template to each participant
%___________________________________________________________________________
% Written by YAN Chao-Gan 171220.
% Key Laboratory of Behavioral Science and Magnetic Resonance Imaging Research Center, Institute of Psychology, Chinese Academy of Sciences, Beijing, China
% ycg.yan@gmail.com

fprintf('Copying DARTEL template to each participant...\n');

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

for i=2:length(SubID)
    copyfile([OutDir,filesep,'T1ImgNewSegment',filesep,SubID{1},filesep,'Template_6*'],[OutDir,filesep,'T1ImgNewSegment',filesep,SubID{i},filesep]);
end
