# vim: ft=sls

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
    - mode: 644
    - watch_in:
      - service: {{ snmp.service }}

# Handle creation of SNMPv3 users
{% if conf.get('dynamicconfig') and (conf.get('rousers', [])|length > 0 or conf.get('rwusers', [])|length > 0) %}
  # ensure the utility package is installed
  include:
    - snmp.utils
  
  {% set modes = ['ro', 'rw'] %}
  {% for mode in modes %}
    {% for user in conf.get(mode~'users', []) %}
    # convert auth to 'authNoPriv' and priv to 'authPriv'
    {% set securitylevel = {% if user.get('securitylevel') == 'priv' %}authPriv{% else %}authNoPriv{% endif %} %}
      # test access using snmpget
      snmpv3 test access for {{ user.username }}:
        cmd.run:
          - name: snmpget -v3 -l {{ securitylevel }} -u {{ user.username }} -a {{ user.get('authproto', 'SHA') }} -A {{ user.authpassphrase }} -x {{ user.get('privproto', 'AES') }} {% if securitylevel == "authPriv" %}-X {{ user.privpassphrase }}{% endif %} 127.0.0.1 1.3.6.1.2.1.1.5.0

      # if test fails, stop snmpd, add user to dynamic config, and restart snmpd  
      snmpv3 creating {{ user.username }} step 1 of 3:
        service.stopped:
          - name: {{ snmp.service }}
          onfail:
            - snmpv3 test access for {{ user.username }}:
      
      snmpv3 creating {{ user.username }} step 2 of 3:
        cmd.run:
          - name: echo '{{ v3_createUser_string(user) }}' >> {{ conf.get('dynamicconfig') }}
          - require:
            - snmpv3 creating {{ user.username }} step 1 of 3
      
      snmpv3 creating {{ user.username }} step 2 of 3:
        service.started:
          - name: {{ snmp.service }}
          - require:
            - snmpv3 creating {{ user.username }} step 2 of 3
    {% endfor %}
  {% endfor %}
{% endif %}