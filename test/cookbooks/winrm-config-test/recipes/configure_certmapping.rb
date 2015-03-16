winrm_config_service_certmapping 'configure_certmapping' do
  username      'new_user'
  password      'new_password'
  issuer        'new_thumbprint'
  subject       'new_subject'
  uri           'new_uri'
end
