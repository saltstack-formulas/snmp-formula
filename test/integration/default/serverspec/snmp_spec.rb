require 'serverspec'
set :backend, :exec

describe service('snmpd') do
  it { should be_running }
end
