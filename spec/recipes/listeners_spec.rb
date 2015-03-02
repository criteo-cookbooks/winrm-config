require 'spec_helper'

describe 'winrm-config::listeners' do
  describe 'On windows platform' do
    let(:windows_chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2008R2') do |node|
        node.set['winrm_config']['listeners']['HTTP'] = {
          'Address' =>               '*',
          'CertificateThumbprint' => nil,
          'Enabled' =>               true,
          'Hostname' =>              nil,
          'Port' =>                  5985,
          'Transport' =>             :HTTP,
          'URLPrefix' =>             'wsman',
        }
      end.converge(described_recipe)
    end

    it 'configures winrm service' do
      expect(windows_chef_run).to configure_winrm_config_listener('HTTP listener configuration')
    end
  end
  describe 'On non-windows platform' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new.converge(described_recipe)
    end

    it 'does nothing' do
      expect(chef_run.resource_collection).to be_empty
    end
  end
end
