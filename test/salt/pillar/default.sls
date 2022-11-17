# -*- coding: utf-8 -*-
# vim: ft=yaml
---
snmp:
  conf:
    sysLocation: 'Right Here'
    sysContact: 'System Admin'
    dontLogTCPWrappersConnects: true
    views:
      - name: all
        type: included
        oid: '.1'
        mask: 80
    rocommunities:
      public:
        source:
          - localhost
          - 192.168.0.0/24
          - 192.168.1.0/24
    rwcommunities:
      private:
        source:
          - 192.168.1.0/24
    rousers:
      - username: 'myv3user'
        authpassphrase: 'myv3password'
        view: all
        authproto: 'SHA'
        privproto: 'AES'
        privpassphrase: 'v3privpass'
