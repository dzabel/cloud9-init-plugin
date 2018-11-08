#!/usr/bin/env bash

## One liner:
## bash <(curl -s https://raw.githubusercontent.com/dzabel/cloud9-init-plugin/master/install.sh)

red=$'\e[1;31m'
grn=$'\e[1;32m'
yel=$'\e[1;33m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
end=$'\e[0m'


##### Path and files
logfile="install.log"

installDir=`realpath ~/environment`
installDir=`echo "$installDir/cloud"`

#cmd msg
chkStatus() {
  if [ $# -eq 2 ]; then
    msg=$2
  else
    msg=$1
  fi
  outputmsg=`$1 `
  if [ $? -eq 0 ]; then
  printf "$msg        [${grn} OK ${end}]\n"
else
  printf "$msg        [${red} Failed ${end}]\n"
  exit 1
  fi
}

####### Installation Start

chkStatus "mkdir $installDir"

######## Update System
chkStatus "sudo yum -y update"

######## Installing GIT
chkStatus "sudo yum -y install git"

######### Configure GIT
chkStatus "git config --global credential.helper store" "git credentials store"
chkStatus "git config --global user.name dzabel" "set git user"
chkStatus "git config --global user.email daniel.zabel@coremedia.com" "set git user email"
echo "Input your github access token:\n"
read GITHUB_TOKEN
echo "https://dzabel:${GITHUB_TOKEN}@github.com" > ~/.git-credentials
chkStatus "git clone -b master-config --single-branch https://github.com/CoreMedia/cloud-infrastructure cloud-infrastructure-config" "clone master-config"
chkStatus "git clone https://github.com/CoreMedia/cloud-infrastructure cloud-infrastructure" "clone cloud-infrastructure"
