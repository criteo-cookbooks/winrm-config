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

winrs_conf = node['winrm_config']['winrs']

winrm_config_winrs 'winrs configuration' do
  enable                     winrs_conf['AllowRemoteShellAccess']
  idle_timeout               winrs_conf['IdleTimeout']
  concurrent_users           winrs_conf['MaxConcurrentUsers']
  process_per_shell          winrs_conf['MaxProcessesPerShell']
  memory_per_shell           winrs_conf['MaxMemoryPerShellMB']
  shell_per_user             winrs_conf['MaxShellsPerUser']
end
