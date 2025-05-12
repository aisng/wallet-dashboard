require 'rails_helper'

RSpec.describe Api::V1::DashboardController  do
  describe 'GET #index' do
    it 'calls Evm:ResourcesDto' do
      expect(Evm::ResourcesDto).to receive(:from_constants)
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
  end
end
