# SNMP-Server-Rickroll
Rickroll SNMP server
```
Original source code:  git clone https://github.com/delimitry/snmp-server.git 

# install extra pip modules if missing: 

python2.7 -m pip install colorterm  ( or termcolor ) ?
python2.7 -m pip install xxxx

or if using python3 just use: pip install xxxxx
 
# ADD TO CRONTAB:

@reboot   /root/source/SNMP-Python/start.sh > /var/log/snmp-python-rickroll.log 2>&1
* * * * * /root/source/SNMP-Python/start.sh > /var/log/snmp-python-rickroll.log 2>&1

# Start: 

./start.sh
```
![start](https://github.com/keldnorman/SNMP-Server-Rickroll/raw/main/start.png)

```
# Test: 

snmpwalk -c public -v 2c your-ip-here
```
![test](https://github.com/keldnorman/SNMP-Server-Rickroll/raw/main/run.png)

```
# Watch out for the possibility to alter your string  ( you must alter the code to stop this or block snmp write in your firewall )

snmpset -v2c -c public localhost .1.3.6.1.2.1 s "Pwned"

```


