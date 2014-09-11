snmptrap_conf:
  file:
    - managed
    - name: {{ snmp.configtrap }}
    - template: jinja
    - watch_in:
      - service: {{ snmp.servicetrap }}
