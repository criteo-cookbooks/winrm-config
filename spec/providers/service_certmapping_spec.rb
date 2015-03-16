require 'spec_helper'

describe 'winrm_config_service_certmapping' do

  describe 'create action' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(step_into: ['winrm_config_service_certmapping']) do |node|
        node.default['kernel'] = { 'cs_info' => { 'part_of_domain' => false } }
      end.converge('winrm-config-test::configure_certmapping')
    end

    it 'creates new mapping' do
      mock_winrm_get(true, 'new_uri', 'new_subject', 'new_thumbprint', 'new_user')
      mock_winrm_set(true, 'new_uri', 'new_subject', 'new_thumbprint', 'new_user', 'new_password')
      expect(chef_run).to configure_winrm_config_service_certmapping('configure_certmapping')
    end

    it 'updates existing mapping' do
      mock_winrm_get(false, 'new_uri', 'new_subject', 'new_thumbprint', 'new_user')
      mock_winrm_set(false, 'new_uri', 'new_subject', 'new_thumbprint', 'new_user', 'new_password')
      expect(chef_run).to configure_winrm_config_service_certmapping('configure_certmapping')
    end
  end

  describe 'action delete' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(step_into: ['winrm_config_service_certmapping']) do |node|
        node.default['kernel'] = { 'cs_info' => { 'part_of_domain' => false } }
      end.converge('winrm-config-test::delete_certmapping')
    end

    it 'deletes existing mapping' do
      mock_winrm_get(false, 'old_uri', 'old_subject', 'old_thumbprint', 'old_user')
      mock_winrm_delete('old_uri', 'old_subject', 'old_thumbprint')
      expect(chef_run).to delete_winrm_config_service_certmapping('delete_certmapping')
    end

    it 'does nothing for missing mapping' do
      mock_winrm_get(true, 'old_uri', 'old_subject', 'old_thumbprint', 'old_user')
      cmd = 'winrm.cmd delete config/service/certmapping?Issuer=old_thumbprint+Subject=old_subject+URI=old_uri'
      expect(::Mixlib::ShellOut).to_not receive(:new).with(cmd, anything)
      expect(chef_run).to delete_winrm_config_service_certmapping('delete_certmapping')
    end
  end
end
