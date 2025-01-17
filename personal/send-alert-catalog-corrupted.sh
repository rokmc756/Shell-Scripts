#!/bain/bash
#
# There are situations that catalog get corrupted once or twice a week repeatedly.
# Is there any notification feature through email when it occurs in GPDB?
# Actually there is no notification feature when catalog get corrupted in GPDB.
# Basically there should be regular schedule to run gpcheckcat especially in non-peak hours
# and check catalog corruptions searching 'FAIL' or 'ERROR' in the gpcheckat log, all these are always performed manually.
# However the following script can be implemented so that alerting warning message can be sent through email when catalog
# gets corrupted in any database.

# yum install ssmtp mailx -y

GPCHECKCAT_DIR="/home/gpadmin/gpAdminLogs"
TO_EMAIL="your_id@your_company.com"
FROM_EMAIL="your_smtp_user_id@your_smtp_server_addr.com"
SMTP_ADDR="smtp.your_company.com:587"
SMTP_USER="smtp_user"
SMTP_USER_PASS="changeme"

function send_alert_catalog_corrupted {

  echo "Catalog corrupted in $1 database" | \
  mailx -v -r "$FROM_EMAIL" \
  -s "[WARNING] Catalog corruption in $1 database" \
  -S smtp="$SMTP_ADDR" \
  -S smtp-use-starttls \
  -S smtp-auth=login -S smtp-auth-user="$SMTP_USER" \
  -S smtp-auth-password="$SMTP_USER_PASS" \
  -S ssl-verify=ignore \
  -S nss-config-dir="/etc/pki/nssdb/" \
  $TO_EMAIL < "$2"

}

for dbname in `psql -tc "SELECT datname FROM pg_database;" | tail -n +3 | head -n -2 | egrep -v 'template0|template1|postgres'`
do

  $GPHOME/bin/lib/gpcheckcat -O $dbname > $GPCHECKCAT_DIR/gpcheckcat_"$dbname"_"$(date +%Y%m%d)".log
   IS_CORRUPTED=`grep -E "ERROR|FAIL" $GPCHECKCAT_DIR/gpcheckcat_"$dbname"_"$(date +%Y%m%d).log" | wc -l`
  if [ "$IS_CORRUPTED" -gt "1" ]; then
    send_alert_catalog_corrupted $dbname $GPCHECKCAT_DIR/gpcheckcat_"$dbname"_"$(date +%Y%m%d)".log
  else
    echo "No catalog corruptions in $dbname database"
  fi

done

# Add this script to crontab so that it can be run automatically based on your plan. The following example is to run the script every 5:30 A.M. everyday and report catalog status through email.
# chmod 755 /home/gpadmin/send_alert_catalog_corrupted.sh
# crontab -e
# 30 0 * * * /home/gpadmin/send_alert_catalog_corrupted.sh

