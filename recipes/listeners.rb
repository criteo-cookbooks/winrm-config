#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: winrm-config
# Recipe:: listeners
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

node['winrm_config']['listeners'].each do |key, conf|
  next if conf.nil? || conf.empty?
  winrm_config_listener "#{key} listener configuration" do
    address                    conf['Address']
    enabled                    conf['Enabled']
    certificate_thumbprint     conf['CertificateThumbprint']
    hostname                   conf['Hostname']
    port                       conf['Port']
    transport                  conf['Transport']
    url_prefix                 conf['URLPrefix']
    notifies :restart, 'service[WinRM]', :delayed
  end
end
