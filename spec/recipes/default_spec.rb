require 'spec_helper'

describe 'winrm-config::default' do
  describe 'On windows platform' do
    let(:windows_chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2008R2').converge(described_recipe)
    end

    it 'includes client, service, listeners protocol and winrs recipes' do
      expect(windows_chef_run).to include_recipe('winrm-config::client')
      expect(windows_chef_run).to include_recipe('winrm-config::listeners')
      expect(windows_chef_run).to include_recipe('winrm-config::protocol')
      expect(windows_chef_run).to include_recipe('winrm-config::service')
      expect(windows_chef_run).to include_recipe('winrm-config::winrs')
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
