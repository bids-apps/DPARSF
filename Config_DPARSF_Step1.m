function Config_DPARSF_Step1(MatFile)
% function y_Config_DPARSF(InDir, OutDir, Options)
% Config DPAFSF parameters.
%   Input:
%     MatFile - a file with Cfg.
%   Output:
%     MatFile - a file with Cfg after configuration.
%___________________________________________________________________________
% Written by YAN Chao-Gan 171210.
% Key Laboratory of Behavioral Science and Magnetic Resonance Imaging Research Center, Institute of Psychology, Chinese Academy of Sciences, Beijing, China
% ycg.yan@gmail.com

%!!!! THIS FILE SHOULD BE PUT IN THE OUTPUT DIR!!!!

fprintf('Configuring DPARSF parameters use users'' settings...\n');

load(MatFile)

%Please setup your configurations below this line
%======================================

%
% Cfg.DPARSFVersion='V4.3_171210'; %The version of DPARSF
% Cfg.WorkingDir=pwd; %The working directory.
% Cfg.DataProcessDir=Cfg.WorkingDir; %Define DataProcessDir for compatibility
% Cfg.SubjectID={}; %Subject ID List
% Cfg.TimePoints=0; %Number of time points. Set to 0 to skip the checking

%!!!! PLEASE REMEMBER TO SET UP THE CORRECT TR
Cfg.TR=2; %TR. Set to 0 to read TR from the NIfTI files automatically

Cfg.IsNeedConvertFunDCM2IMG=0; %Convert functional DICOM files to NIfTI files
Cfg.IsApplyDownloadedReorientMats=0; %Apply downloaded reorientation files (or previously saved reorienting files). The downloaded reorient mats (*_ReorientFunImgMat.mat and *_ReorientT1ImgMat.mat) should be put in DownloadedReorientMats folder under the working directory
Cfg.IsRemoveFirstTimePoints=1; %Remove the first time points.
Cfg.RemoveFirstTimePoints=10; %How many time points should be removed.
Cfg.IsSliceTiming=1; %Slice timing
Cfg.SliceTiming.SliceNumber=0; %Slice number. If SliceNumber is set to 0 while SliceOrderInfo.tsv is not set, the slice order is then assumed as interleaved scanning: [1:2:SliceNumber,2:2:SliceNumber]. The reference slice is set to the slice acquired at the middle time point, i.e., SliceOrder(ceil(SliceNumber/2)). SHOULD BE EXTREMELY CAUTIOUS!!!
Cfg.SliceTiming.SliceOrder=[1:2:33,2:2:32]; %Slice order
Cfg.SliceTiming.ReferenceSlice=0; %Reference slice. Set to 0 if want to set automatically.
Cfg.IsRealign=1; %Realignment (head motion correction)
Cfg.IsCalVoxelSpecificHeadMotion=0; %Calculate the voxel-specific head motion translation in x, y, z and TDvox, FDvox, according to Yan et al., 2013 Neuroimage (76, 183-201.)
Cfg.IsNeedReorientFunImgInteractively=0; %Reorient to a good head position and click on the anterior commissure. Will be skipped if Cfg.IsAllowGUI set to 0

