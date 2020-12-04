# frozen_string_literal: true

#
# Cookbook:: chef-ubuntu-base
# Spec:: default
#
# The MIT License (MIT)
#
# Copyright:: 2020, Asdrubal Gonzalez
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require "spec_helper"

describe "chef-ubuntu-base::default" do
  context "When all attributes are default, on Ubuntu 20.04" do
    # for a complete list of available platforms and versions see:
    # https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
    platform "ubuntu", "20.04"

    it "converges successfully" do
      expect { chef_run }.to_not raise_error
    end
  end

  # context "When all attributes are default, on CentOS 8" do
  #   # for a complete list of available platforms and versions see:
  #   # https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
  #   platform "centos", "8"
  #
  #   it "converges successfully" do
  #     expect { chef_run }.to_not raise_error
  #   end
  # end
end

escribe "chef-ubuntu-base::default" do
  # converge
  cached(:chef_run) do
    ChefSpec::ServerRunner.new do |node|
      # sysctl/attributes/default.rb will set the config dir
      # on rhel and debian, but apply requires it for notification
      # therefore we set it manually here
      # node.normal["sysctl"]["conf_dir"] = "/etc/sysctl.d"
      # node.normal["cpu"]["0"]["vendor_id"] = "GenuineIntel"
      # node.normal["env"]["extra_user_paths"] = []

      paths = %w[
        /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
      ] + node["env"]["extra_user_paths"]
      paths.each do |folder|
        stub_command(
          "find #{folder}  -perm -go+w -type f | wc -l | egrep '^0$'"
        ).and_return(false)
      end
    end.converge(described_recipe)
  end

  subject { chef_run }
end
