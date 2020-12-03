# frozen_string_literal: true

#
# Cookbook:: chef-ubuntu-base
# Recipe:: default
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
#

apt_update "update" do
  action :nothing
end

apt_repository "hashicorp" do
  arch "amd64"
  cache_rebuild true
  distribution "focal"
  key "https://apt.releases.hashicorp.com/gpg"
  components ["main"]
  repo_name "hashicorp"
  uri "https://apt.releases.hashicorp.com"
  trusted true
end
apt_repository "atom" do
  arch "amd64"
  cache_rebuild true
  distribution "any"
  key "https://packagecloud.io/AtomEditor/atom/gpgkey"
  components ["main"]
  repo_name "atom"
  uri "https://packagecloud.io/AtomEditor/atom/any"
  trusted true
end

apt_repository "docker" do
  arch "amd64"
  cache_rebuild true
  distribution "focal"
  key "https://download.docker.com/linux/ubuntu/gpg"
  components ["stable"]
  repo_name "docker"
  uri "https://download.docker.com/linux/ubuntu"
  trusted true
end

apt_repository "github" do
  arch "amd64"
  cache_rebuild true
  distribution "focal"
  components ["main"]
  repo_name "github"
  uri "https://cli.github.com/packages"
  keyserver "keyserver.ubuntu.com"
  key "C99B11DEB97541F0"
  trusted true
end

apt_repository "slack" do
  # arch "amd64"
  cache_rebuild true
  distribution "jessie"
  components ["main"]
  repo_name "slack"
  uri "https://packagecloud.io/slacktechnologies/slack/debian"
  key "https://packagecloud.io/slacktechnologies/slack/gpgkey"
  trusted true
end
# apt_repository "teams" do
#   arch "amd64"
#   cache_rebuild true
#   distribution "stable"
#   components ["main"]
#   repo_name "teams"
#   uri "https://packages.microsoft.com/repos/ms-teams"
#   key "https://packagecloud.io/slacktechnologies/slack/gpgkey"
#   trusted true
# end
apt_update "update"
execute "upgrade" do
  command "apt upgrade -y"
end
node.default["Software"]["base"].each do |pkg|
  apt_package pkg do
    action :install
  end
end
node.default["Software"]["development"].each do |devpkg|
  apt_package devpkg do
    action :install
  end
end
directory "/home/vagrant/tools" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end
remote_file "/home/vagrant/tools/awscliv2.zip" do
  source "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
  owner "root"
  group "root"
  mode "0755"
  action :create
end
archive_file "awscliv2.zip" do
  path "/home/vagrant/tools/awscliv2.zip"
  destination "/home/vagrant/tools"
  owner "root"
  group "root"
  mode "0755"
  overwrite true
  # not_if { ::Dir.exist?("/home/vagrant/tools/aws") }
end
execute "install_aws_cli" do
  command "sudo sh /home/vagrant/tools/aws/install"
  not_if { ::File.exist?("/usr/local/bin/aws") }
end

execute "pip3 install pip --upgrade"

execute "install_aws_eb_cli" do
  command "pip3 install awsebcli --upgrade"
  not_if { ::File.exist?("/usr/local/bin/eb") }
end

remote_file "/home/vagrant/tools/nodesource_setup.sh" do
  source "https://deb.nodesource.com/setup_14.x"
  owner "root"
  group "root"
  mode "0755"
  action :create
end

execute "download_nodejs" do
  command "bash /home/vagrant/tools/nodesource_setup.sh"
  not_if { ::File.exist?("/usr/bin/node") }
end

package "nodejs"
node.default["Software"]["npm"].each do |npm|
  execute "install_npm_packages" do
    # command "sudo npm install npm@latest aws-cdk@latest jest@latest typescript@latest -g"
    command "sudo npm install #{npm}@latest -g"
  end
end
# %w{docker docker-engine docker.io containerd runc}.each do |dckr|

node.default["Software"]["virtualization"]["rdocker"].each do |rdckr|
  apt_package rdckr do
    action :remove
  end
end

node.default["Software"]["virtualization"]["docker"].each do |dckr|
  apt_package dckr do
    action :install
  end
end

service "docker" do
  supports status: true, restart: true, reload: true
  action %i[enable start]
end

node.default["Software"]["atom"]["extension"].each do |apm|
  execute "install_Atom_packages" do
    command "apm install #{apm}"
  end
end
