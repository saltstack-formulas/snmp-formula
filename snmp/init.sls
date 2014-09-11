snmp:
  pkg:
    - installed
    - name: {{ snmp.pkg }}
  service:
    - running
    - name: {{ snmp.service }}
    - enable: true
