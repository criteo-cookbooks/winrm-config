require 'spec_helper'

describe 'winrm-config::winrs' do
  describe 'On windows platform' do
    let(:windows_chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2008R2').converge(described_recipe)
    end

    it 'configures winrm winrs' do
      expect(windows_chef_run).to configure_winrm_config_winrs('winrs configuration')
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
