name             'winrm-config'
maintainer       'Criteo'
maintainer_email 'b.courtois@criteo.com'
license          'Apache-2.0'
description      'Configures winrm service and client'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.6'
supports         'windows', '>= 6.0'
depends          'windows', '>= 2.1'
chef_version     '>= 12.1' if respond_to?(:chef_version)
issues_url       'https://github.com/criteo-cookbooks/winrm-config/issues' if respond_to?(:issues_url)
source_url       'https://github.com/criteo-cookbooks/winrm-config' if respond_top?(:source_url)
