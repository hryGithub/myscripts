#!/bin/bash

USER=
PASSWORD=

SRCDIR=/application/tempforupdate/
DESDIR=/onlineshop/DailyFiles/

#IP
IP=

PORT=22

cd ${SRCDIR}
FILES=`ls`


for FILE in ${FILES};do
	echo ${FILE}
	lftp -u ${USER},${PASSWORD} sftp://${IP}:${PORT} <<EOF
		cd ${DESDIR}
		lcd ${SRCDIR}
		put ${FILE}
		bye
EOF
done
