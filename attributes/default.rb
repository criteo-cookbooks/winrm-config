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

default['winrm_config']['client'] = {
  'AllowUnencrypted' =>                            false,
  'Auth' => {
    'Basic' =>                                     true,
    'Digest' =>                                    true,
    'Kerberos' =>                                  true,
    'Negotiate' =>                                 true,
    'Certificate' =>                               true,
    'CredSSP' =>                                   false,
  },
  'DefaultPorts' => {
    'HTTP' =>                                      5985,
    'HTTPS' =>                                     5986,
  },
  'NetworkDelayms' =>                              5000,
  'URLPrefix' =>                                   'wsman',
  'TrustedHosts' =>                                '',
}


sddl = 'O:NSG:BAD:P(A;;GA;;;BA)(A;;GR;;;ER)S:P(AU;FA;GA;;;WD)(AU;SA;GWGX;;;WD)'
default['winrm_config']['service'] = {
 'AllowUnencrypted' =>                             false,
 'Auth' => {
    'Basic' =>                                     true,
    'Kerberos' =>                                  true,
    'Negotiate' =>                                 true,
    'Certificate' =>                               true,
    'CredSSP' =>                                   false,
    'CbtHardeningLevel' =>                         'Relaxed',
  },
 'DefaultPorts' => {
    'HTTP' =>                                      5985,
    'HTTPS' =>                                     5986,
  },
 'EnableCompatibilityHttpListener' =>              false,
 'EnableCompatibilityHttpsListener' =>             false,
 'EnumerationTimeoutms' =>                         60000,
 'IPv4Filter' =>                                   '*',
 'IPv6Filter' =>                                   '*',
 'MaxConcurrentOperationsPerUser' =>               1500,
 'MaxConnections' =>                               25,
 'MaxPacketRetrievalTimeSeconds' =>                120,
 'RootSDDL' =>                                     sddl,
}

default['winrm_config']['winrs'] = {
  'AllowRemoteShellAccess' =>                      true,
  'IdleTimeout' =>                                 180000,
  'MaxConcurrentUsers' =>                          5,
  'MaxMemoryPerShellMB' =>                         150,
  'MaxProcessesPerShell' =>                        15,
  'MaxShellsPerUser' =>                            5,
}

default['winrm_config']['protocol'] = {
  'MaxEnvelopeSizekb' =>                           150,
  'MaxTimeoutms' =>                                60000,
  'MaxBatchItems' =>                               32000,
}

default['winrm_config']['listeners'] = {
  'HTTP' => {
    'Address' =>                                   '*',
    'CertificateThumbprint' =>                     nil,
    'Enabled' =>                                   true,
    'Hostname' =>                                  nil,
    'Port' =>                                      5985,
    'Transport' =>                                 'HTTP',
    'URLPrefix' =>                                 'wsman',
    },
}