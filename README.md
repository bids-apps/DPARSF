# DPARSF docker version (for BIDS App)
=======
# 
This is a docker version of DPARSF V4.3, working for BIDS data structure.

1. Prepare your data in BIDS structure, e.g., https://github.com/INCF/BIDS-examples/tree/master/ds003. PLEASE RESERVE THE TR INFORMATION WITHIN THE NIFTI HEADER.

2. Build the container:
sudo docker build -t dparsfdocker .

3. Process your data:
sudo docker run -i --rm -v /data/MyDataBIDS:/inputs:ro -v /data/DPARSFResults:/outputs dparsfdocker /inputs /outputs participant

You can also process a subset of subjects. (As DPARSF will parallel processing the participants automatically, and DPARSF use DARTEL to generate a GROUP TEMPLATE for spatial normalization, it's not recommended that you process only 1 subject at at time).
sudo docker run -i --rm -v /data/MyDataBIDS:/inputs:ro -v /data/DPARSFResults:/outputs dparsfdocker /inputs /outputs participant --participant_label 01 02 04 05 07 09 10

4. If you want to customize your processing, please edit y_Convert_BIDS2DPARSFA.m last section (%Setup DPARSFA Cfg) according to the instructions at: http://rfmri.org/content/configurations-dparsfarun, and then redo Steps 2 & 3.


Please report any issues to http://rfmri.org/DPABIDiscussion.
Please Cite:
Yan, C.G., Zang, Y.F., 2010. DPARSF: A MATLAB Toolbox for "Pipeline" Data Analysis of Resting-State fMRI. Front Syst Neurosci 4, 13.
Yan, C.G., Wang, X.D., Zuo, X.N., Zang, Y.F., 2016. DPABI: Data Processing & Analysis for (Resting-State) Brain Imaging. Neuroinformatics 14, 339-351.

