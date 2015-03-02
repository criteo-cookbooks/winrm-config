#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: winrm-config
# Recipe:: client
#
# Copyright:: Copyright (c) 2015 Criteo.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

return unless platform? 'windows'

include_recipe 'winrm-config::windows_service'

client_conf = node['winrm_config']['client']
registry_key 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WSMAN\Client' do
  action    :create
  recursive true
  values [
    { name: 'allow_unencrypted',  type: :dword,  data: client_conf['AllowUnencrypted'] ? 1 : 0 },
    { name: 'auth_basic',         type: :dword,  data: client_conf['Basic'] ? 1 : 0 },
    { name: 'auth_certificate',   type: :dword,  data: client_conf['Certificate'] ? 1 : 0 },
    { name: 'auth_credssp',       type: :dword,  data: client_conf['CredSSP'] ? 1 : 0 },
    { name: 'auth_digest',        type: :dword,  data: client_conf['Digest'] ? 1 : 0 },
    { name: 'auth_kerberos',      type: :dword,  data: client_conf['Kerberos'] ? 1 : 0 },
    { name: 'auth_negotiate',     type: :dword,  data: client_conf['Negotiate'] ? 1 : 0 },
    { name: 'defaultports_http',  type: :dword,  data: client_conf['DefaultPorts']['HTTP'] },
    { name: 'defaultports_https', type: :dword,  data: client_conf['DefaultPorts']['HTTPS'] },
    { name: 'network_delay',      type: :dword,  data: client_conf['NetworkDelayms'] },
    { name: 'trusted_hosts',      type: :string, data: client_conf['TrustedHosts'] },
    { name: 'url_prefix',         type: :string, data: client_conf['URLPrefix'] },
  ]
  notifies :restart, 'service[WinRM]', :delayed
end
