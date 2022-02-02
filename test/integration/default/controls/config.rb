# frozen_string_literal: true

control 'snmp.config.file' do
  title 'Verify the configuration file'

  # Override by platform family
  config_file, root_group =
    case platform[:family]
    when 'bsd'
      %w[/usr/local/etc/snmp/snmpd.conf wheel]
    else
      %w[/etc/snmp/snmpd.conf root]
    end

  # Override for persistent config file
  create_user_str =
    case platform[:family]
    when 'debian'
      'createUser string will be added to /var/lib/snmp/snmpd.conf'
    when 'redhat'
      'createUser string will be added to /var/lib/net-snmp/snmpd.conf'
    else
      'createUser myv3user SHA myv3password AES v3privpass'
    end

  describe file(config_file) do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into root_group }
    its('mode') { should cmp '0644' }
    its('content') { should include 'sysLocation Right Here' }
    its('content') { should include 'sysContact System Admin' }
    its('content') { should include 'dontLogTCPWrappersConnects yes' }
    its('content') { should include 'view all included .1 80' }
    its('content') { should include 'rocommunity     public       localhost' }
    its('content') { should include 'rocommunity     public       192.168.0.0/24' }
    its('content') { should include 'rocommunity     public       192.168.1.0/24' }
    its('content') { should include 'rwcommunity     private       192.168.1.0/24' }
    its('content') { should include 'rouser myv3user auth -V all' }
    its('content') do
      should include create_user_str
    end
  end
end
