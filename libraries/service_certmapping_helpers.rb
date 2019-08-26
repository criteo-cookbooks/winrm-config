module WinrmConfig
  # This module aims to add some helper methods to the service_certmapping resource
  module ServiceCertmappingHelpers
    def cert_path
      @cert_path ||= "winrm/config/service/certmapping?Issuer=#{issuer}+Subject=#{subject}+URI=#{uri}"
    end

    def runas_options
      if !node['kernel']['cs_info']['part_of_domain'] && node['current_user'] == 'SYSTEM'
        { user: username, password: password }
      else
        {}
      end
    end

    def winrm_delete
      cmd = ::Mixlib::ShellOut.new("winrm.cmd delete #{cert_path}", runas_options)
      cmd.run_command
      cmd.error!
    end

    def winrm_get
      cmd = ::Mixlib::ShellOut.new("winrm.cmd get #{cert_path}", runas_options)
      cmd.run_command
      cmd.error!

      ::Hash[cmd.stdout.each_line.select { |l| l.include?('=') }.map { |l| l.split('=').map(&:strip) }]
    end

    def winrm_set(action)
      args = "Enabled=\"#{enabled}\";UserName=\"#{username}\";Password=\"#{password}\""
      cmd = ::Mixlib::ShellOut.new("winrm.cmd #{action} #{cert_path} @{#{args}}", runas_options)
      cmd.run_command
      cmd.error!
    end
  end
end
