include:
  - snmp

snmp_conf:
  file:
    - managed
    - name: {{ snmp.config }}
    - template: jinja
    - watch_in:
      - service: {{ snmp.service }}
