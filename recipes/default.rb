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

log "Adding repositories"

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

apt_repository "virtualbox" do
  arch "amd64"
  cache_rebuild true
  distribution "focal"
  components ["contrib"]
  repo_name "virtualbox"
  uri "https://download.virtualbox.org/virtualbox/debian"
  key ["https://packagecloud.io/slacktechnologies/slack/gpgkey", "https://www.virtualbox.org/download/oracle_vbox.asc"]
  trusted true
end

log "Update the system packages"

apt_update "update"
execute "upgrade" do
  command "apt upgrade -y"
end

log "Installing the basic packages"

node.default["Software"]["base"].each do |pkg|
  apt_package pkg do
    action :install
  end
end

log "Installing the development packages"

node.default["Software"]["development"].each do |devpkg|
  apt_package devpkg do
    action :install
  end
end

log "Installing packages for provisioning"

node.default["Software"]["provisioner"].each do |devpkg|
  apt_package devpkg do
    action :install
  end
end

log "Cretating the Work Environment"

directory "#{ENV['HOME']}/tools" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

remote_file "#{ENV['HOME']}/tools/awscliv2.zip" do
  source "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
  owner "root"
  group "root"
  mode "0755"
  action :create
end
remote_file "#{ENV['HOME']}/tools/zoom_amd64.deb" do
  source "https://zoom.us/client/latest/zoom_amd64.deb"
  owner "root"
  group "root"
  mode "0755"
  action :create
end
remote_file "#{ENV['HOME']}/tools/dbeaver-ce_latest_amd64.deb" do
  source "https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb"
  owner "root"
  group "root"
  mode "0755"
  action :create
end
# ver = %x(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)

remote_file "/usr/local/bin/kubectl" do
  source "https://storage.googleapis.com/kubernetes-release/release/v1.19.0/bin/linux/amd64/kubectl"
  # source "https://storage.googleapis.com/kubernetes-release/release/#{ver}/bin/linux/amd64/kubectl"
  owner "root"
  group "root"
  mode "0777"
  action :create
  not_if {::File.exist?("/usr/local/bin/kubectl")}
end
remote_file "/usr/local/bin/minikube" do
  source "https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64"
  owner "root"
  group "root"
  mode "0777"
  action :create
  not_if {::File.exist?("/usr/local/bin/minikube")}
end
remote_file "#{ENV['HOME']}/tools/installer_linux" do
  source "https://storage.googleapis.com/golang/getgo/installer_linux"
  owner "root"
  group "root"
  mode "0777"
  action :create
end
archive_file "awscliv2.zip" do
  path "#{ENV['HOME']}/tools/awscliv2.zip"
  destination "#{ENV['HOME']}/tools"
  owner "root"
  group "root"
  mode "0755"
  overwrite true
  # not_if { ::Dir.exist?("#{ENV['HOME']}/tools/aws") }
end
execute "install_aws_cli" do
  command "sudo sh #{ENV['HOME']}/tools/aws/install"
  not_if { ::File.exist?("/usr/local/bin/aws") }
end
execute "install_zoom" do
  command "sudo apt install #{ENV['HOME']}/tools/zoom_amd64.deb -y"
  not_if { ::File.exist?("/usr/bin/zoom") }
end
execute "install_Dbeaver" do
  command "sudo apt install #{ENV['HOME']}/tools/dbeaver-ce_latest_amd64.deb -y"
  # not_if { ::File.exist?("/usr/bin/zoom") }
end
# execute "install_Dbeaver" do
#   command "sudo apt install #{ENV['HOME']}/toolsdbeaver-ce_latest_amd64.deb -y"
#   # not_if { ::File.exist?("/usr/bin/zoom") }
# end
# execute "install_golang" do
#   command "sudo sh #{ENV['HOME']}/tools/installer_linux"
# end



execute "pip3 install pip --upgrade"

execute "install_aws_eb_cli" do
  command "pip3 install awsebcli --upgrade"
  not_if { ::File.exist?("/usr/local/bin/eb") }
end

remote_file "#{ENV['HOME']}/tools/nodesource_setup.sh" do
  source "https://deb.nodesource.com/setup_14.x"
  owner "root"
  group "root"
  mode "0755"
  action :create
end

execute "download_nodejs" do
  command "bash #{ENV['HOME']}/tools/nodesource_setup.sh"
  not_if { ::File.exist?("/usr/bin/node") }
end

package "nodejs"
node.default["Software"]["npm"].each do |npm|
  execute "install_npm_packages" do
    command "sudo npm install #{npm}@latest -g"
  end
end

node.default["Software"]["virtualization"]["rdocker"].each do |rdckr|
  apt_package rdckr do
    action :remove
  end
end

node.default["Software"]["hypervisor"].each do |virtual|
  apt_package virtual do
    action :install
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
node.default["Software"]["remove"].each do |rem|
  package rem do
    action :purge
  end
end
cookbook_file "/usr/share/zsh/manjaro-zsh-config" do
  source "manjaro-zsh-config"
  mode "0644"
  action :create
  not_if { ::File.exist?("/usr/share/zsh/manjaro-zsh-config") }
end
cookbook_file "/usr/share/zsh/manjaro-zsh-prompt" do
  source "manjaro-zsh-prompt"
  mode "0644"
  action :create
  not_if { ::File.exist?("/usr/share/zsh/manjaro-zsh-prompt") }
end
cookbook_file "#{ENV['HOME']}/.zshrc" do
  source "zshrc"
  mode "0644"
  action :create
end
cookbook_file "#{ENV['HOME']}/tools/zsh.zip" do
  source "zsh.zip"
  mode "0755"
  action :create
end
archive_file "zsh.zip" do
  path "#{ENV['HOME']}/tools/zsh.zip"
  destination "/usr/share/zsh"
end

execute "chsh -s $(which zsh)"
