describe service('snmpd') do
  it { should be_running }
end

if os.redhat? || os.debian? || os.bsd? || os.suse?
  describe command("snmpget -v3 -l authNoPriv -u myv3user -a SHA -A myv3password -x AES 127.0.0.1 1.3.6.1.2.1.1.5.0 -On") do
    its("stdout") { should match (/.*(sysName|1.3.6.1.2.1.1.5.0).*/) }
  end
end