# vim: ft=sls

{% from "snmp/map.jinja" import snmp with context %}

include:
  - snmp

snmp_options:
  file.managed:
    - name: {{ snmp.options }}
    - template: jinja
    - source: {{ snmp.sourceoptions }}
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: {{ snmp.service }}
