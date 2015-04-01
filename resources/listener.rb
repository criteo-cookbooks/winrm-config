#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: winrm-config
# Resource:: listener
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

default_action :configure
actions :configure, :delete

attribute :address,                default: '*',     kind_of: String
attribute :certificate_thumbprint, default: '',      kind_of: String
attribute :enabled,                default: true,    kind_of: [TrueClass, FalseClass]
attribute :hostname,               default: '',      kind_of: String
attribute :port,                   default: 5985,    kind_of: Fixnum
attribute :transport,              default: :HTTP,   kind_of: [String, Symbol], equal_to: ['HTTP', 'HTTPS', :HTTP, :HTTPS]
attribute :url_prefix,             default: 'wsman', kind_of: String

LISTENER_KEY = 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WSMAN\Listener'

def key_name
  @key ||= "#{LISTENER_KEY}\\#{address}+#{transport}"
end

def ip
  @ip ||= address[/^IP:(.*)$/i, 1] || '0.0.0.0'
end

def uri
  @uri ||= "#{transport.to_s.downcase}://+:#{port}/#{url_prefix}/"
end
