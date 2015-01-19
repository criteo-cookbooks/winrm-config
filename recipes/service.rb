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

service_conf = node['winrm_config']['service']

winrm_config_service 'service configuration' do
  allow_unencrypted          service_conf['AllowUnencrypted']
  basic_auth                 service_conf['Auth']['Basic']
  kerberos_auth              service_conf['Auth']['Kerberos']
  negotiate_auth             service_conf['Auth']['Negotiate']
  certificate_auth           service_conf['Auth']['Certificate']
  cred_ssp_auth              service_conf['Auth']['CredSSP']
  cbt_hardening_level        service_conf['Auth']['CbtHardeningLevel']
  http_port                  service_conf['DefaultPorts']['HTTP']
  https_port                 service_conf['DefaultPorts']['HTTPS']
  concurrence_per_user       service_conf['MaxConcurrentOperationsPerUser']
  enumeration_timeout        service_conf['EnumerationTimeoutms']
  http_compatibility         service_conf['EnableCompatibilityHttpListener']
  https_compatibility        service_conf['EnableCompatibilityHttpsListener']
  ipv4_filter                service_conf['IPv4Filter']
  ipv6_filter                service_conf['IPv6Filter']
  max_connections            service_conf['MaxConnections']
  receive_timeout            service_conf['MaxPacketRetrievalTimeSeconds']
  root_sddl                  service_conf['RootSDDL']
end
