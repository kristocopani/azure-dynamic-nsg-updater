#!/bin/sh
#cron with log output
echo "$CRON_SCHEDULE /usr/bin/pwsh -File "/app/dynamicnsgupdate.ps1" >> /var/log/cron.log" > /var/spool/cron/crontabs/root

#cron without log output
#echo "$CRON_SCHEDULE /usr/bin/pwsh -File "/app/dynamicnsgupdate.ps1"" > /var/spool/cron/crontabs/root

crond
tail -f /var/log/cron.log