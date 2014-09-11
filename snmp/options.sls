{% from "snmp/map.jinja" import snmp with context %}

include:
  - snmp

snmp_options:
  file:
    - managed
    - name: {{ snmp.options }}
    - template: jinja
    - source: {{ snmp.sourceoptions }}
    - watch_in:
      - service: {{ snmp.service }}
