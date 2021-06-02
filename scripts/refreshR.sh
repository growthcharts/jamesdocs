#!/bin/bash
# Re-install opencpu-server, R and the libs

# make system up to date
sudo apt-get update
sudo apt-get upgrade

# disable opencpu
sudo a2dissite opencpu
sudo apachectl restart

# disable pubertyplot & webtool
sudo a2dissite puberty
sudo a2dissite webtool
sudo apachectl restart

# save configuration files
mkdir conf
cp -rv /etc/opencpu/ ~/conf/
cp -rv /etc/apache2/ ~/conf/

# uninstall opencpu server & full
sudo apt-get purge opencpu-server
sudo apt-get purge opencpu-full

# remove all R libs
R -e '.libPaths()'
sudo rm -rf /usr/local/lib/R/site-library
sudo rm -rf /usr/lib/R/site-library
sudo rm -rf /usr/lib/R/library

# remove R
sudo apt-get purge r-base-core
sudo apt-get purge r-base
sudo apt-get autoremove

# add backport repositories for Ubuntu packages required by some R packages
sudo add-apt-repository 'deb https://mirror.nl.datapacket.com/ubuntu/ bionic main'
sudo add-apt-repository 'deb-src https://mirror.nl.datapacket.com/ubuntu/ bionic main'

# install R. See https://cran.r-project.org/bin/linux/ubuntu/
# update indices
sudo apt update -qq
# install two helper packages we need
sudo apt install --no-install-recommends software-properties-common dirmngr
# import the signing key (by Michael Rutter) for these repo
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
# we use R 4.0
# add the R 4.1 repo from CRAN
# sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran41/'
sudo apt install r-base
# install r-base-dev because we want to compile from source
sudo apt-get install r-base-dev

# install opencpu-server
sudo add-apt-repository -y ppa:opencpu/opencpu-2.2
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y opencpu-server

# restart opencpu
sudo a2ensite opencpu
sudo apachectl restart

# check https://vps.stefvanbuuren.nl/ocpu

# install application package: pubertyplot
sudo R -e 'install.packages("/home/stef/packages/pubertyplot_1.3.tar.gz", repos = NULL)'
sudo a2ensite puberty
sudo apachectl restart

# install application package: webtool
sudo R -e 'install.packages("RMySQL")'
sudo R -e 'install.packages("/home/stef/packages/webtool_1.1.tar.gz", repos = NULL)'
sudo a2ensite webtool
sudo apachectl restart

# install JAMES packages

sudo R -e 'install.packages("remotes")'
sudo R -e 'remotes::install_github("growthcharts/james")'

# remove duplicate packages
sudo R -e 'remove.packages(c("ellipsis", "pillar", "vctrs"), "/usr/lib/opencpu/library")'

# copy back opencpu configuration for JAMES
sudo rm -rf /etc/opencpu
sudo cp -rv ~/conf/opencpu /etc/opencpu/

# active JAMES
sudo apachectl restart

