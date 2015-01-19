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

client_conf = node['winrm_config']['client']

winrm_config_client 'client configuration' do
  allow_unencrypted          client_conf['AllowUnencrypted']
  basic_auth                 client_conf['Auth']['Basic']
  digest_auth                client_conf['Auth']['Digest']
  kerberos_auth              client_conf['Auth']['Kerberos']
  negotiate_auth             client_conf['Auth']['Negotiate']
  certificate_auth           client_conf['Auth']['Certificate']
  cred_ssp_auth              client_conf['Auth']['CredSSP']
  http_port                  client_conf['DefaultPorts']['HTTP']
  https_port                 client_conf['DefaultPorts']['HTTPS']
  network_delay              client_conf['NetworkDelayms']
  trusted_hosts              client_conf['TrustedHosts']
  url_prefix                 client_conf['URLPrefix']
end
