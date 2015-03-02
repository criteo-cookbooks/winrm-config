if defined?(ChefSpec)
  ChefSpec.define_matcher :winrm_config_listener
  def configure_winrm_config_listener(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:winrm_config_listener, :configure, resource)
  end

  def delete_winrm_config_listener(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:winrm_config_listener, :delete, resource)
  end

  ChefSpec.define_matcher :winrm_config_service_certmapping
  def configure_winrm_config_service_certmapping(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:winrm_config_service_certmapping, :configure, resource)
  end

  def delete_winrm_config_service_certmapping(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:winrm_config_service_certmapping, :delete, resource)
  end
end
