#
# Cookbook:: container_baseimage
# Recipe:: utilities
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

## Often used tools.
package %w[curl less vim-tiny psmisc gpg-agent dirmngr] do
  action :upgrade
end

link '/usr/bin/vim' do
  to '/usr/bin/vim.tiny'
end

## This tool runs a command as another user and sets $HOME
cookbook_file '/sbin/setuser' do
  source 'setuser'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

## This tool allows installation of apt packages with automatic cache cleanup.
cookbook_file '/sbin/install_clean' do
  source 'install_clean'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end
