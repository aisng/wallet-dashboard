require 'rails_helper'

RSpec.describe DashboardPresenter do
  subject { described_class.new }

  describe '#rpc_methods' do
    let(:methods) do
      {
      'eth_getBalance' => :balance,
      'eth_getTransactionCount' => :tx_count
    }
    end

    before { stub_const('Evm::Constants::RPC_METHOD_MAP', methods) }
    it 'returns an array of hashes with labels and methods' do
      expect(subject.rpc_methods).to match_array([
          { label: 'Balance', method: 'eth_getBalance' },
          { label: 'Transaction count', method: 'eth_getTransactionCount' }
        ])
    end
  end

  describe '#available_chains' do
    let(:chains) do
      {
       ethereum: { testnet: 'testnet1', mainnet: 'mainnet1' },
       optimism: { testnet: 'testnet2', mainnet: 'mainnet2' }
      }
    end

    before { stub_const('Evm::ChainRpc::CHAINS', chains) }

    it 'returns an array of capitalized chain names' do
      expect(subject.available_chains).to match_array(['Ethereum', 'Optimism'])
    end
  end
end
