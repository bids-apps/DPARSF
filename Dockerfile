FROM bids/base_validator

MAINTAINER Chao-Gan Yan <ycg.yan@gmail.com>
#Referenced from Guillaume Flandin's SPM BIDS apps

# Update system
RUN apt-get -qq update && apt-get -qq install -y \
    unzip \
    xorg \
    wget && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install MATLAB MCR
ENV MATLAB_VERSION R2016b
RUN mkdir /opt/mcr_install && \
    mkdir /opt/mcr && \
    wget -P /opt/mcr_install http://www.mathworks.com/supportfiles/downloads/${MATLAB_VERSION}/deployment_files/${MATLAB_VERSION}/installers/glnxa64/MCR_${MATLAB_VERSION}_glnxa64_installer.zip && \
    unzip -q /opt/mcr_install/MCR_${MATLAB_VERSION}_glnxa64_installer.zip -d /opt/mcr_install && \
    /opt/mcr_install/install -destinationFolder /opt/mcr -agreeToLicense yes -mode silent && \
    rm -rf /opt/mcr_install /tmp/*

# Configure environment
ENV MCR_VERSION v91
ENV LD_LIBRARY_PATH /opt/mcr/${MCR_VERSION}/runtime/glnxa64:/opt/mcr/${MCR_VERSION}/bin/glnxa64:/opt/mcr/${MCR_VERSION}/sys/os/glnxa64:/opt/mcr/${MCR_VERSION}/sys/opengl/lib/glnxa64
ENV MCR_INHIBIT_CTF_LOCK 1
ENV MCRPath /opt/mcr/${MCR_VERSION}

# Install DPARSFA Standalone
RUN wget -P /opt http://lab.rfmri.org/sites/default/files/DPABI/DPARSF/DPARSFA_run_StandAlone_Linux.zip && \
    unzip -q /opt/DPARSFA_run_StandAlone_Linux.zip -d /opt && \
    rm -f /opt/DPARSFA_run_StandAlone_Linux.zip

# Configure SPM BIDS App entry point
COPY run.sh /opt/DPARSFA_run_StandAlone_Linux/
COPY Template_V4_CalculateInMNISpace_Warp_DARTEL_docker.mat /opt/DPARSFA_run_StandAlone_Linux/
COPY version /version
RUN chmod +x /opt/DPARSFA_run_StandAlone_Linux/run.sh
RUN chmod +x /opt/DPARSFA_run_StandAlone_Linux/run_y_Convert_BIDS2DPARSF.sh
RUN chmod +x /opt/DPARSFA_run_StandAlone_Linux/run_DPARSFA_run.sh
RUN chmod +x /opt/DPARSFA_run_StandAlone_Linux/y_Convert_BIDS2DPARSF
RUN chmod +x /opt/DPARSFA_run_StandAlone_Linux/DPARSFA_run

ENV DPARSFPath /opt/DPARSFA_run_StandAlone_Linux

ENTRYPOINT ["/opt/DPARSFA_run_StandAlone_Linux/run.sh"]

