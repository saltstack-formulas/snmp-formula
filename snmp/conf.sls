{% from "snmp/map.jinja" import snmp with context %}

include:
  - snmp

snmp_conf:
  file:
    - managed
    - name: {{ snmp.config }}
    - template: jinja
    - source: {{ snmp.source }}
    - watch_in:
      - service: {{ snmp.service }}
