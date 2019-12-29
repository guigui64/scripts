#!/bin/bash

HOST="frene.astrium.eads.net"

ftpPut() {
    ftp -n $HOST <<END_SCRIPT
user juice_rts abTJ\$EWONhys
cd $1
put $2 $3
quit
END_SCRIPT
}

ftpGet() {
    ftp -n $HOST <<END_SCRIPT
user juice_rts abTJ\$EWONhys
cd $1
get $2
quit
END_SCRIPT
}

