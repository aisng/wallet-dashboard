require 'rails_helper'

RSpec.describe Evm::ChainRpc do
  subject { described_class.resolve(chain) }
  let(:chain) { :ethereum }

  describe '.resolve' do
    context 'when chain is supported' do
      it 'returns a hash with chain urls' do
        expect(subject).to include(:mainnet, :testnet)
      end
    end

    context 'chain is not supported' do
      let(:chain) { :unsupported_chain }

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError, 'unsupported chain: unsupported_chain')
      end
    end
  end
end
