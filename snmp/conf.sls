{% from "snmp/map.jinja" import snmp with context %}
{% from "snmp/conf.jinja" import conf with context -%}

include:
  - snmp

  
/usr/local/bin/distro:
  file.managed:
    - user: root
    - group: root
    - mode: 750
    - source: salt://snmp/files/distro

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
    - mode: 644
    - watch_in:
      - service: {{ snmp.service }}
