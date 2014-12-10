{% from "snmp/map.jinja" import snmp with context %}

include:
  - snmp

default_snmpd:
  file:
    - managed
    - name: {{ snmp.lookup.configdefault }}
    - template: jinja
    - source: {{ snmp.lookup.sourcedefault }}
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: {{ snmp.lookup.service }}
