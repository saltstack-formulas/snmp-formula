{% from "snmp/map.jinja" import snmp with context %}

include:
  - snmp

snmp_conf:
  file:
    - managed
    - name: {{ snmp.lookup.config }}
    - template: jinja
    - context:
      config: {{ snmp.settings }}
    - source: {{ snmp.lookup.source }}
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: {{ snmp.lookup.service }}
