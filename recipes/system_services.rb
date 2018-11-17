#
# Cookbook:: container_baseimage
# Recipe:: system_services
#
# Copyright:: 2018, Morton Jonuschat <m.jonuschat@mojocode.de>
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

## Install init process
cookbook_file '/sbin/my_init' do
  source 'my_init'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

%w[/etc/my_init.d /etc/my_init.pre_shutdown.d /etc/my_init.post_shutdown.d].each do |path|
  directory path do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end
end

group 'docker_env' do
  gid 8377
end

%w[/etc/container_environment.sh /etc/container_environment.json].each do |path|
  file path do
    content ''
    owner 'root'
    group 'docker_env'
    mode '0640'
  end
end

link '/etc/profile.d/container_environment.sh' do
  to '/etc/container_environment.sh'
end

package %w[runit tzdata] do
  action :upgrade
end

## Install syslog-ng
if node['container_baseimage']['system_services']['syslog']
  package %w[syslog-ng-core logrotate] do
    action :upgrade
  end

  cookbook_file '/etc/logrotate.conf' do
    source 'logrotate/logrotate.conf'
    owner 'root'
    group 'root'
    mode '0640'
  end

  cookbook_file '/etc/logrotate.d/syslog-ng' do
    source 'logrotate/services/syslog-ng.conf'
    owner 'root'
    group 'root'
    mode '0640'
  end

  cookbook_file '/etc/my_init.d/10_syslog-ng.init' do
    source 'syslog-ng/syslog-ng.init'
    owner 'root'
    group 'root'
    mode '0755'
  end

  cookbook_file '/etc/my_init.post_shutdown.d/10_syslog-ng.shutdown' do
    source 'syslog-ng/syslog-ng.shutdown'
    owner 'root'
    group 'root'
    mode '0755'
  end

  cookbook_file '/etc/default/syslog-ng' do
    source 'syslog-ng/syslog-ng.default'
    owner 'root'
    group 'root'
    mode '0755'
  end

  cookbook_file '/etc/syslog-ng/syslog-ng.conf' do
    source 'syslog-ng/syslog-ng.conf'
    owner 'root'
    group 'root'
    mode '0640'
  end

  directory '/var/lib/syslog-ng' do
    owner 'root'
    group 'root'
    mode '0755'
  end

  file '/var/log/syslog' do
    content ''
    owner 'root'
    group 'root'
    mode '0640'
    action :create_if_missing
  end
end

## Install cron
if node['container_baseimage']['system_services']['cron']
  package 'cron' do
    action :upgrade
  end

  cookbook_file '/etc/pam.d/cron' do
    source 'cron/cron.pam'
    owner 'root'
    group 'root'
    mode '0644'
  end

  file '/etc/crontab' do
    owner 'root'
    group 'root'
    mode '0600'
  end

  %w[
    /etc/cron.daily/standard
    /etc/cron.daily/upstart
    /etc/cron.daily/dpkg
    /etc/cron.daily/password
    /etc/cron.weekly/fstrim
  ].each do |path|
    file path do
      action :delete
    end
  end

  runit_service 'cron' do
    log false
  end
end
