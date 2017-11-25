#!/bin/bash

${DPARSFPath}/run_y_Convert_BIDS2DPARSF.sh ${MCRPath} $1 $2

${DPARSFPath}/run_DPARSFA_run.sh ${MCRPath} ${DPARSFPath}/Template_V4_CalculateInMNISpace_Warp_DARTEL_docker.mat $2 $2/SubID.txt 0

