#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: winrm-config
# Resource:: service
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

# handle 'allow_unencrypted', 'auth' and 'defaultports' attributes
include WinrmConfig::BaseResourceSecurity

default_action :configure

HARDENING_LEVELS = %w(None Relaxed Strict)

def cbt_hardening_level(arg = nil)
  @properties['Auth'] ||= {}
  if arg.nil?
    @properties['Auth']['CbtHardeningLevel']
  else
    @properties['Auth']['CbtHardeningLevel'] = validate_string('cbt_hardening_level', arg, HARDENING_LEVELS)
  end
end

def concurrence_per_user(arg = nil)
  if arg.nil?
    @properties['MaxConcurrentOperationsPerUser']
  else
    @properties['MaxConcurrentOperationsPerUser'] = integer_to_s('concurrence_per_user', arg, 0, MAX_INT16)
  end
end

def enumeration_timeout(arg = nil)
  if arg.nil?
    @properties['EnumerationTimeoutms']
  else
    @properties['EnumerationTimeoutms'] = integer_to_s('enumeration_timeout', arg, 0, MAX_INT16)
  end
end

def http_compatibility(arg = nil)
  if arg.nil?
    @properties['EnableCompatibilityHttpListener']
  else
    @properties['EnableCompatibilityHttpListener'] = boolean_to_s('http_compatibility', arg)
  end
end

def https_compatibility(arg = nil)
  if arg.nil?
    @properties['EnableCompatibilityHttpsListener']
  else
    @properties['EnableCompatibilityHttpsListener'] = boolean_to_s('https_compatibility', arg)
  end
end

def ipv4_filter(arg = nil)
  if arg.nil?
    @properties['IPv4Filter']
  else
    @properties['IPv4Filter'] = arg
  end
end

def ipv6_filter(arg = nil)
  if arg.nil?
    @properties['IPv6Filter']
  else
    @properties['IPv6Filter'] = arg
  end
end

def max_connections(arg = nil)
  if arg.nil?
    @properties['MaxConnections']
  else
    @properties['MaxConnections'] = integer_to_s('max_connections', arg, 0, MAX_INT16)
  end
end

def receive_timeout(arg = nil)
  if arg.nil?
    @properties['MaxPacketRetrievalTimeSeconds']
  else
    @properties['MaxPacketRetrievalTimeSeconds'] = integer_to_s('receive_timeout', arg, 0, MAX_INT16)
  end
end

def root_sddl(arg = nil)
  if arg.nil?
    @properties['RootSDDL']
  else
    @properties['RootSDDL'] = arg
  end
end
