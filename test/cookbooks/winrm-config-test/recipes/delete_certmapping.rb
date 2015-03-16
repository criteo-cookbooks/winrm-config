winrm_config_service_certmapping 'delete_certmapping' do
  action        :delete
  username      'old_user'
  password      'old_password'
  issuer        'old_thumbprint'
  subject       'old_subject'
  uri           'old_uri'
end