Cfg.IsNeedConvertT1DCM2IMG=0; %Convert T1 DICOM files to NIfTI files
Cfg.IsNeedReorientCropT1Img=0; %Crop the T1 .nii/.nii.gz/.img images (Reorient to the nearest orthogonal direction to ''canonical space'' and remove excess air surrounding the individual as well as parts of the neck below the cerebellum, i.e., make co*.nii or co*.img)
Cfg.IsNeedReorientT1ImgInteractively=0; %Reorient to a good head position and click on the anterior commissure. Will be skipped if Cfg.IsAllowGUI set to 0
Cfg.IsBet=0; %Bet structural and functional images (call FSL's bet)
Cfg.IsAutoMask=1; %Calculate automasks. Similar to AFNI's 3dAutoMask

Cfg.IsNeedT1CoregisterToFun=1; %Coregister structural images to functional space
Cfg.IsNeedReorientInteractivelyAfterCoreg=0; %Reorient to a good head position and click on the anterior commissure. Display on T1 image, but apply simultaneously to functional and T1 images. Will be skipped if Cfg.IsAllowGUI set to 0

Cfg.IsSegment=2; %Segmentation: 1 for old segment; 2 for new segment.
Cfg.Segment.AffineRegularisationInSegmentation='mni'; %Affine regularization

Cfg.IsDARTEL=0; %Perform DARTEL

Cfg.IsCovremove=0; %Nuisance regression
Cfg.Covremove.Timing='AfterRealign';  %Another option: AfterNormalize
Cfg.Covremove.PolynomialTrend=1; %Polynomial trends. 0: constant; 1: constant + linear trend; 2: constant + linear trend + quadratic trend; 3: constant + linear trend + quadratic trend + cubic trend.   ...
Cfg.Covremove.HeadMotion=4; %1: Use the current time point of rigid-body 6 realign parameters. e.g., Txi, Tyi, Tzi...; 2: Use the current time point and the previous time point of rigid-body 6 realign parameters. e.g., Txi, Tyi, Tzi,..., Txi-1, Tyi-1, Tzi-1...; 3: Use the current time point and their squares of rigid-body 6 realign parameters. e.g., Txi, Tyi, Tzi,..., Txi^2, Tyi^2, Tzi^2...; 4: Use the Friston 24-parameter model: current time point, the previous time point and their squares of rigid-body 6 realign parameters. e.g., Txi, Tyi, Tzi, ..., Txi-1, Tyi-1, Tzi-1,... and their squares (total 24 items). Friston autoregressive model (Friston, K.J., Williams, S., Howard, R., Frackowiak, R.S., Turner, R., 1996. Movement-related effects in fMRI time-series. Magn Reson Med 35, 346-355.);
%11-14: Use the voxel-specific models. 14 is the voxel-specific 12 model.
Cfg.Covremove.IsHeadMotionScrubbingRegressors=0; %Head Motion "Scrubbing" Regressors: each bad time point is a separate regressor if set to 1
Cfg.Covremove.HeadMotionScrubbingRegressors.FDType='FD_Power'; %Can also be FD_Jenkinson
Cfg.Covremove.HeadMotionScrubbingRegressors.FDThreshold=0.5;
Cfg.Covremove.HeadMotionScrubbingRegressors.PreviousPoints=1;
Cfg.Covremove.HeadMotionScrubbingRegressors.LaterPoints=2;
Cfg.Covremove.WM.IsRemove = 1; % or 0
Cfg.Covremove.WM.Mask = 'SPM'; % or 'Segment'
Cfg.Covremove.WM.MaskThreshold = 0.99;
Cfg.Covremove.WM.Method = 'Mean'; %or 'CompCor'
Cfg.Covremove.WM.CompCorPCNum = 5;
Cfg.Covremove.CSF.IsRemove = 1; % or 0
Cfg.Covremove.CSF.Mask = 'SPM'; % or 'Segment'
Cfg.Covremove.CSF.MaskThreshold = 0.99;
Cfg.Covremove.CSF.Method = 'Mean'; %or 'CompCor'
Cfg.Covremove.CSF.CompCorPCNum = 5;
Cfg.Covremove.WholeBrain.IsRemove = 0; % or 1. This is for global signal regression.
Cfg.Covremove.WholeBrain.IsBothWithWithoutGSR = 0; % or 1. This is only effective with DPARSFA GUI. Will run first without GSR, and then re-run with GSR.
Cfg.Covremove.WholeBrain.Mask = 'SPM'; % or 'AutoMask'
Cfg.Covremove.WholeBrain.Method = 'Mean';
Cfg.Covremove.OtherCovariatesROI = []; %Define Other kinds of nuisance covariates.
Cfg.Covremove.IsAddMeanBack = 0; %Add mean back, thus you can still see the WM/GM/CSF contrast. Maybe useful in group ICA or SPM GLM analyses.

Cfg.IsFilter=0; %Ideal filter.
Cfg.Filter.Timing='AfterNormalize'; %Another option: BeforeNormalize
Cfg.Filter.ALowPass_HighCutoff=0.1;
Cfg.Filter.AHighPass_LowCutoff=0.01;
Cfg.Filter.AAddMeanBack='Yes'; %Add mean back, thus you can still see the WM/GM/CSF contrast.

Cfg.IsNormalize=0; %1. Normalization by using the EPI template directly; 2. Normalization by using the T1 image segment information; 3. Normalization by using DARTEL
Cfg.Normalize.Timing='OnFunctionalData'; %Another option: OnResults
Cfg.Normalize.BoundingBox=[-90 -126 -72;90 90 108];
Cfg.Normalize.VoxSize=[3 3 3];

Cfg.IsSmooth=0; %1. Normal smooth. 2. Smooth by DARTEL. The smoothing that is a part of the normalization to MNI space computes these average intensities from the original data, rather than the warped versions. When the data are warped, some voxels will grow and others will shrink. This will change the regional averages, with more weighting towards those voxels that have grows.
Cfg.Smooth.Timing='OnResults'; %Another option: OnFunctionalData
Cfg.Smooth.FWHM=[4 4 4];

Cfg.MaskFile ='Default'; %Using DPABI/Templates/BrainMask_05_61x73x61.img

Cfg.IsWarpMasksIntoIndividualSpace=0; %Calculation in individual (original/native) space.

Cfg.IsDetrend=0; %Detrend is no longer needed if linear trend is included in nuisance regression.

Cfg.IsCalALFF=0; %Calculate ALFF and fALFF
Cfg.CalALFF.AHighPass_LowCutoff=0.01;
Cfg.CalALFF.ALowPass_HighCutoff=0.1;

Cfg.IsScrubbing=0; %Scrubbing (delete the bad time points)
Cfg.Scrubbing.Timing='AfterPreprocessing';
Cfg.Scrubbing.FDType='FD_Power'; %Can also be FD_Jenkinson
Cfg.Scrubbing.FDThreshold=0.5;
Cfg.Scrubbing.PreviousPoints=1;
Cfg.Scrubbing.LaterPoints=2;
Cfg.Scrubbing.ScrubbingMethod='cut';  %1. 'cut': discarding the timepoints with TemporalMask == 0; 2. 'nearest': interpolate the timepoints with TemporalMask == 0 by Nearest neighbor interpolation; 3. 'linear': interpolate the timepoints with TemporalMask == 0 by Linear interpolation; 4. 'spline': interpolate the timepoints with TemporalMask == 0 by Cubic spline interpolation; 5. 'pchip': interpolate the timepoints with TemporalMask == 0 by Piecewise cubic Hermite interpolation

Cfg.IsCalReHo=0; %Calculate ReHo
Cfg.CalReHo.ClusterNVoxel=27;% The number of the voxel for a given cluster during calculating the KCC (e.g. 27, 19, or 7);
Cfg.CalReHo.SmoothReHo=0; %Smooth ReHo results after calculation

Cfg.IsCalDegreeCentrality=0; %Degree Centrality
Cfg.CalDegreeCentrality.rThreshold=0.25;

Cfg.IsCalFC=0; %Functional Connectivity
Cfg.IsExtractROISignals=0; %Extract ROI Signals. Will calculate the FC and zFC between the ROIs as well
Cfg.CalFC.IsMultipleLabel=1; %1: There are multiple labels in the ROI mask file. Will extract each of them. (e.g., for aal.nii, extract all the time series for 116 regions); 0 (default): All the non-zero values will be used to define the only ROI
Cfg.CalFC.ROIDef=[];%ROI definition, cells. Each cell could be: 1. 3D mask martrix (DimX*DimY*DimZ); 2. Series matrix (DimTimePoints*1); 3. Sphere Definition; 4. .img/.nii/.nii.gz mask file; 5. .txt Series. If multiple columns, when IsMultipleLabel==1: each column is a seperate seed series; when IsMultipleLabel==0: average all the columns and take the mean series (one column) as seed series
Cfg.IsDefineROIInteractively = 0; %Define ROIs interactively based on T1 image

Cfg.IsCWAS = 0; %CWAS analysis
Cfg.CWAS.Regressors = [];
Cfg.CWAS.iter = 0;

Cfg.IsNormalizeToSymmetricGroupT1Mean = 0; %Normalize to symmetric template for VMHC analysis
Cfg.IsSmoothBeforeVMHC = 0; %Smooth the functional data right before VMHC calculation
Cfg.IsCalVMHC = 0; %Calculate VMHC

%Cfg.FunctionalSessionNumber=1; %If you have mutilple functional sessions, you need to specify the number of sessions. And your directory should be named as FunRaw (or FunImg) for the first session; S2_FunRaw (or S2_FunImg) for the second session; S3_FunRaw (or S3_FunImg) for the third session...
Cfg.StartingDirName='FunImg'; %'If you do not start with raw DICOM images, you need to specify the Starting Directory Name. E.g. "FunImgARW" means you start with images which have been slice timing corrected, realigned and normalized. Abbreviations: A - Slice Timing; R - Realign; W - Normalize; S - Smooth; D - Detrend; F - Filter; C - Covariates Removed; B - ScruBBing; sym - Normalized to a symmetric template...


%======================================
%Please setup your configurations above this line

save('-v7',MatFile,'Cfg','UseNoCoT1Image','T1SourceFileSet');
