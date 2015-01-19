#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: winrm-config
# Library:: base_resource_security
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

module WinrmConfig
  # Module to extend Chef Resources with winrm security attributes.
  # It's used by `client` & `service` winrm-config resources.
  module BaseResourceSecurity

    include ::WinrmConfig::BaseResource

    def allow_unencrypted(arg = nil)
      if arg
        @properties['AllowUnencrypted'] = boolean_to_s('allow_unencrypted', arg)
      else
        @properties['AllowUnencrypted']
      end
    end

    def http_port(arg = nil)
      default_port('HTTP', arg)
    end

    def https_port(arg = nil)
      default_port('HTTPS', arg)
    end

    def basic_auth(arg = nil)
      enable_auth('Basic', arg)
    end

    def kerberos_auth(arg = nil)
      enable_auth('Kerberos', arg)
    end

    def negotiate_auth(arg = nil)
      enable_auth('Negotiate', arg)
    end

    def certificate_auth(arg = nil)
      enable_auth('Certificate', arg)
    end

    def cred_ssp_auth(arg = nil)
      enable_auth('CredSSP', arg)
    end

    protected

    def default_port(scheme, value = nil)
      @properties['DefaultPorts'] ||= {}
      if value
        @properties['DefaultPorts'][scheme] = integer_to_s("#{scheme}_port", value, 1, MAX_INT16)
      else
        @properties['DefaultPorts'][scheme]
      end
    end

    def enable_auth(type, value = nil)
      @properties['Auth'] ||= {}
      if value
        @properties['Auth'][type] = boolean_to_s("#{type}_auth", value)
      else
        @properties['Auth'][type]
      end
    end

  end
end
