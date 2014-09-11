include:
  - snmp

trap:
  service:
    - running
    - name: {{ snmp.service }}
    - enable: true
