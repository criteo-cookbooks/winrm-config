WinRM-config Cookbook
=====================
Configure WinRM service and client.

Requirements
------------
This cookbook requires Chef 11.10.0+.

### Platforms
This cookbook only supports the following platforms:

* Windows Server 2008 (R1, R2)
* Windows Server 2012 (R1, R2)

Usage
-----

Place an explicit dependency on this cookbook (using depends in the cookbook's metadata.rb)
from any cookbook where you would like to use the winrm-config-specific resources/providers
that ship with this cookbook.

```ruby
depends 'winrm-config'
```

Then include the recipes you want, or use one the LWRP provided.
The default recipe, should setup a working WinRM environment.

Providers & Resources
---------------------

## listener

### Actions
Action    | Description
----------|-------------------------------------------------
configure | Create or update the specified WinRM listener
delete    | Delete the specified WinRM listener if it exists

### Attributes
Attribute              | Description                                              | Type                    | Default
-----------------------|----------------------------------------------------------|-------------------------|---------
name                   | Name of the resource                                     | String                  |
address                | Address on which the service is configured to listen     | String                  | `*`
certificate_thumbprint | Thumbprint of the certificate to use with HTTPS transport| String                  | ``
enabled                | Whether the current listener should be enabled or not    | TrueClass, FalseClass   | `true`
hostname               | Hostname of the server where the listener is configured  | String                  | ``
port                   | Port on which the service is configured to listen        | Fixnum                  | `5985`
transport              | Transport used over the with WS-Management protocol      | Symbol<br/>:HTTP,:HTTPS | `:HTTP`
url_prefix             | URL prefix on which to accept HTTP or HTTPS requests     | String                  | `wsman`

## service_certmapping
This provider allows to configure or delete a WinRM user <-> certificate mapping.

**NOTE:** The user password cannot contain a double quote `"`, due to the usage of `winrm.vbs` (see [#8][quote_issue])

### Actions
Action    | Description
----------|------------------------------------------------------------
configure | Create or update the specified WinRM certificate mapping
delete    | Delete the specified WinRM certificate mapping if it exists

### Attributes
Attribute | Description                                               | Type                  | Default
----------|-----------------------------------------------------------|-----------------------|---------
name      | Name of the resource                                      | String                |
enabled   | Whether the current certificate mapping is enabled or not | TrueClass, FalseClass | `true`
issuer    | Thumbprint of the issuer of theclient certificate         | String                |
password  | Password of the local user for processing the request     | String                |
subject   | Subject field of the client certificate                   | String                | `*`
uri       | The URI or URI prefix for which this mapping applies      | String                | `*`
username  | Local username for processing the request                 | String                |

Recipes
-------

## winrm-config::client
Configures all WinRM client settings via registry keys, then performs a restart of the WinRM windows service.

### Attributes
WinRM client settings are configurable via `node['winrm_config']['client']` attributes, which follows the [msdn documentation][client_config].

Attribute        | Description                                               | Type                  | Default
-----------------|-----------------------------------------------------------|-----------------------|---------
AllowUnencrypted | Allow unencrypted communication with WinRM service        | TrueClass, FalseClass | `false`
Basic            | Allow the client to use `Basic authentication`            | TrueClass, FalseClass | `true`
Certificate      | Allow the client tu use `certificate authentication`      | TrueClass, FalseClass | `true`
CredSSP          | Allow the client tu use `CredSSP authentication`          | TrueClass, FalseClass | `false`
Digest           | Allow the client to use `Digest authentication`           | TrueClass, FalseClass | `true`
Kerberos         | Allow the client to use `Kerberos authentication`         | TrueClass, FalseClass | `true`
Negotiate        | Allow the client to use `Negotiate authentication`        | TrueClass, FalseClass | `true`
NetworkDelayms   | Time in milliseconds to accomodate to the network delay   | String                | `5000`
TrustedHosts     | List of trusted remote computer                           | String                | ``
URLPrefix        | URL prefix on which to accept HTTP or HTTPS requests      | String                | `wsman`

Default ports used for either HTTP or HTTPs can be configured via `node['winrm_config']['client']['DefaultPorts']`

Attribute | Description                                               | Type   | Default
----------|-----------------------------------------------------------|--------|---------
HTTP      | The ports used by the client for HTTP                     | Fixnum | `5985`
HTTPS     | The ports used by the client for HTTPS                    | Fixnum | `5986`

## winrm-config::default
A convenience recipe that include the following recipes to enable a default WinRM working service:

* `winrm-config::windows_service`
* `winrm-config::protocol`
* `winrm-config::client`
* `winrm-config::listeners`
* `winrm-config::service`
* `winrm-config::winrs`

## winrm-config::listeners
A convenience recipe to defines WinRM listeners via registry keys, then
performs a restart of the WinRM windows service.

### Attributes
You can define multiples listener via the `node['winrm_config']['listeners']`
hash, following the [msdn documentation][listener_config] for each entry.

Attribute             | Description                                              | Type                    | Default
----------------------|----------------------------------------------------------|-------------------------|---------
Address               | Address on which the service is configured to listen     | String                  | `*`
CertificateThumbprint | Thumbprint of the certificate to use with HTTPS transport| String                  | ``
Enabled               | Whether the current listener should be enabled or not    | TrueClass, FalseClass   | `true`
Hostname              | Hostname of the server where the listener is configured  | String                  | ``
Port                  | Port on which the service is configured to listen        | Fixnum                  | `5985`
Transport             | Transport used over the with WS-Management protocol      | Symbol<br/>:HTTP,:HTTPS | `:HTTP`
URLPrefix             | URL prefix on which to accept HTTP or HTTPS requests     | String                  | `wsman`

## winrm-config::protocol
Configures WinRM protocol settings via registry key, then preforms a restart
of the WinRM windows service.

### Attributes
WinRM protocol settings attributes are accessible via `node['winrm_config']['protocol']`,
following the [msdn documentation][protocol_config].

Attribute         | Description                                              | Type   | Default
------------------|----------------------------------------------------------|--------|---------
MaxEnvelopeSizekb | The maximum SOAP data in kilobytes                       | Fixnum | `150`
MaxTimeoutms      | The maximum request time-out in milliseconds             | Fixnum | `60 000`
MaxBatchItems     | The maximum number of elements composing a Pull response | Fixnum | `32 000`

## winrm-config::service
Configures all WinRM service settings via registry keys, then performs a
restart of the WinRM windows service.

### Attributes
WinRM service settings are configurable via `node['winrm_config']['service']`
attributes, which follows the [msdn documentation][service_config].

Attribute                        | Description                                                              | Type                  | Default
---------------------------------|--------------------------------------------------------------------------|-----------------------|---------
AllowUnencrypted                 | Allow unencrypted communication with clients                             | TrueClass, FalseClass | `false`
Basic                            | Allow the service to use `Basic authentication`                          | TrueClass, FalseClass | `true`
Certificate                      | Allow the service tu use `certificate authentication`                    | TrueClass, FalseClass | `true`
CredSSP                          | Allow the service tu use `CredSSP authentication`                        | TrueClass, FalseClass | `false`
Kerberos                         | Allow the service to use `Kerberos authentication`                       | TrueClass, FalseClass | `true`
Negotiate                        | Allow the service to use `Negotiate authentication`                      | TrueClass, FalseClass | `true`
CbtHardeningLevel                | Policy for channel-binding token requirements in authentication requests | String                | `Relaxed`
EnableCompatibilityHttpListener  | Whether to enable additional compatibility HTTP listener on port 80      | TrueClass, FalseClass | `false`
EnableCompatibilityHttpsListener | Whether to enable additional compatibility HTTPS listener on port 443    | TrueClass, FalseClass | `false`
EnumerationTimeoutms             | Maximum time in milliseconds to accomodate to the network delay          | String                | `5000`
IPv4Filter                       | Filter IPV4 addresses that listeners can use                             | String                | ``
IPv6Filter                       | Filter IPV6 addresses that listeners can use                             | String                | ``
MaxConcurrentOperationsPerUser   | Maximum number of concurrent operations per user                         | String                | `5000`
MaxConnections                   | Maximum number of active requests to process simultaneously              | String                | `5000`
MaxPacketRetrievalTimeSeconds    | Maximum time in seconds to retrieve a packet                             | String                | `5000`
RootSDDL                         | The security descriptor that controls remote access to the listener      | String                | `O:NSG:BAD:P(A;;GA;;;BA)(A;;GR;;;ER)S:P(AU;FA;GA;;;WD)(AU;SA;GWGX;;;WD)`

## winrm-config::windows_service
A simple recipe to enable and start the WinRM Windows service.

## winrm-config::winrs
Configures the WinRS settings via registry keys, then performs a restart of
the WinRM windows service.

### Attributes
WinRS settings are configurable via `node['winrm_config']['winrs']`

Attribute              | Description                                              | Type                  | Default
-----------------------|----------------------------------------------------------|-----------------------|----------
AllowRemoteShellAccess | Allows access to remote shells                           | TrueClass, FalseClass | `true`
IdleTimeout            | Maximum time in milliseconds to keep an idle shell open  | Fixnum                | `180 000`
MaxConcurrentUsers     | Maximum number of users who can concurrently open a shell| Fixnum                | `5`
MaxMemoryPerShellMB    | Maximum amount of memory in megabytes allocated per shell| Fixnum                | `150`
MaxProcessesPerShell   | Maximum number of processes that a shell can start       | Fixnum                | `15`
MaxShellsPerUser       | maximum number of shell a user can open                  | Fixnum                | `5`

Contributing
------------
1. Fork the [repository on Github][repository]
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: [Baptiste Courtois][author] (<b.courtois@criteo.com>)

```text
Copyright 2015, Criteo.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

[author]:             https://github.com/Annih
[repository]:         https://github.com/criteo-cookbooks/winrm-config
[client_config]:      http://msdn.microsoft.com/library/aa384372#WINRM_CLIENT_DEFAULT_CONFIGURATION_SETTINGS
[service_config]:     http://msdn.microsoft.com/library/aa384372#WINRM_SERVICE_DEFAULT_CONFIGURATION_SETTINGS
[listener_config]:    http://msdn.microsoft.com/library/aa384372#LISTENER_AND_WS-MANAGEMENT_PROTOCOL_DEFAULT_SETTINGS
[protocol_config]:    http://msdn.microsoft.com/library/aa384372#PROTOCOL_DEFAULT_SETTINGS_
[winrs_config]:       http://msdn.microsoft.com/library/aa384372#_WINRS_DEFAULT_CONFIGURATION_SETTINGS
[quote_issue]:        https://github.com/criteo-cookbooks/winrm-config/issues/8
