####### Dockerfile #######
FROM rocker/rstudio
LABEL maintainer="richard.torkar@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

COPY new_data.csv /home/rstudio/

RUN apt-get update -qq \ 
  && apt-get -y install build-essential ed pkg-config apt-utils libglu1-mesa-dev libnlopt-dev nano libgsl-dev libz-dev

RUN mkdir -p $HOME/.R/ \ 
  && echo "CXX14FLAGS=-O3 -march=native -mtune=native -fPIC" >> $HOME/.R/Makevars \
  && echo "CXX14=g++ -std=c++11" >> $HOME/.R/Makevars \
  && echo "CXX14FLAGS+= -std=c++11" >> $HOME/.R/Makevars \
  && echo "CXX14STD='-std=c++11'" >> $HOME/.R/Makevars \
  && echo "rstan::rstan_options(auto_write = TRUE)" >> /home/rstudio/.Rprofile \
  && echo "options(mc.cores = parallel::detectCores())" >> /home/rstudio/.Rprofile

RUN install2.r --error rstan

RUN install2.r --error mvtnorm

RUN install2.r --error loo

RUN install2.r --error coda

RUN install2.r -r http://xcelab.net/R --error rethinking

RUN rm -rf /tmp/downloaded_packages/ /tmp/*.rds
