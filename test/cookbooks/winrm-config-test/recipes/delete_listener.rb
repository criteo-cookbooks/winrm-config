winrm_config_listener 'delete_listener' do
  action                     :delete
  address                    '*'
  enabled                    true
  certificate_thumbprint     'ABCDEF0123456789'
  hostname                   nil
  port                       5986
  transport                  :HTTPS
  url_prefix                 'wsman'
end
