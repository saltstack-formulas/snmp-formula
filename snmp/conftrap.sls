include:
  - snmp

snmptrap_conf:
  file:
    - managed
    - name: {{ snmp.configtrap }}
    - template: jinja
    - source: {{ snmp.sourcetrap }}
    - user: root
    - group: root
    - mode: 600
    - watch_in:
      - service: {{ snmp.servicetrap }}
