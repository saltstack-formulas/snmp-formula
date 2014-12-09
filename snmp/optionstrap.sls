{% from "snmp/map.jinja" import snmp with context %}

include:
  - snmp

trap_options:
  file:
    - managed
    - name: {{ snmp.lookup.optionstrap }}
    - template: jinja
    - source: {{ snmp.lookup.sourceoptionstrap }}
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: {{ snmp.lookup.servicetrap }}
