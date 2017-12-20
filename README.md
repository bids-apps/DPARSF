# DPARSF docker version (for BIDS App)
=======
# 
This is a docker version of DPARSF V4.3, working for BIDS data structure.

1. Prepare your data in BIDS structure, e.g., https://github.com/INCF/BIDS-examples/tree/master/ds003. Please reserve the TR information within the NIfTI header. Or you have to define TR information in Config_DPARSF.m with --config option.

2. Build the container:
sudo docker build -t dparsfdocker .

3. Process your data:  
sudo docker run -i --rm -v /data/MyDataBIDS:/inputs:ro -v /data/DPARSFResults:/outputs dparsfdocker /inputs /outputs participant  
You can also process a subset of subjects. (As DPARSF will parallel processing the participants automatically, and DPARSF use DARTEL to generate a GROUP TEMPLATE for spatial normalization, it's not recommended that you process only 1 subject at at time).  
sudo docker run -i --rm -v /data/MyDataBIDS:/inputs:ro -v /data/DPARSFResults:/outputs dparsfdocker /inputs /outputs participant --participant_label 01 02 04 05 07 09 10  

4. If you want to customize your processing, please setup a .m file (Config_DPARSF.m is an example) according to the instructions at: http://rfmri.org/content/configurations-dparsfarun. Then use --config to specify the path. E.g.,   
sudo docker run -i --rm -v /data/MyDataBIDS:/inputs:ro -v /data/DPARSFResults:/outputs dparsfdocker /inputs /outputs participant --participant_label 01 02 04 05 07 09 10 --config /inputs/Config_DPARSF.m  

5. Advanced Usage: if you want to parallel computing at a higher level for all the processing except for DARTEL create template (which should be based on all the subjects), you can use the Config templates as (PLEASE REMEMBER TO SET UP THE CORRECT TR in the Config!!!):  
(1) First run all the processing before DARTEL create template.  
sudo docker run -i --rm -v /data/MyDataBIDS:/inputs:ro -v /data/DPARSFResults:/outputs dparsfdocker /inputs /outputs participant --participant_label 01 --config /inputs/Config_DPARSF_Step1.m  
sudo docker run -i --rm -v /data/MyDataBIDS:/inputs:ro -v /data/DPARSFResults:/outputs dparsfdocker /inputs /outputs participant --participant_label 02 --config /inputs/Config_DPARSF_Step1.m  
sudo docker run -i --rm -v /data/MyDataBIDS:/inputs:ro -v /data/DPARSFResults:/outputs dparsfdocker /inputs /outputs participant --participant_label 03 --config /inputs/Config_DPARSF_Step1.m  
(2) Then run DARTEL create template at the group level.  
sudo docker run -i --rm -v /data/MyDataBIDS:/inputs:ro -v /data/DPARSFResults:/outputs dparsfdocker /inputs /outputs group --participant_label 01 02 03 --config /inputs/Config_DPARSF_Step2.m  
(3) Finally run all the processing after DARTEL template created.  
sudo docker run -i --rm -v /data/MyDataBIDS:/inputs:ro -v /data/DPARSFResults:/outputs dparsfdocker /inputs /outputs participant --participant_label 01 --config /inputs/Config_DPARSF_Step3.m  
sudo docker run -i --rm -v /data/MyDataBIDS:/inputs:ro -v /data/DPARSFResults:/outputs dparsfdocker /inputs /outputs participant --participant_label 02 --config /inputs/Config_DPARSF_Step3.m  
sudo docker run -i --rm -v /data/MyDataBIDS:/inputs:ro -v /data/DPARSFResults:/outputs dparsfdocker /inputs /outputs participant --participant_label 03 --config /inputs/Config_DPARSF_Step3.m   



Please report any issues to http://rfmri.org/DPABIDiscussion.  
Please Cite:  
Yan, C.G., Zang, Y.F., 2010. DPARSF: A MATLAB Toolbox for "Pipeline" Data Analysis of Resting-State fMRI. Front Syst Neurosci 4, 13.  
Yan, C.G., Wang, X.D., Zuo, X.N., Zang, Y.F., 2016. DPABI: Data Processing & Analysis for (Resting-State) Brain Imaging. Neuroinformatics 14, 339-351.  

**NOTE: DPARSF docker version is based on DPARSF Stand-Alone version (http://rfmri.org/DPABI_Stand-Alone), users SHOULD joint the R-fMRI Maps Project (http://rfmri.org/maps) if the docker or OpenNeuro version is used! Users are assumed have agreed with the terms in the user agreement if using these two versions.**

