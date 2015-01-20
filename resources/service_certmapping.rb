#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: winrm-config
# Resource:: service_certmapping
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

def enable(arg = nil)
  if arg.nil?
    @properties['Enabled']
  else
    @properties['Enabled'] = boolean_to_s('enable', arg)
  end
end

def issuer(arg = nil)
  if arg.nil?
    @properties['Issuer']
  else
    @properties['Issuer'] = arg
  end
end

def subject(arg = nil)
  if arg.nil?
    @properties['Subject']
  else
    @properties['Subject'] = arg
  end
end

def uri(arg = nil)
  if arg.nil?
    @properties['URI']
  else
    @properties['URI'] = arg
  end
end

def username(arg = nil)
  if arg.nil?
    @properties['UserName']
  else
    @properties['UserName'] = arg
  end
end

def password(arg = nil)
  if arg.nil?
    @properties['Password']
  else
    @properties['Password'] = arg
  end
end
