# frozen_string_literal: true

control 'snmp.config.file' do
  title 'Verify the configuration file'

  # Overide by platform family
  config_file, root_group =
    case platform[:family]
    when 'bsd'
      %w[/usr/local/etc/snmp/snmpd.conf wheel]
    else
      %w[/etc/snmp/snmpd.conf root]
    end

  describe file(config_file) do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into root_group }
    its('mode') { should cmp '0644' }
    its('content') { should include 'syslocation Right Here' }
    its('content') { should include 'syscontact System Admin' }
    its('content') { should include 'dontLogTCPWrappersConnects yes' }
    its('content') { should include 'view all included .1 80' }
    its('content') { should include 'rocommunity     public       localhost' }
    its('content') { should include 'rocommunity     public       192.168.0.0/24' }
    its('content') { should include 'rocommunity     public       192.168.1.0/24' }
    its('content') { should include 'rwcommunity     private       192.168.1.0/24' }
    its('content') { should include 'rouser myv3user auth -V all' }
    its('content') do
      should include 'createUser myv3user SHA myv3password AES v3privpass'
    end
  end
end
