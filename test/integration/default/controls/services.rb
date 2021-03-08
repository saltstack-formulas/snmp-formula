# frozen_string_literal: true

control 'snmp.service.running' do
  title 'The service should be installed, enabled and running'

  service_name = 'snmpd'

  describe service(service_name) do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end
