include:
  - snmp

snmp_conf:
  file:
    - managed
    - name: {{ snmp.options }}
    - template: jinja
    - watch_in:
      - service: {{ snmp.service }}
