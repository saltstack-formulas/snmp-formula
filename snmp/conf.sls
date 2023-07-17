{% from "snmp/map.jinja" import snmp with context %}
{% from "snmp/conf.jinja" import conf with context -%}

include:
  - snmp

snmp_conf:
  file.managed:
    - name: {{ snmp.config }}
    - makedirs: True
    - template: jinja
    - context:
      config: {{ conf.get('settings', {}) | json }}
    - source: {{ snmp.source }}
    - user: root
    - group: {{ snmp.rootgroup }}
    - mode: 600
    - watch_in:
      - service: {{ snmp.service }}
