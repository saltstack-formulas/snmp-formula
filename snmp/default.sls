# vim: ft=sls

{% from "snmp/map.jinja" import snmp with context %}

include:
  - snmp

default_snmpd:
  file.managed:
    - name: {{ snmp.configdefault }}
    - template: jinja
    - source: {{ snmp.sourcedefault }}
    - user: root
    - group: root
    - mode: 644
    - watch:
      - service: {{ snmp.service }}
