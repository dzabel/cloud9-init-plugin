define(function (require, exports, module) {

  module.exports = function (session, options) {

    session.install({
              "name": "System Updater",
              "description": "Installs newest OS Updates",
              "cwd": "~/.c9"
            },
            [
              {
                "bash": 'sudo yum -y update'
              }
            ]);

    session.install({
              "name": "Git Installer",
              "description": "Installs/Configures the git",
              "cwd": "~/.c9"
            },
            [
              {
                "bash": 'sudo yum -y install git'
              },
              {
                "bash": 'git config --global credential.helper store && git config --global user.name dzabel && git config --global user.email daniel.zabel@coremedia.com'
              },
              {
                "bash": 'echo "Input your github access token:\n" && read GITHUB_TOKEN && echo "https://dzabel:${GITHUB_TOKEN}@github.com" > ~/.git-credentials'
              }
            ]
    );
    session.install({
              "name": "Git Repo Init",
              "description": "clone cmoc repos",
              "cwd": "~/.c9",
              "optional": true
            },
            [
              {
                "bash": 'git clone -b master-config --single-branch https://github.com/CoreMedia/cloud-infrastructure cloud-infrastructure-config'
              },
              {
                "bash": 'git clone https://github.com/CoreMedia/cloud-infrastructure cloud-infrastructure'
              }
            ]
    );
    // Show the installation screen
    session.start();
  };

  module.exports.version = 1;

});
