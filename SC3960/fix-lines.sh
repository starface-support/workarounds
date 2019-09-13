#!/bin/bash

# Revert URLencode in the database
/usr/bin/psql asterisk -c "UPDATE providerconfig SET register = REPLACE(register,'%2B','+');"
/usr/bin/psql asterisk -c "UPDATE providerconfig SET username = REPLACE(username,'%2B','+');"

# Replace all instanced of "%2B" in the sip.conf, while creating a backup ("_SC3960.bak")
/bin/sed -i_SC3960.bak "s/%2B/+/g" /etc/asterisk/sip.conf

# Show the difference
echo "Here's what we've done:"
/usr/bin/diff -U0 /etc/asterisk/sip.conf_SC3960.bak /etc/asterisk/sip.conf

# Reload the Asterisk SIP config to reregister all lines
/usr/sbin/asterisk -r -x "sip reload"