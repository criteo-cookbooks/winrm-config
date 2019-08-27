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

property :enabled,  [TrueClass, FalseClass], default: true
property :issuer,   String, required: true, identity: true
property :password, String, required: true
property :subject,  String, default: '*', identity: true
property :uri,      String, default: '*', identity: true
property :username, String, required: true

include ::WinrmConfig::ServiceCertmappingHelpers

load_current_value do |_desired_state|
  begin
    winrm_data = winrm_get
  rescue StandardError => e
    ::Chef::Log.warn("An error occured while retrieving certmapping: #{e.message}")
  end
  current_value_does_not_exist! if winrm_data.nil? || winrm_data.empty?

  username winrm_data['UserName']
  enabled(winrm_data['Enabled'] != 'false')
end

action :configure do
  if !exists? || attributes_changed? || password_changed?
    converge_by 'configuring WinRM service certificate mapping' do
      new_resource.winrm_set(exists? ? :set : :create)
      password_hash = hash_password(new_resource.password)

      directory password_file_directory do
        recursive true
      end
      # store the password hash in a file to allow future comparison
      file password_file do
        backup   false
        content  password_hash
      end
    end
  end
end

action :delete do
  if exists?
    converge_by 'deleting WinRM service certificate mapping' do
      new_resource.winrm_delete
    end
  end
end

action_class do
  SALT_LENGTH = 32

  def exists?
    !current_resource.nil?
  end

  def attributes_changed?
    %i[enabled issuer subject uri username].any? do |attribute|
      new_resource.send(attribute) != current_resource.send(attribute)
    end
  end

  def password_changed?
    return true unless ::File.exist? password_file

    content = ::File.read password_file
    salt = content[0..SALT_LENGTH - 1]
    hash_password(new_resource.password, salt) != content
  end

  def hash_password(password, salt = nil)
    require 'securerandom'
    require 'digest/sha2'

    salt = ::SecureRandom.random_bytes SALT_LENGTH if salt.nil?
    salt + (::Digest::SHA2.new(512) << salt << password).to_s
  end

  def password_file_name
    require 'digest/sha1'

    (::Digest::SHA1.new << new_resource.issuer << new_resource.subject << new_resource.uri).to_s
  end

  def password_file_directory
    @password_file_directory ||= ::File.join(::Chef::Config['file_cache_path'], 'winrm_config')
  end

  def password_file
    @password_file ||= ::File.join(password_file_directory, password_file_name)
  end

  def whyrun_supported?
    true
  end
end
