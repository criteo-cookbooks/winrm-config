#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: winrm-config
# Library:: base_resource
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
  # Module to extend Chef Resources with helpers and properties' Hash table
  # It's used by all `winrm-config` resources.
  module BaseResource
    MAX_INT16 = 65_535
    MAX_INT32 = 2_147_483_647

    def initialize(name, run_context = nil)
      super(name, run_context)

      @action = :configure
      @allowed_actions.push(:configure)

      @properties = {}
    end

    def properties(arg = nil)
      @properties = arg.merge(@properties) unless arg.nil?
      @properties
    end

    def validate_string(name, value, values)
      value = value.to_s
      unless values.include? value
        fail RangeError, "Invalid value for '#{name}', accepted values are '#{values.join('\', \'')}'"
      end
      value
    end

    def boolean_to_s(name, value)
      unless value.is_a?(TrueClass) || value.is_a?(FalseClass)
        fail TypeError, "Invalid value for '#{name}' expecting 'True' or 'False'"
      end
      value.to_s
    end

    def integer_to_s(name, value, min, max)
      i = value.to_i
      unless i >= min && i <= max && value.to_s =~ /^\d+$/
        fail ArgumentError, "Invalid value for '#{name}', value must be between #{min} and #{max}"
      end
      i.to_s
    end
  end
end
