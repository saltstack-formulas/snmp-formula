{% from "snmp/map.jinja" import snmp with context %}
{% set mushStamp = salt['grains.get']('osfinger', 'NA') %}

{% if mushStamp in ('Windows-2016Server', 'Windows-2012Server') %}
Core Package:
  win_servermanager.installed:
    - force: True
    - recurse: True
    - name: {{ snmp.pkg }}
    
WMI Poller Package:
  win_servermanager.installed:
    - force: True
    - recurse: True
    - name: {{ snmp.pkgutils }}
{% elif mushStamp in ('Windows-10') %}
Core Package:
  cmd.run:
    - name: 'dism.exe /online /enable-feature /featurename:"SNMP" /featurename:"WMISnmpProvider"'
{% else %}
### Windows 2008r2 Fallback
Core Package:
  cmd.run:
    - name: 'servermanagercmd -install {{ snmp.pkg }} -allSubFeatures'
{% endif %}

#### Location Key
sysLocation:
  cmd.run:
    - name: 'reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\RFC1156Agent" /v sysLocation /t REG_SZ /d "{{ salt['pillar.get']('snmp:conf:location', 'Unknown (add saltstack pillar)') }}" /f'

#### System Contact Key
sysContact:
  cmd.run:
    - name: 'reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\RFC1156Agent" /v sysContact /t REG_SZ /d "{{ salt['pillar.get']('snmp:conf:syscontact', 'Root <root@localhost> (add saltstack pillar)') }}" /f'

{% for manager in snmp.WindowsManager %}
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\PermittedManagers{{ loop.index }}:
  cmd.run:
    - name: 'reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\PermittedManagers" /v {{ loop.index }} /t REG_SZ /d observium.erickson.is /f'
{% endfor %}

# Version 1/2c users (read/write)
#1/1  - None
#2/2  - Notify
#4/4  - Read Only
#8/10 - Read Write
{%- for rwcommunity in salt['pillar.get']('snmp:conf:rwcommunities', '') %}
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\ValidCommunities:
  cmd.run:
    - name: 'reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\ValidCommunities" /v {{ rwcommunity }} /t REG_DWORD /d 10 /f'
{%- endfor -%}

#4/4 - Read Only
{%- for rocommunity in salt['pillar.get']('snmp:conf:rocommunities', '') %}
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\ValidCommunities:
  cmd.run:
    - name: 'reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\ValidCommunities" /v {{ rocommunity }} /t REG_DWORD /d 4 /f'
{% endfor -%}

snmp:
  service.running:
    - reload: True
    - watch:
        - cmd: HKEY_LOCAL_MACHINE/SYSTEM/CurrentControlSet/services/SNMP/Parameters/ValidCommunities
        - cmd: syslocation
        - cmd: sysContact
