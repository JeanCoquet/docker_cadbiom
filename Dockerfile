############################################################
# Dockerfile to build Cadbiom 1.1 container image
# Based on debian Jessie/8
############################################################

# Set the base image to debian
FROM debian:jessie

ENV DIR /opt

ENV PACKAGES git python2.7 python-pip wget build-essential python-setuptools python-dev libzip-dev libboost-program-options-dev libm4ri-dev libsqlite3-dev python-gtksourceview2 python2.7-dev libxml2-dev libxslt1-dev libxslt1-dev libgraphviz-dev pkg-config python-glade2 python-gtk2 libfreetype6-dev

ENV PIP_PACKAGES lxml networkx pygraphviz

ENV CMAKE_ARCHIVE_GIT https://gitlab.kitware.com/cmake/cmake.git
ENV CRYPTOMINISAT_GIT https://github.com/msoos/cryptominisat.git
ENV CADBIOM_GIT https://gitlab.irisa.fr/0000B8EG/Cadbiom.git


################## DEPENDENCIES INSTALLATION ######################

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y ${PACKAGES}
RUN pip install ${PIP_PACKAGES}


################## CMAKE INSTALLATION ######################

WORKDIR ${DIR}
RUN git clone ${CMAKE_ARCHIVE_GIT}
WORKDIR ${DIR}/cmake
RUN ./bootstrap
RUN make
RUN make install


################## CRYPTOMINISAT INSTALLATION ######################

WORKDIR ${DIR}
RUN git clone ${CRYPTOMINISAT_GIT}
WORKDIR ${DIR}/cryptominisat
RUN cmake .
RUN make
RUN make install
RUN ldconfig


################## CADBIOM INSTALLATION ######################

WORKDIR ${DIR}
RUN git clone ${CADBIOM_GIT}
WORKDIR ${DIR}/Cadbiom/library
RUN make install
WORKDIR ${DIR}/Cadbiom/command_line
RUN make install


################## DOCKERFILE USAGE ######################
ENTRYPOINT ["cadbiom_cmd"]
CMD ["--help"]
