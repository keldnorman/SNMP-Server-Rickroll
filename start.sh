#!/bin/bash
#set -x
if [ -t 1 ]; then clear ; fi
#-------------------------------------------------
# Description
#-------------------------------------------------
# RICK ROLL SNMP SCRIPT
# 
# git clone https://github.com/delimitry/snmp-server.git # (python2.7)
# 
# install extra pip modules if missing: 
# 
# python2.7 -m pip install colorterm  ( or termcolor ) ?
# python2.7 -m pip install xxxx
# 
# ADD TO CRONTAB:
#
# @reboot   /root/source/SNMP-Python/start.sh > /var/log/snmp-python-rickroll.log 2>&1
# * * * * * /root/source/SNMP-Python/start.sh > /var/log/snmp-python-rickroll.log 2>&1
#
#-------------------------------------------------
# SNMP-SERVER (PYTHON) INSTALLED HERE:
#-------------------------------------------------
WORK_DIR="/root/source/SNMP-Python/snmp-server"
#-------------------------------------------------
# Banner (A Must for 1337'ishness):
#-------------------------------------------------
if [ -t 1 ]; then 
cat << "EOF"

  ____
 /\' .\    _____
/: \___\  / .  /\
\' / . / /____/..\
 \/___/  \'  '\  /
          \'__'\/ 

 SNMP RICK ROLL 
EOF
fi
#-------------------------------------------------
# PRE
#-------------------------------------------------
# RUN AS ROOT
if [ ${EUID} -ne 0 ]; then
 if [ -t 1 ]; then 
  printf "\n ### ERROR - This script must have root persmissions (perhaps use sudo)\n\n"
  exit 1
 fi
fi
# CHECK WORK DIR EXIST
if [ ! -d ${WORK_DIR} ]; then
 if [ -t 1 ]; then 
  printf "\n ### ERROR - Cant find ${WORK_DIR}\n\n"
 fi
 exit 1
fi
# CHECK PYTHON SCRIPT EXIST
if [ ! -f ${WORK_DIR}/snmp-server.py ]; then
 if [ -t 1 ]; then 
  printf "\n ### ERROR - Cant find ${WORK_DIR}/snmp-server.py\n\n"
 fi
 exit 1
fi
#-------------------------------------------------
# VARIABLES
#-------------------------------------------------
PROGNAME=${0##*/}
LOCKFILE="/var/run/${PROGNAME%%.*}.pid"
#-------------------------------------------------
# TRAP
#-------------------------------------------------
trap '
 echo ""
' EXIT 1
#-------------------------------------------------
# Ensure script does not run in parallel
#-------------------------------------------------
# Check for lock file and process running 
if [ -e ${LOCKFILE} ]; then # There is a lockfile
 OLD_PROCESS_PID="$(cat ${LOCKFILE})"
 PROCESS_FOUND="$(ps -p ${OLD_PROCESS_PID} -o pid|grep -cv PID)"
 if [ ${PROCESS_FOUND} -ne 0 ];then # Check if old process is running
  # The PID found in the lockfile is running
  if [ -t 1 ]; then 
   echo ""
   echo "### ERROR - Lockfile ${LOCKFILE} exist."
   echo "            This script is already running with PID: ${OLD_PROCESS_PID}"
  fi
  # logger "Script $0 failed - lock file exist - please investigate"
  exit 3
 else # The PID found in the lockfile is NOT running - Remove the lock file
  /bin/rm ${LOCKFILE} >/dev/null 2>&1
 fi
fi
# Create new lock file
echo $$ > $LOCKFILE
#-------------------------------------------------
# MAIN
#-------------------------------------------------
cd ${WORK_DIR}
if [ ! -f ../config.cfg ]; then 
 cat << "EOF" > ../config.cfg
DATA = {
  '1.3.6.1.2.1' : octet_string("We're no strangers to love\nYou know the rules and so do I\nA full commitment's what I'm thinking of\nYou wouldn't get this from any other guy\nI just wanna tell you how I'm feeling\nGotta make you understand\nNever gonna give you up\nNever gonna let you down\nNever gonna run around and desert you\nNever gonna make you cry\nNever gonna say goodbye\nNever gonna tell a lie and hurt you\nWe've known each other for so long\nYour heart's been aching but you're too shy to say it\nInside we both know what's been going on\nWe know the game and we're gonna play it\nAnd if you ask me how I'm feeling\nDon't tell me you're too blind to see\nNever gonna give you up\nNever gonna let you down\nNever gonna run around and desert you\nNever gonna make you cry\nNever gonna say goodbye\nNever gonna tell a lie and hurt you\nNever gonna give you up\nNever gonna let you down\nNever gonna run around and desert you\nNever gonna make you cry\nNever gonna say goodbye\nNever gonna tell a lie and hurt you\nNever gonna give, never gonna give\n(Give you up)\nWe've known each other for so long\nYour heart's been aching but you're too shy to say it\nInside we both know what's been going on\nWe know the game and we're gonna play it\nI just wanna tell you how I'm feeling\nGotta make you understand\nNever gonna give you up\nNever gonna let you down\nNever gonna run around and desert you\nNever gonna make you cry\nNever gonna say goodbye\nNever gonna tell a lie and hurt you\nNever gonna give you up\nNever gonna let you down\nNever gonna run around and desert you\nNever gonna make you cry\nNever gonna say goodbye\nNever gonna tell a lie and hurt you\nNever gonna give you up\nNever gonna let you down\nNever gonna run around and desert you\nNever gonna make you cry\nNever gonna say goodbye\n"),
  '1.3.6.1.4.1.1.1.0': integer(31337),
  '1.3.6.1.4.1.1.2.0': bit_string('\x13\x37\x13\x37'),
  '1.3.6.1.4.1.1.3.0': octet_string('Rick Roll'),
  '1.3.6.1.4.1.1.4.0': null(),
  '1.3.6.1.4.1.1.5.0': object_identifier('1.3.6.7.8.9'),
  '1.3.6.1.4.1.1.6.*': lambda oid: octet_string('* {}'.format(oid)),
  '1.3.6.1.4.1.1.7.0': double(31337.1337),
  '1.3.6.1.4.1.1.8.0': integer(1, 3),
  '1.3.6.1.4.1.1.?.0': lambda oid: octet_string('? {}'.format(oid)),
  '1.3.6.1.4.1.2.1.0': real(3.1337),
  '1.3.6.1.4.1.3.1.0': double(31337.1337),
}
EOF
fi
#-------------------------------------------------
# RUN
#-------------------------------------------------
if [ -t 1 ]; then echo ""; fi
${WORK_DIR}/snmp-server.py --config ../config.cfg
#-------------------------------------------------
# END OF SCRIPT
#-------------------------------------------------
