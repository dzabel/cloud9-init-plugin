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
envDir=$(realpath ~/environment)
envDir=$(echo "$envDir/cloud")

#cmd msg
chkStatus() {
  if [[ $# -eq 2 ]]; then
    msg=$2
  else
    msg=$1
  fi
  outputmsg=`$1 `
  if [[ $? -eq 0 ]]; then
    printf "$msg        [${grn} OK ${end}]\n"
  else
    printf "$msg        [${red} Failed ${end}]\n"
    exit 1
  fi
}

####### Installation Start

chkStatus "mkdir -p $envDir" "create directories"

pip=$(which pip)
######## Prepare System
chkStatus "sudo yum -y update" "${blu} Updating OS ${end}"
chkStatus "sudo yum -y install git jq" "installing tools"
chkStatus "sudo ${pip} install --upgrade pip" "update pip"
chkStatus "sudo ${pip} install --upgrade awsume" "update/install awsume"

######### Configure GIT
echo "${blu} Input your github user: ${end}"
read GITHUB_USER
export GITHUB_USER=${GITHUB_USER}

echo "${blu} Input your github email: ${end}"
read GITHUB_EMAIL
export GITHUB_EMAIL=${GITHUB_EMAIL}

echo "${red} Input your github access token: ${red}"
read GITHUB_TOKEN
export GITHUB_TOKEN=${GITHUB_TOKEN}

cat >  ~/.netrc <<EOF
machine github.com
login ${GITHUB_USER}
password ${GITHUB_TOKEN}
protocol https

machine gist.github.com
login ${GITHUB_USER}
password ${GITHUB_TOKEN}
protocol https
EOF

chkStatus "git config --global user.name ${GITHUB_USER}" "set git user"
chkStatus "git config --global user.email ${GITHUB_EMAIL}" "set git email"

cd $envDir
if [ -d "cloud-infrastructure-config" ]; then
  chkStatus "cd cloud-infrastructure-config && git pull -q && cd .." "update master-config"
else
  chkStatus "git clone -q -b master-config --single-branch https://github.com/CoreMedia/cloud-infrastructure cloud-infrastructure-config" "clone master-config"
fi

if [ -d "cloud-infrastructure" ]; then
  chkStatus "cd cloud-infrastructure && git pull -q && cd .." "update master-config"
else
  chkStatus "git clone -q https://github.com/CoreMedia/cloud-infrastructure cloud-infrastructure" "clone cloud-infrastructure"
fi
