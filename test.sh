#!/bin/bash

COURSEID=4081
myvariable=$(mysql --defaults-extra-file=~/.mysql/mysqldump.cnf "$DATABASE" -se "SELECT DISTINCT u.id FROM mdl_user AS u, mdl_role_assignments AS ra, mdl_context AS cx, mdl_course AS c  WHERE u.id = ra.userid AND ra.contextid = cx.id AND cx.instanceid = c.id AND ra.roleid = 3 AND cx.contextlevel = 50 AND c.id = $COURSEID")

echo $myvariable | tr " " "\n"
