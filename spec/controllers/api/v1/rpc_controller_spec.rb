require 'rails_helper'

RSpec.describe Api::V1::RpcController, type: :controller  do
  describe 'GET #resources' do
    it 'calls Evm:ResourcesDto and returns 200' do
      expect(Evm::ResourcesDto).to receive(:from_constants)
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #call' do
    let(:dto) { instance_double(Evm::RpcDto, valid?: true) }

    context 'with valid parameters' do
      let(:request_params) do
        {
          'dashboard' => {
            'chain' => 'blockchain',
            'testnet' => 'false',
            'method' => 'eth_getBalance',
            'block_tag' => 'latest',
            'block_number' => '',
            'full_transaction' => 'true'
          }
        }
      end

      let(:rpc_params) { request_params['dashboard'].symbolize_keys }

      before do
        allow(Evm::RpcDto).to receive(:new).with(rpc_params).and_return(dto)
        allow(Dashboard::Evm::Rpc).to receive(:for).with(dto).and_return({ result: 100 })
      end

      it 'it returns 200' do
        post :rpc_action, params: request_params
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid parameters' do
      let(:dto) { instance_double(Evm::RpcDto, valid?: false, errors: { chain: 'invalid' }) }

      let(:request_params) do
        {
          'dashboard' => {
            'chains' => 'blockchains',
            'testnet' => 'false',
            'method' => 'eth_getBalance',
            'block_tag' => 'latest',
            'block_number' => '',
            'full_transaction' => 'true'
          }
        }
      end

      let(:rpc_params) { request_params['dashboard'].symbolize_keys }

      before do
        allow(Evm::RpcDto).to receive(:new).with(rpc_params).and_return(dto)
      end

      it 'returns 400' do
        post :rpc_action, params: request_params
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
