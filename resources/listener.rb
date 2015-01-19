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
  if arg
    @properties['Address'] = arg
  else
    @properties['Address']
  end
end

def certificate_thumbprint(arg = nil)
  if arg
    @properties['CertificateThumbprint'] = arg
  else
    @properties['CertificateThumbprint']
  end
end

def enable(arg = nil)
  if arg
    @properties['Enabled'] = boolean_to_s('enable', arg)
  else
    @properties['Enabled']
  end
end

def hostname(arg = nil)
  if arg
    @properties['Hostname'] = arg
  else
    @properties['Hostname']
  end
end

def port(arg = nil)
  if arg
    @properties['Port'] = integer_to_s('port', arg, 0, MAX_INT16)
  else
    @properties['Port']
  end
end

def transport(arg = nil)
  if arg
    @properties['Transport'] = validate_string('transport', arg, TRANSPORTS)
  else
    @properties['Transport']
  end
end

def url_prefix(arg = nil)
  if arg
    @properties['URLPrefix'] = arg
  else
    @properties['URLPrefix']
  end
end
