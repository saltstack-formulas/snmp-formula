# frozen_string_literal: true

control 'snmp.package.install' do
  title 'The required package should be installed'

  # Overide by platform family
  package_name =
    case system.platform[:family]
    when 'debian'
      'snmpd'
    when 'gentoo'
      'net-analyzer/net-snmp'
    else
      'net-snmp'
    end

  describe package(package_name) do
    it { should be_installed }
  end
end
