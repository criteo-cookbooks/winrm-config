#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: winrm-config
# Library:: base_provider
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
  module BaseProvider

    def winrm_config(path, config = nil)
      wsman = WIN32OLE.new('WSMAN.Automation')
      session = wsman.CreateSession
      locator = wsman.CreateResourceLocator "winrm/#{path}"

      if config.nil?
        xml = session.Get locator
        xml_to_hash(REXML::Document.new(xml).root)
      else
        doc = REXML::Document.new
        hash_to_xml(config, doc)
        doc.root.add_namespace('cfg', "http://schemas.microsoft.com/wbem/wsman/1/#{path}")
        doc.root.add_attribute('xml:lang', 'en-US')
        session.Put locator, doc.to_s
      end
    end

    def has_changes?(current_hash, new_hash)
      new_hash.any? do |key,value|
        if current_hash.has_key? key
          if value.is_a? Hash
            has_changes? current_hash[key], value
          else
            value != current_hash[key]
          end
        else
          true
        end
      end
    end


    def get_final_config(root)
      { root => deep_merge(current_resource.properties, new_resource.properties) }
    end

    protected

    def deep_merge(h1, h2)
      h1.merge(h2) do |key, old_value, new_value|
        if old_value.is_a?(Hash) && new_value.is_a?(Hash)
          deep_merge old_value, new_value
        else
          new_value
        end
      end
    end

    private

    def hash_to_xml(hash, parent = nil)
      hash.map do |k,v|
        element = REXML::Element.new("cfg:#{k}", parent)

        if v.is_a? Hash
          hash_to_xml(v, element)
        else
          element.text = v.to_s
        end
      end
    end

    def xml_to_hash(node)
      if node.has_elements?
        { node.name => {}.tap { |h| node.elements.each { |e| h.merge!(xml_to_hash e) } } }
      else
        { node.name => node.texts.first.to_s }
      end
    end
  end
end
