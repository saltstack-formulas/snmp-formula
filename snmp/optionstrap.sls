{% from "snmp/map.jinja" import snmp with context %}

include:
  - snmp

trap_options:
  file.managed:
    - name: {{ snmp.optionstrap }}
    - template: jinja
    - source: {{ snmp.sourceoptionstrap }}
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: {{ snmp.servicetrap }}
