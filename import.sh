#!/bin/bash
FILE="/mnt/Users.csv"
DOMAIN="AU-TEAM.IRPO"
ADMIN_USER="Administrator"
ADMIN_PASS="P@ssw0rd"

while IFS=';' read -r fname lname role phone ou street zip city country password; do
	if [[ "$fname" == "First Name" ]]; then
		continue
	fi
	username=$(echo "$fname:0:1)${lname}" | tr '[:upper:]' '[:lower:]')
	samba-tool ou create "OU=${ou},DC=AU-TEAM,DC=IRPO" --description="${ou} department"
	echo "Adding user: $username in OU=$ou"
	samba-tool user add "$username" "$password" --given-name="$fname" --surname="$lname" \
	--job-title="$role" --telephone-number="$phone" \
	--userou="OU=$ou"
done < "${FILE}"
echo "Complite import"
