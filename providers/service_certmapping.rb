#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: winrm-config
# Provider:: service_certmapping
#
# Copyright:: Copyright (c) 2014 Criteo.
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
use_inline_resources

def load_current_resource
  @current_resource = Chef::Resource::WinrmConfigServiceCertmapping.new(new_resource.name, run_context)
  @current_resource.hidrate winrm_get
rescue => e
  Chef::Log.warn("An error occured while retrieving certmapping: #{e.message}")
end

action :configure do
  if !exists? || attributes_changed? || password_changed?
    converge_by 'configuring WinRM service certificate mapping' do
      action = exists? ? :Put : :Create
      wsman_session.send action, wsman_locator, new_resource.wsman_xml.to_s

      encrypted_password = encrypt_password(new_resource.password)

      directory password_file_directory do
        recursive  true
      end
      # store the password hash in a file to allow future comparison
      file password_file do
        backup   false
        content  encrypted_password
        inherits false
        rights   :full_control, 'SYSTEM'
      end
    end
    @new_resource.updated_by_last_action true
  end
end

action :delete do
  unless exists?
    converge_by 'deleting WinRM service certificate mapping' do
      wsman_session.Delete wsman_locator
    end
    @new_resource.updated_by_last_action true
  end
end

private

SALT_LENGTH = 32

def exists?
  !@current_resource.nil?
end

def attributes_changed?
  [:enable, :issuer, :subject, :uri, :username].any? do |attribute|
    @new_resource.send(attribute) != @current_resource.send(attribute)
  end
end

def password_changed?
  return true unless ::File.exist? password_file

  content = ::File.read password_file
  salt = content[0..SALT_LENGTH - 1]
  encrypt_password(@new_resource.password, salt) != content
end

def encrypt_password(password, salt = nil)
  require 'securerandom'
  require 'digest/sha2'

  salt = ::SecureRandom.random_bytes SALT_LENGTH if salt.nil?
  salt + (::Digest::SHA2.new(512) << salt << password).to_s
end

def password_file_name
  require 'digest/sha1'

  (::Digest::SHA1.new << @new_resource.issuer << @new_resource.subject << @new_resource.uri).to_s
end

def password_file_directory
  @directory ||= ::File.join(::Chef::Config['file_cache_path'], 'winrm_config')
end

def password_file
  @file ||= ::File.join(password_file_directory, password_file_name)
end

def winrm_get
  options = { user: @new_resource.username, password: @new_resource.password }
  cmd = ::Mixlib::ShellOut.new("winrm.cmd get #{new_resource.path}", options)
  cmd.run_command
  cmd.error!
  winrm_to_hash cmd.stdout
end

def winrm_to_hash(io)
  Hash[io.each_line.select { |l| l.include?('=') }.map { |l| l.split?('=').map(&:strip) }]
end

def runas_options
  if !node['kernel']['cs_info']['part_of_domain'] && 'SYSTEM' == node['current_user']
    { user: @new_resource.username, password: @new_resource.password }
  else
    {}
  end
end

def winrm_set(action)
  args = params.map { |k, v| "#{k}=\"#{v}\"" }.join(';')
  cmd = ::Mixlib::ShellOut.new("winrm.cmd #{action} #{new_resource.path} @{#{args}}", runas_options)
  cmd.run_command
  cmd.error!
end
