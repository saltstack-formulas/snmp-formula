include:
  - snmp

snmptrap_conf:
  file:
    - managed
    - name: {{ snmp.configtrap }}
    - template: jinja
    - source: {{ snmp.sourcetrap }}
    - watch_in:
      - service: {{ snmp.servicetrap }}
