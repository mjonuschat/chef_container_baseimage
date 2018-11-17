#
# Cookbook:: container_baseimage
# Recipe:: prepare
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

# Ensure known /etc/apt/sources.list contents
template '/etc/apt/sources.list' do
  source 'sources.list.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

apt_update 'refresh' do
  action :update
end

## Fix some issues with APT packages.
link '/sbin/initctl' do
  to '/bin/true'
end

## Replace the 'ischroot' tool to make it always return true.
link '/sbin/initctl' do
  to '/bin/true'
end

## Install HTTPS support for APT, add-apt-repository and apt-utils
package %w[apt-transport-https apt-utils ca-certificates software-properties-common] do
  action :upgrade
end

## Ensure the en_US locale is available
package 'language-pack-en' do
  action :upgrade
end

locale 'en_US' do
  lang node['container_baseimage']['locale']['lang']
  lc_all node['container_baseimage']['locale']['lc_ctype']
  action :update
end

## Configure container environment variables
directory '/etc/container_environment' do
  action :create
  owner 'root'
  group 'root'
  mode '0700'
end

file '/etc/container_environment/LANG' do
  content node['container_baseimage']['locale']['lang']
  owner 'root'
  group 'root'
  mode '0644'
end

file '/etc/container_environment/LC_CTYPE' do
  content node['container_baseimage']['locale']['lc_ctype']
  owner 'root'
  group 'root'
  mode '0644'
end
