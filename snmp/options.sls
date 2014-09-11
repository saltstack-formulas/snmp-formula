include:
  - snmp

snmp_conf:
  file:
    - managed
    - name: {{ snmp.options }}
    - template: jinja
    - source: {{ snmp.sourceoptions }}
    - watch_in:
      - service: {{ snmp.service }}
