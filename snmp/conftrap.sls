{% from "snmp/map.jinja" import snmp with context %}

include:
  - snmp

snmptrap_conf:
  file:
    - managed
    - name: {{ snmp.lookup.configtrap }}
    - template: jinja
    - source: {{ snmp.lookup.sourcetrap }}
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: {{ snmp.lookup.servicetrap }}
