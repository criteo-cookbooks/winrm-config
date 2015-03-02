#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: winrm-config
# Provider:: listener
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

action :configure do
  registry_key new_resource.key_name do
    action    :create
    recursive true
    values [
      { name: 'enabled',        type: :dword,  data: new_resource.enable ? 1 : 0 },
      { name: 'hostname',       type: :string, data: new_resource.hostname },
      { name: 'certThumbprint', type: :string, data: new_resource.certificate_thumbprint },
      { name: 'Port',           type: :dword,  data: new_resource.port },
      { name: 'uriprefix',      type: :string, data: new_resource.url_prefix },
    ]
  end
end

action :delete do
  registry_key new_resource.key_name do
    action    :delete
  end
end
