#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: winrm-config
# Recipe:: winrs
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

winrs_conf = node['winrm_config']['winrs']
registry_key 'Setting up winrs' do
  key       'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WSMAN\Client'
  action    :create
  recursive true
  values [
    { name: 'AllowRemoteShellAccess', type: :dword, data: winrs_conf['AllowRemoteShellAccess'] ? 1 : 0 },
    { name: 'IdleTimeout',            type: :dword, data: winrs_conf['IdleTimeout'] },
    { name: 'MaxConcurrentUsers',     type: :dword, data: winrs_conf['MaxConcurrentUsers'] },
    { name: 'MaxProcessesPerShell',   type: :dword, data: winrs_conf['MaxProcessesPerShell'] },
    { name: 'MaxMemoryPerShellMB',    type: :dword, data: winrs_conf['MaxMemoryPerShellMB'] },
    { name: 'MaxShellsPerUser',       type: :dword, data: winrs_conf['MaxShellsPerUser'] },
  ]
  notifies :restart, 'service[WinRM]', :delayed
end
