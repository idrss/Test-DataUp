FROM rocker/shiny:4.2.0
LABEL maintainer="olivier.chantrel@developpement-durable.gouv.fr"

RUN apt update && apt install -y libxml2
RUN apt install -y libxml2-dev
RUN apt install -y libmariadbclient-dev
RUN apt install -y libudunits2-dev
RUN apt install -y openssl
RUN apt install -y libssl-dev
RUN apt install -y libharfbuzz0b
RUN apt install -y libharfbuzz-dev
RUN apt install -y apt-utils
RUN apt install -y libfribidi-dev
RUN apt install -y libmysqlclient-dev
RUN apt install -y libgdal-dev

RUN apt install -y libcairo2-dev

RUN R -e "install.packages(c('tidyverse'), dependencies = TRUE)"
RUN R -e "install.packages(c('tidyr'), dependencies = TRUE)"
RUN R -e "install.packages(c('dplyr'), dependencies = TRUE)"
RUN R -e "install.packages(c('shiny'), dependencies = TRUE)"
RUN R -e "install.packages(c('shinydashboard'), dependencies = TRUE)"
RUN R -e "install.packages(c('rio'), dependencies = TRUE)"
RUN R -e "install.packages(c('readxl'), dependencies = TRUE)"
RUN R -e "install.packages(c('shinycssloaders'), dependencies = TRUE)"
RUN R -e "install.packages(c('shinyEffects'), dependencies = TRUE)"
RUN R -e "install.packages(c('DT'), dependencies = TRUE)"
RUN R -e "install.packages(c('janitor'), dependencies = TRUE)"
RUN R -e "install.packages(c('shinyWidgets'), dependencies = TRUE)"
RUN R -e "install.packages(c('htmltools'), dependencies = TRUE)"

RUN R -e "install.packages(c('httr'), dependencies = TRUE)"
RUN R -e "install.packages(c('jsonlite'), dependencies = TRUE)"
RUN R -e "install.packages(c('curl'), dependencies = TRUE)"
RUN R -e "install.packages(c('glue'), dependencies = TRUE)"
RUN R -e "install.packages(c('curl'), dependencies = TRUE)"


COPY app.R /srv/shiny-app/app.R

