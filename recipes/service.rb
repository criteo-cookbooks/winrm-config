#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: winrm-config
# Recipe:: service
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

service_conf = node['winrm_config']['service']
registry_key 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WSMAN\Service' do
  action          :create
  recursive       true
  values [
    { name: 'allow_unencrypted',              type: :dword,  data: service_conf['AllowUnencrypted'] ? 1 : 0 },
    { name: 'auth_basic',                     type: :dword,  data: service_conf['Basic'] ? 1 : 0 },
    { name: 'auth_certificate',               type: :dword,  data: service_conf['Certificate'] ? 1 : 0 },
    { name: 'auth_credssp',                   type: :dword,  data: service_conf['CredSSP'] ? 1 : 0 },
    { name: 'auth_kerberos',                  type: :dword,  data: service_conf['Kerberos'] ? 1 : 0 },
    { name: 'auth_negotiate',                 type: :dword,  data: service_conf['Negotiate'] ? 1 : 0 },
    { name: 'cbt_hardening_level',            type: :string, data: service_conf['CbtHardeningLevel'] },
    { name: 'continuedOpTimeoutms',           type: :dword,  data: service_conf['EnumerationTimeoutms'] },
    { name: 'http_compat_listener',           type: :dword,  data: service_conf['EnableCompatibilityHttpListener'] ? 1 : 0 },
    { name: 'https_compat_listener',          type: :dword,  data: service_conf['EnableCompatibilityHttpsListener'] ? 1 : 0 },
    { name: 'IPv4Filter',                     type: :string, data: service_conf['IPv4Filter'] },
    { name: 'IPv6Filter',                     type: :string, data: service_conf['IPv6Filter'] },
    { name: 'maxConcurrentOperationsPerUser', type: :dword,  data: service_conf['MaxConcurrentOperationsPerUser'] },
    { name: 'maxconnections',                 type: :dword,  data: service_conf['MaxConnections'] },
    { name: 'maxPacketRetrievalTime',         type: :dword,  data: service_conf['MaxPacketRetrievalTimeSeconds'] },
    { name: 'rootSDDL',                       type: :string, data: service_conf['RootSDDL'] },
  ]
  notifies :restart, 'service[WinRM]', :delayed
end
