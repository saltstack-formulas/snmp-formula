#! python
'''SNMP agent execution module.
This module implements the execution actions related to SNMP.

https://stackoverflow.com/questions/6819399/remove-user-in-snmp-by-agent

Version: 0.0.1

TODO:
- everything

Refs:
'''

import logging

LOGGER = logging.getLogger(__name__)

def check_user(username):
	'''Check user list
	Finds a user in the list of registered users. Returns true if is in the list, false otherwise.
	'''
	with open ('/etc/snmp/snmpd.conf', 'r') as f:
		f_content = f.read()
        #print(f_content)
        value = False
        for  line in f_content:
            if username in line:
                value = True
                break;
            else:
                value = False
        return value

# 	command_str = __salt__['cmd.run']('ls -l')

def add_user(username, authpass, privpass, read_only = False, auth_hash_sha = True, encryption_aes = True):
	'''Add user
	Adds a user to the user list. Returns None.
	'''
	parameters = []

	parameters.append('-ro')
	parameters += ['-A', authpass]
	parameters += ['-a', 'SHA' if auth_hash_sha else 'MD5']
	parameters += ['-X', privpass]
	parameters += ['-x', 'AES' if encryption_aes else 'DES']
    parameters += [username]

	command_str = __salt__['cmd.run']('net-snmp-create-v3-user ' + ' '.join(parameters))

def del_user(username):
	'''Delete user
	Removes a user from the user list. Returns None.
	'''
	command_str = __salt__['cmd.run']('systemctl ' + 'stop ' + 'snmpd.service')

	with open ('/etc/snmp/snmpd.conf', 'r') as f:
        etc_lines = f.readlines()
	with open ('/var/lib/net-snmp/snmpd.conf', 'r') as f1:
        var_lines = f1.readlines()

    with open ('/etc/snmp/snmpd.conf', 'w') as f:
        for line in etc_lines:
            if username not in line.strip("\n"):
                f.write(line)
	with open ('/var/lib/net-snmp/snmpd.conf', 'w') as f1:
        for line in var_lines:
            if 'usmUser' not in line.strip("\n"):
                f1.write(line)
	command_str = __salt__['cmd.run']('systemctl ' + 'start ' + 'snmpd.service')
