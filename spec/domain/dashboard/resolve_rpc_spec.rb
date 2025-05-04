require 'rails_helper'

RSpec.describe Dashboard::ResolveRpc do
  describe '.for' do
    subject { described_class.for(chain, testnet) }

    let(:chain) { :blockchain }
    let(:testnet) { false }
    let(:api_key) { 'secret' }

    before { allow(ENV).to receive(:fetch).with('INFURA_API_KEY').and_return(api_key) }

    context 'when chain is found' do
      before do
        allow(Evm::ChainRpc)
            .to receive(:resolve)
            .with(chain)
            .and_return(
              {
                  testnet: 'https://testnet-rpc/',
                  mainnet: 'https://mainnet-rpc/'
              }
            )
      end
      context 'and testnet is false' do
        it 'returns mainnet rpc with api key appended' do
          expect(subject).to eq('https://mainnet-rpc/secret')
        end
      end

      context 'and testnet is true' do
        let(:testnet) { true }
        it 'returns testnet rpc with api key appended' do
          expect(subject).to eq('https://testnet-rpc/secret')
        end
      end
    end

    context 'when chain is not found' do
      let(:chain) { :unsupported }

      it 'raises and error' do
        expect { subject }.to raise_error(ArgumentError, "unsupported chain: #{chain}")
      end
    end
  end
end
