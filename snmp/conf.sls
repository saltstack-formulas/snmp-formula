{% from "snmp/map.jinja" import snmp with context %}

include:
  - snmp

snmp_conf:
  file:
    - managed
    - name: {{ snmp.config }}
    - template: jinja
    - source: {{ snmp.source }}
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: {{ snmp.service }}
