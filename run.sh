#!/bin/bash

SessionID=$RANDOM

cd ${DPARSFPath}

optvalues="$@"

octave --silent --eval "y_Convert_BIDS2DPARSFA(\"$1\",\"$2\",\"${optvalues},\"${SessionID}\")"

rm -rf $2/TRInfo.tsv

${DPARSFPath}/run_DPARSFA_run.sh ${MCRPath} $2/DPARSFACfg${SessionID}.mat
#${DPARSFPath}/run_DPARSFA_run.sh ${MCRPath} $2/DPARSFACfg.mat $2 $2/SubID.txt 0

if [[ ${optvalues} == *" group "* ]];
then
  octave --silent --eval "y_CopyDARTELTemplate(\"$1\",\"$2\",\"${optvalues}\")"
fi


