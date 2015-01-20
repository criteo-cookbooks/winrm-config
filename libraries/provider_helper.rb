#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: winrm-config
# Library:: provider_helper
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
require 'win32ole' if RUBY_PLATFORM =~ /mswin|mingw32|windows/
require 'rexml/document'

module WinrmConfig
  # Helper module to communicate with WSMAN and handle winrm properties
  # It's used by all `winrm-config` providers.
  module ProviderHelper
    def winrm_delete(path)
      locator = wsman.CreateResourceLocator "winrm/#{path}"
      wsman_session.Delete locator
    end

    def winrm_get(path)
      locator = wsman.CreateResourceLocator "winrm/#{path}"
      xml_to_hash ::REXML::Document.new(wsman_session.Get locator).root
    rescue
      {}
    end

    def winrm_set(path, config, action = :Put)
      locator = wsman.CreateResourceLocator "winrm/#{path}"
      doc = ::REXML::Document.new
      hash_to_xml config, doc
      doc.root.add_namespace 'cfg', "http://schemas.microsoft.com/wbem/wsman/1/#{path.split('?').first}"

      wsman_session.send action, locator, doc.to_s
    end

    def changes?(current_hash, new_hash)
      new_hash.any? do |key, value|
        if current_hash.key?(key) && value.is_a?(Hash)
          changes?(current_hash[key], value)
        else
          value != current_hash[key]
        end
      end
    end

    def get_final_config(root)
      { root => deep_merge(current_resource.properties, new_resource.properties) }
    end

    protected

    def deep_merge(h1, h2)
      h1.merge(h2) do |_, old_value, new_value|
        if old_value.is_a?(Hash) && new_value.is_a?(Hash)
          deep_merge old_value, new_value
        else
          new_value
        end
      end
    end

    private

    def wsman
      @wsman ||= ::WIN32OLE.new('WSMAN.Automation')
    end

    def wsman_session
      @wsman_session ||= wsman.CreateSession
    end

    def hash_to_xml(hash, parent = nil)
      hash.map do |key, value|
        element = REXML::Element.new("cfg:#{key}", parent)

        if value.is_a? Hash
          hash_to_xml(value, element)
        else
          element.text = value.to_s
        end
      end
    end

    def xml_to_hash(xnode)
      if xnode.has_elements?
        { xnode.name => {}.tap { |h| xnode.elements.each { |e| h.merge!(xml_to_hash e) } } }
      else
        { xnode.name => xnode.texts.first.to_s }
      end
    end
  end
end
