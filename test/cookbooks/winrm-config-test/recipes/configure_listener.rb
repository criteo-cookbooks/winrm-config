winrm_config_listener 'configure_listener' do
  address                    '*'
  enabled                    true
  certificate_thumbprint     nil
  hostname                   nil
  port                       5985
  transport                  :HTTP
  url_prefix                 'wsman'
end
