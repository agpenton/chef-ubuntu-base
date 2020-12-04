# frozen_string_literal: true

require "chefspec"
require "chefspec/policyfile"
require "coveralls"

coverage report
Coveralls.wear!
at_exit { ChefSpec::Coverage.report! }

RSpec.configure do |config|
  # OS and version for mocking of ohai data, needed by chefspec
  config.platform = "ubuntu"
  config.version = "20.04"

  config.before(:each) do
    # we have to stub this, as its executed by the sysctl cookbook
    # dependency as native ruby code
    # see http://stackoverflow.com/questions/24270887/stub-file-open-in-chefspec
    allow(::File).to receive(:exist?).and_call_original
    allow(::File).to receive(:exist?).with("/etc/sysctl.conf").and_return false
  end
end
