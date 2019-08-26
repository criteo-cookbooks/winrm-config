module WinrmConfig
  # This module aims to add some helper methods to the listener resource
  module ListenerHelpers
    LISTENER_KEY = 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WSMAN\Listener'.freeze

    def key_name
      @key_name ||= "#{LISTENER_KEY}\\#{address}+#{transport}"
    end

    def ip
      @ip ||= address[/^IP:(.*)$/i, 1] || '0.0.0.0'
    end

    def uri
      @uri ||= "#{transport}://+:#{port}/#{url_prefix}/"
    end

    def shared_url?
      registry_get_subkeys(LISTENER_KEY).select do |key|
        next unless key.end_with? new_resource.transport.to_s

        values = registry_hash_values "#{LISTENER_KEY}\\#{key}"
        new_resource.port == values['Port'] && new_resource.url_prefix == values['uriprefix']
      end.count > 1
    end

    def registry_hash_values(key)
      ::Hash[registry_get_values(key).map { |elt| [elt[:name].to_s, elt[:data]] }]
    end
  end
end
