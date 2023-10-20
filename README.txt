fixssb.sh v0.1 (CAS) Script to make substitions into AppNav and Banner 9 SSB files prior to deployment
---------------------------------------------------------------------------------

This is a very simple script to make edits to various Banner 9 SSB configuration files which are needed prior to deployment

Usage: fixssb.sh [groovy file] [CAS:PORT] [AppURL:PORT] [DB Instance NAME] [pbRoot] [(optional) path to UPDATED banner_configuration.groovy - to enable commmgr data source]

Example: fixssb.sh applicationNavigator_configuration.groovy eis.myuniv.edu admtest.myuniv.edu:5552 PROD /u01/apps/SID/pbRoot /u01/app/PROD/shared_configuration/banner_configuration.groovy.commmgr

Leave port blank if using default port 443

Nyquest Consulting https://www.nyquest.com

