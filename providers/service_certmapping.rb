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

include WinrmConfig::ProviderHelper

def load_current_resource
  @current_resource = Chef::Resource::WinrmConfigListener.new(new_resource.name, @run_context)
  @current_resource.properties winrm_config(path)['CertMapping'] rescue {}

  Chef::Log.info('Current WinRM service certificate mapping')
  Chef::Log.info(@current_resource.properties)
end

action :configure do
  pwd = new_resource.properties.delete 'Password' # We can't check the Password
  if changes? current_resource.properties, new_resource.properties
    new_resource.password pwd
    converge_by 'configuring WinRM service certificate mapping' do
      action = current_resource.properties.empty? ? :Create : :Put
      winrm_config path, get_final_config('Certmapping'), action
    end
    new_resource.updated_by_last_action true
  end
end

action :delete do
  unless current_resource.properties.empty?
    converge_by 'deleting WinRM service certificate mapping' do
      winrm_delete path
    end
    new_resource.updated_by_last_action true
  end
end

private

def path
  @filter ||= "config/service/certmapping?Issuer=#{new_resource.issuer}+Subject=#{new_resource.subject}+URI=#{new_resource.uri}"
end
