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

def whyrun_supported?
  true
end

def load_current_resource
  winrm_data = winrm_get
  unless winrm_data.nil? || winrm_data.empty?
    @current_resource = Chef::Resource::WinrmConfigServiceCertmapping.new(new_resource.name, run_context)
    @current_resource.hydrate winrm_data
  end
rescue => e
  @current_resource = nil
  Chef::Log.warn("An error occured while retrieving certmapping: #{e.message}")
end

action :configure do
  if !exists? || attributes_changed? || password_changed?
    converge_by 'configuring WinRM service certificate mapping' do
      winrm_set
      password_hash = hash_password(new_resource.password)

      directory password_file_directory do
        recursive  true
      end
      # store the password hash in a file to allow future comparison
      file password_file do
        backup   false
        content  password_hash
      end
    end
    @new_resource.updated_by_last_action true
  end
end

action :delete do
  if exists?
    converge_by 'deleting WinRM service certificate mapping' do
      winrm_delete
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
  [:enabled, :issuer, :subject, :uri, :username].any? do |attribute|
    @new_resource.send(attribute) != @current_resource.send(attribute)
  end
end

def password_changed?
  return true unless ::File.exist? password_file

  content = ::File.read password_file
  salt = content[0..SALT_LENGTH - 1]
  hash_password(@new_resource.password, salt) != content
end

def hash_password(password, salt = nil)
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

def runas_options
  if !node['kernel']['cs_info']['part_of_domain'] && 'SYSTEM' == node['current_user']
    { user: @new_resource.username, password: @new_resource.password }
  else
    {}
  end
end

def winrm_delete
  cmd = ::Mixlib::ShellOut.new("winrm.cmd delete #{new_resource.path}", runas_options)
  cmd.run_command
  cmd.error!
end

def winrm_get
  cmd = ::Mixlib::ShellOut.new("winrm.cmd get #{new_resource.path}", runas_options)
  cmd.run_command
  cmd.error!

  Hash[cmd.stdout.each_line.select { |l| l.include?('=') }.map { |l| l.split('=').map(&:strip) }]
end

def winrm_set
  action = exists? ? :set : :create
  args = "Enabled=\"#{new_resource.enabled}\";UserName=\"#{new_resource.username}\";Password=\"#{new_resource.password}\""
  cmd = ::Mixlib::ShellOut.new("winrm.cmd #{action} #{new_resource.path} @{#{args}}", runas_options)
  cmd.run_command
  cmd.error!
end
