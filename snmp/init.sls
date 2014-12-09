{% from "snmp/map.jinja" import snmp with context %}

snmp:
  pkg:
    - installed
    - name: {{ snmp.lookup.pkg }}
  service:
    - running
    - name: {{ snmp.lookup.service }}
    - enable: true
