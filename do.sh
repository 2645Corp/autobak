#!/bin/bash
#########################################################################
# File Name: do.sh
# Author: ##########
# ###############
# mail: #################
# Created Time: Tue 28 Mar 2017 03:09:24 PM CST
#########################################################################

echo ""
echo "***********************"
echo "Autobak task started at "`date`

source ./autobak.conf

# Dump database
echo "Dumping databases..."

dbdir=`hostname`_db_bak_$(date +%Y%m%d%H%m%s)
mkdir $dbdir

if [[ $DB_DRIVER == "mysql" ]]
then
	for db in ${DBS[@]}
	do
		mysqldump -h$DB_HOST -u$DB_USER -p$DB_PASS $db > $dbdir/$db.sql
	done
fi

echo "Taring all databases..."
tar -cvzf ${dbdir}.tar.gz $dbdir

# Tar files
echo "Taring files..."

fldir=`hostname`_fl_bak_$(date +%Y%m%d%H%m%s)
mkdir $fldir

for fl in ${DIRS[@]}
do
	tar -cvzPf ${fldir}/${fl//\//_}.tar.gz $fl
done

echo "Taring all files..."
tar -cvzf ${fldir}.tar.gz $fldir

# Send files
echo "Sending backups to remotes..."

for rmt in ${REMOTES[@]}
do
	scp ${dbdir}.tar.gz $rmt:${BAK_PATH}
	scp ${fldir}.tar.gz $rmt:${BAK_PATH}
done

echo "We are done! Cleaning up..."
# Clean up

rm -f ${fldir}.tar.gz
rm -f ${dbdir}.tar.gz
rm -rf ${fldir}
rm -rf ${dbdir}

echo "All clear! Now "`date`
echo "***********************"
echo ""
