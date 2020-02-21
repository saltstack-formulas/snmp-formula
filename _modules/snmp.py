#! python
'''SNMP agent execution module.
This module implements the execution actions related to SNMP.

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
	
# 	command_str = __salt__['cmd.run']('ls -l')
	
	pass
	
def add_user(username, authpass, privpass, read_only = False, auth_hash_sha = True, encryption_aes = True):
	'''Add user
	Adds a user to the user list. Returns None.
	'''
	pass
	
def del_user(username):
	'''Delete user
	Removes a user from the user list. Returns None.
	'''
	pass