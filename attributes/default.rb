#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: winrm-config
# Attribute:: default
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

# Below attributes follow the msdn default values
# see https://msdn.microsoft.com/library/aa384372

# Winrm Client default configuration
client_conf = default['winrm_config']['client']
client_conf['AllowUnencrypted'] =                  false
client_conf['Basic'] =                             true
client_conf['Certificate'] =                       true
client_conf['CredSSP'] =                           false
client_conf['Digest'] =                            true
client_conf['Kerberos'] =                          true
client_conf['Negotiate'] =                         true
client_conf['DefaultPorts']['HTTP'] =              5985
client_conf['DefaultPorts']['HTTPS'] =             5986
client_conf['NetworkDelayms'] =                    5000
client_conf['TrustedHosts'] =                      ''
client_conf['URLPrefix'] =                         'wsman'

# Winrm Service default configuration
sddl = 'O:NSG:BAD:P(A;;GA;;;BA)(A;;GR;;;ER)S:P(AU;FA;GA;;;WD)(AU;SA;GWGX;;;WD)'
service_conf = default['winrm_config']['service']
service_conf['AllowUnencrypted'] =                 false
service_conf['Basic'] =                            true
service_conf['Certificate'] =                      true
service_conf['CredSSP'] =                          false
service_conf['Kerberos'] =                         true
service_conf['Negotiate'] =                        true
service_conf['CbtHardeningLevel'] =                'Relaxed'
service_conf['EnableCompatibilityHttpListener'] =  false
service_conf['EnableCompatibilityHttpsListener'] = false
service_conf['EnumerationTimeoutms'] =             60_000
service_conf['IPv4Filter'] =                       '*'
service_conf['IPv6Filter'] =                       '*'
service_conf['MaxConcurrentOperationsPerUser'] =   1500
service_conf['MaxConnections'] =                   25
service_conf['MaxPacketRetrievalTimeSeconds'] =    120
service_conf['RootSDDL'] =                         sddl

# Winrs default configuration
winrs_conf = default['winrm_config']['winrs']
winrs_conf['AllowRemoteShellAccess'] =             true
winrs_conf['IdleTimeout'] =                        180_000
winrs_conf['MaxConcurrentUsers'] =                 5
winrs_conf['MaxMemoryPerShellMB'] =                150
winrs_conf['MaxProcessesPerShell'] =               15
winrs_conf['MaxShellsPerUser'] =                   5

# Winrm Protocol default configuration
protocol_conf = default['winrm_config']['protocol']
protocol_conf['MaxEnvelopeSizekb'] =               150
protocol_conf['MaxTimeoutms'] =                    60_000
protocol_conf['MaxBatchItems'] =                   32_000

# Winrm listeners
listeners = default['winrm_config']['listeners']
listeners['HTTP']['Address'] =                     '*'
listeners['HTTP']['CertificateThumbprint'] =       ''
listeners['HTTP']['Enabled'] =                     true
listeners['HTTP']['Hostname'] =                    ''
listeners['HTTP']['Port'] =                        5985
listeners['HTTP']['Transport'] =                   :HTTP
listeners['HTTP']['URLPrefix'] =                   'wsman'
