require 'rails_helper'

RSpec.describe DashboardPresenter do
  subject { described_class.new }

  describe '#rpc_methods' do
    let(:methods) do
      {
      get_balance: 'eth_getBalance',
      get_transaction_count: 'eth_getTransactionCount'
    }
    end

    before { stub_const('Evm::Constants::METHODS', methods) }
    it 'returns an array of hashes with labels and methods' do
      expect(subject.rpc_methods).to match_array([
          { label: 'Balance', method: 'get_balance' },
          { label: 'Transaction count', method: 'get_transaction_count' }
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
