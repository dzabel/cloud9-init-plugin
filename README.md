# AWS Cloud9 CMOC Init Plugin

A plugin for setting up a development environment.

## init plugin
services.pluginManager.loadPackage([
"https://raw.githubusercontent.com/dzabel/cloud9-init-plugin/master/install.js"
]);

## add Terraform Support
1. In your Cloud9 IDE, go to AWS Cloud9 -> Open Your Init Script

2. Modify your init script to look like:
services.pluginManager.loadPackage([
"https://raw.githubusercontent.com/dzabel/cloud9-init-plugin/master/install.js",
"https://raw.githubusercontent.com/dr-scoots/plugin.ide.language.terraform/master/plugin.ide.language.terraform.js"
]);

3. Save your init.js and reload Cloud9 in your browser

4. Go to View -> Syntax and scroll down. You'll see Terraform as an option.
