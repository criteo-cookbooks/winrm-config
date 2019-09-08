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

property :address,                String,                  default: '*',    identity: true
property :transport,              %w[HTTP HTTPS],          default: 'http', identity: true, coerce: proc { |x| x.to_s.upcase }
property :certificate_thumbprint, [String, nil],           default: ''
property :enabled,                [TrueClass, FalseClass], default: true
property :hostname,               String,                  default: ''
property :port,                   Integer,                 default: 5985
property :url_prefix,             String,                  default: 'wsman'

provides :winrm_config_listener

include ::WinrmConfig::ListenerHelpers

load_current_value do
  current_value_does_not_exist! unless registry_key_exists? key_name

  data = registry_hash_values key_name
  port data['Port']
  enabled data['enabled'] == 1
  hostname data['hostname']
  url_prefix data['uriprefix']
  certificate_thumbprint data['certThumbprint']
end

action :configure do
  if exist?
    windows_http_acl "former URL acl" do
      url current_resource.uri
      action  :delete
      only_if { url_acl_changed? && !new_resource.shared_url? }
    end

    windows_certificate_binding "Remove former ssl certificate for #{current_resource.ip}:#{current_resource.port}" do
      action      :delete
      name_kind   :hash
      cert_name   current_resource.certificate_thumbprint
      address     current_resource.ip
      port        current_resource.port
      app_id      WINRM_APPID
      only_if { https? && ssl_binding_changed? }
    end
  end

  windows_http_acl new_resource.uri do
    sddl WINRM_SDDL
  end

  windows_certificate_binding "Bind ssl certificate to winrm listener #{new_resource.ip}:#{new_resource.port}" do
    action      :create
    name_kind   :hash
    cert_name   new_resource.certificate_thumbprint
    address     new_resource.ip
    port        new_resource.port
    app_id      WINRM_APPID
    only_if { https? }
  end

  registry_key new_resource.key_name do
    action    :create
    recursive true
    values [
      { name: 'enabled',        type: :dword,  data: new_resource.enabled ? 1 : 0 },
      { name: 'hostname',       type: :string, data: new_resource.hostname },
      { name: 'certThumbprint', type: :string, data: new_resource.certificate_thumbprint },
      { name: 'Port',           type: :dword,  data: new_resource.port },
      { name: 'uriprefix',      type: :string, data: new_resource.url_prefix }
    ]
  end
end

action :delete do
  if exist?
    windows_http_acl new_resource.uri do
      action  :delete
      not_if { new_resource.shared_url? }
    end

    windows_certificate_binding "Remove ssl certificate for #{new_resource.ip}:#{new_resource.port}" do
      action      :delete
      address     new_resource.ip
      port        new_resource.port
      only_if { https? }
    end
  end

  registry_key new_resource.key_name do
    action :delete
  end
end

action_class do
  WINRM_APPID = '{afebb9ad-9b97-4a91-9ab5-daf4d59122f6}'.freeze
  WINRM_SDDL = 'D:(A;;GX;;;S-1-5-80-569256582-2953403351-2909559716-1301513147-412116970)(A;;GX;;;S-1-5-80-4059739203-877974739-1245631912-527174227-2996563517)'.freeze

  def exist?
    !current_resource.nil?
  end

  def url_acl_changed?
    %i[address port].any? do |attribute|
      new_resource.send(attribute) != current_resource.send(attribute)
    end
  end

  def ssl_binding_changed?
    %i[certificate_thumbprint address port].any? do |attribute|
      new_resource.send(attribute) != current_resource.send(attribute)
    end
  end

  def https?
    new_resource.transport == 'HTTPS'
  end

  def whyrun_supported?
    true
  end
end
