#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: winrm-config
# Resource:: winrs
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

def enable(arg = nil)
  if arg.nil?
    @properties['AllowRemoteShellAccess']
  else
    @properties['AllowRemoteShellAccess'] = boolean_to_s('enable', arg)
  end
end

def concurrent_users(arg = nil)
  if arg.nil?
    @properties['MaxConcurrentUsers']
  else
    @properties['MaxConcurrentUsers'] = integer_to_s('concurrent_users', arg, 0, MAX_INT32)
  end
end

def idle_timeout(arg = nil)
  if arg.nil?
    @properties['IdleTimeout']
  else
    @properties['IdleTimeout'] = integer_to_s('idle_timeout', arg, 60_000, MAX_INT32)
  end
end

def memory_per_shell(arg = nil)
  if arg.nil?
    @properties['MaxMemoryPerShellMB']
  else
    @properties['MaxMemoryPerShellMB'] = integer_to_s('memory_per_shell', arg, 0, MAX_INT32)
  end
end

def process_per_shell(arg = nil)
  if arg.nil?
    @properties['MaxProcessesPerShell']
  else
    @properties['MaxProcessesPerShell'] = integer_to_s('process_per_shell', arg, 0, MAX_INT32)
  end
end

def shell_per_user(arg = nil)
  if arg.nil?
    @properties['MaxShellsPerUser']
  else
    @properties['MaxShellsPerUser'] = integer_to_s('shells_per_user', arg, 0, MAX_INT32)
  end
end
