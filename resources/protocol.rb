#
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: winrm-config
# Resource:: protocol
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
include WinrmConfig::BaseResource

default_action :configure

def max_envelop_size(arg = nil)
  if arg
    @properties['MaxEnvelopeSizekb'] = integer_to_s('max_envelop_size', arg, 0, 1_039_440)
  else
    @properties['MaxEnvelopeSizekb']
  end
end

def max_timeout(arg = nil)
  if arg
    @properties['MaxTimeoutms'] = integer_to_s('max_timeout', arg, 0, MAX_INT16)
  else
    @properties['MaxTimeoutms']
  end
end

def max_batch_items(arg = nil)
  if arg
    @properties['MaxBatchItems'] = integer_to_s('max_batch_items', arg, 0, MAX_INT16)
  else
    @properties['MaxBatchItems']
  end
end
