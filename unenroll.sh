#!/bin/bash

OLD_MOODLE=/var/www/html
NEW_MOODLE=$OLD_MOODLE
COURSEIDS=/var/www/moodle-unenrol-users/courseids.txt
USERIDS=/var/www/moodle-unenrol-users/userids.txt
DATABASE=name
COURSE_TOTAL=4200

read -n1 -r -p "Continue with restore? [y/n]" key
if [ "$key" = "y" ]; then

    echo -e "\nStart unenroll\nCTRL+Z or CTRL+C to cancel\n"
    sleep 5
    cd $NEW_MOODLE

    while read COURSEID
    do
		COURSE_TOTAL=$COURSE_TOTAL-1
		COURSE_TIME=$(($COURSE_TOTAL*30))
		myvariable=$(mysql --defaults-extra-file=~/.mysql/mysqldump.cnf "$DATABASE" -se "SELECT DISTINCT u.id FROM mdl_user AS u, mdl_role_assignments AS ra, mdl_context AS cx, mdl_course AS c  WHERE u.id = ra.userid AND ra.contextid = cx.id AND cx.instanceid = c.id AND ra.roleid = 3 AND cx.contextlevel = 50 AND c.id = $COURSEID")
		echo $myvariable | tr " " "\n" > $USERIDS
			while read USERID
			do
					if [ "$USERID" != "" ]; then
						sudo -u apache /var/www/moosh/moosh.php -u admin course-unenrol $COURSEID $USERID
						date -d@$COURSE_TIME -u +%H:%M:%S
					fi
				echo $COURSEID
				echo $COURSEID" "$USERID > unenroll2.txt
			done <$USERIDS
    done < $COURSEIDS

else
    echo -e "\nOperation cancelled\n"
    exit $?
fi
