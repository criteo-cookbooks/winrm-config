winrm_config_listener 'configure_listener' do
  address                    '*'
  enabled                    true
  certificate_thumbprint     ''
  hostname                   'fake'
  port                       5985
  transport                  :HTTP
  url_prefix                 'wsman'
end
