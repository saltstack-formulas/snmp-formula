{% from "snmp/map.jinja" import snmp with context %}

include:
  - snmp

snmp_options:
  file:
    - managed
    - name: {{ snmp.lookup.options }}
    - template: jinja
    - source: {{ snmp.lookup.sourceoptions }}
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: {{ snmp.lookup.service }}
