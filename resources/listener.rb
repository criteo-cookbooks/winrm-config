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
include WinrmConfig::BaseResource

default_action :configure
actions :configure, :delete

TRANSPORTS = %w(HTTP HTTPS)

def address(arg = nil)
  if arg.nil?
    @properties['Address']
  else
    @properties['Address'] = arg
  end
end

def certificate_thumbprint(arg = nil)
  if arg.nil?
    @properties['CertificateThumbprint']
  else
    @properties['CertificateThumbprint'] = arg
  end
end

def enable(arg = nil)
  if arg.nil?
    @properties['Enabled']
  else
    @properties['Enabled'] = boolean_to_s('enable', arg)
  end
end

def hostname(arg = nil)
  if arg.nil?
    @properties['Hostname']
  else
    @properties['Hostname'] = arg
  end
end

def port(arg = nil)
  if arg.nil?
    @properties['Port']
  else
    @properties['Port'] = integer_to_s('port', arg, 0, MAX_INT16)
  end
end

def transport(arg = nil)
  if arg.nil?
    @properties['Transport']
  else
    @properties['Transport'] = validate_string('transport', arg, TRANSPORTS)
  end
end

def url_prefix(arg = nil)
  if arg.nil?
    @properties['URLPrefix']
  else
    @properties['URLPrefix'] = arg
  end
end
