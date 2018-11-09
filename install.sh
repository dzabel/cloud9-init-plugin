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

######## Prepare System
chkStatus "sudo yum -y update" "${blu} Updating OS ${end}"
chkStatus "sudo yum -y install git jq" "installing tools"

######### Configure GIT
echo "${blu} Input your github user ${end} ${blu} (becomes your \"su -\" user for daily work): ${end}"
read GITHUB_USER
export GITHUB_USER=${GITHUB_USER}

echo "${blu} Input your github email: ${end}"
read GITHUB_EMAIL
export GITHUB_EMAIL=${GITHUB_EMAIL}

echo "${red} Input your github access token: ${red}"
read -s GITHUB_TOKEN
export GITHUB_TOKEN=${GITHUB_TOKEN}

chkStatus "git config --global credential.helper \"netrc -f ~/.netrc.gpg -v\"" "configure git credentials store"

echo "${red}choose your gpg password (remember and keep safe): ${end}"
read GPG_PWD

chkStatus "cat >foo <<EOF
     %echo Generating a OpenPGP key
     Key-Type: default
     Key-Length: default
     Name-Real: ${GITHUB_USER}
     Name-Comment: cmoc-developer
     Name-Email: ${GITHUB_EMAIL}
     Expire-Date: 0
     Passphrase: ${GPG_PWD}
     %commit
     %echo done
EOF" "prepare gpg key generation"

chkStatus "gpg --batch --generate-key foo" "generate gpg key"

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

chkStatus "gpg -e -r ${user} ~/.netrc" "encrypt temporary ~/.netrc with your key"
chkStatus "rm -f ~/.netrc" "delete temp ~/.netrc"

curl --silent -o ~/.local/bin/git-credential-netrc https://raw.githubusercontent.com/git/git/master/contrib/credential/netrc/git-credential-netrc

chkStatus "git config --local user.name ${GITHUB_USER}" "set git user"
chkStatus "git config --local user.email ${GITHUB_EMAIL}" "set git email"

cat >~/.profile<<\EOF
# Invoke GnuPG-Agent the first time we login.
# Does ~/.gpg-agent-info exist and points to gpg-agent process accepting signals?
if test -f $HOME/.gpg-agent-info && \
    kill -0 $(cut -d: -f 2 $HOME/.gpg-agent-info) 2>/dev/null; then
    GPG_AGENT_INFO=`cat $HOME/.gpg-agent-info | cut -c 16-`
else
    # No, gpg-agent not available; start gpg-agent
    eval $(gpg-agent --daemon --no-grab --write-env-file $HOME/.gpg-agent-info)
fi
export GPG_TTY=`tty`
export GPG_AGENT_INFO
EOF

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
