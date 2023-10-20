#!/bin/bash
#
# John Chung - Nyquest Consulting
# https://www.nyquest.com
#
# fixssb v0.1 (CAS)
# $1 is the filename
# $2 is the CAS Server + port
# $3 is the App Server name (BANNER9_HOST:PORT)
# $4 is the instance name (e.g. PPRD, SEED, PROD etc)
# $5 is the pagebuilder directory
# $6 is optional if set to the location of the banner_configuration.groovy file, then enable "Comm_man data source"
#
show_usage() {
 /bin/echo ""
 /bin/echo "fixssb.sh v0.1 (CAS) Script to make substitions into AppNav and Banner 9 SSB files prior to deployment"
 /bin/echo "---------------------------------------------------------------------------------"
 /bin/echo "Usage: fixssb.sh [groovy file] [CAS:PORT] [AppURL:PORT] [DB Instance NAME] [pbRoot] [(optional) path to UPDATED banner_configuration.groovy - to enable commmgr data source]"
 /bin/echo "Example: fixssb.sh applicationNavigator_configuration.groovy eis.myuniv.edu admtest.myuniv.edu:5552 PROD /u01/apps/SID/pbRoot /u01/app/PROD/shared_configuration/banner_configuration.groovy.commmgr"
 /bin/echo
 /bin/echo "Leave port blank if using default port 443"
 /bin/echo ""
 /bin/echo "Nyquest Consulting https://www.nyquest.com"
 exit 1
}

if [ "$#" -lt "5" ]; then
 show_usage
fi

if ! [ -f ${1}.original ]; then
 /bin/cp ${1} ${1}.original 
fi

export APPNAME=`basename $1 | awk -F_ '{print $1}'`
sed -i -e 's/http:/https:/g'  $1
sed -i -e "s/CAS_HOST:PORT/$2/g"  $1
sed -i -e "s/APP_NAME/$APPNAME/g"  $1
sed -i -e "s/BANNER9_HOST:PORT/$3/g"  $1
sed -i -e "s|serverUrlPrefix = |serverUrlPrefix = \'https://$2/cas\' //|g" $1
sed -i -e "s/APPLICATION_NAVIGATOR_HOST:PORT/$3/g"  $1
sed -i -e "s/Ellucian DataBase/$4/gi"  $1
sed -i -e "s/Ellucian University/$4/gi"  $1
sed -i -e 's/targetServer="weblogic"/targetServer="tomcat"/g' $1
sed -i -e "s/'default'/'cas'/g" $1
# sed -i -e "s/active = false/active = true/g" $1
# the following logic was changed to allow for variable spaces between active = false
sed -i  -r 's/\ active\ +\=\ +false/\ active = true/g' $1
sed -i -e "s|^pbRoot =|pbRoot = \"${5}\" //|g" $1
sed -i -e "s|extensions = |extensions = \"${5}/extensions\" //|g" $1
sed -i -e "s|resources = |resources = \"${5}/resources\" //|g"  $1
sed -i -e "s|afterLogoutUrl|afterLogoutUrl = 'https://$2/cas/logout' //|g"  $1


if [ ! -z $6 ]; then 
 /bin/cp $6 banner_configuration.groovy
 sed -i -e 's|commmgrDataSourceEnabled|commmgrDataSourceEnabled = true //|g' $1
 sed -i -e 's|^general.aip.enabled|general.aip.enabled = true //|g' $1
fi
