require 'rails_helper'

RSpec.describe Evm::Client do
  let(:subject_instance) { described_class.new(rpc_url) }

  let(:rpc_url) { 'http://mainnet-rpc/api_key' }
  let(:wallet_address) { '0x1111111111111111111111111111111111111111' }

  let(:request) do
    {
      'jsonrpc' => '2.0',
      'method' => method,
      'params' => params,
      'id': 1
    }
  end

  let(:response) do
    {
      status: 200,
      headers: { content_type: 'application/json' },
      body: {
        result: result,
        id: 1,
        jsonrpc: '2.0'
      }.to_json
    }
  end

  shared_examples 'invalid address' do
    let(:wallet_address) { '0x01' }

    it 'raises an ArgumentError' do
      expect { subject }.to raise_error(ArgumentError, "#{described_class} invalid address")
    end
  end

  context 'when rpc response is 200' do
    before do
      stub_request(:post, rpc_url).with(body: request).to_return(response)
    end

    describe '#balance' do
      subject { subject_instance.balance(wallet_address) }

      let(:result) { '0x1' }
      let(:method) { 'eth_getBalance' }
      let(:params) { [wallet_address, 'latest'] }

      context 'with wallet address valid' do
        it 'returns balance in hexadecimal' do
          expect(subject.to_i(16)).to eq(1)
        end
      end

      context 'with wallet address invalid' do
        let(:wallet_address) { 'abcd' }

        it_behaves_like 'invalid address'
      end
    end

    describe '#tx_count' do
      subject { subject_instance.tx_count(wallet_address) }

      let(:result) { '0x5' }
      let(:method) { 'eth_getTransactionCount' }
      let(:params) { [wallet_address, 'latest'] }

      context 'with wallet address valid' do
        it 'returns transaction count in hexadecimal' do
          expect(subject.to_i(16)).to eq(5)
        end
      end

      context 'with wallet address invalid' do
        let(:wallet_address) { '0x01' }

        it_behaves_like 'invalid address'
      end
    end

    describe '#block_number' do
      subject { subject_instance.block_number }

      let(:result) { '0x9' }
      let(:method) { 'eth_blockNumber' }
      let(:params) { [] }

      it 'returns latest block number in hexadecimal' do
        expect(subject.to_i(16)).to eq(9)
      end
    end

    describe '#block_by_number' do
      subject { subject_instance.block_by_number(block_number) }

      let(:result) { { hash: '0x123' } }
      let(:block_number) { 2 }
      let(:block_number_hex) { "0x#{block_number.to_s(16)}" }
      let(:method) { 'eth_getBlockByNumber' }
      let(:params) { [block_number_hex, true] }

      it 'returns block information' do
        expect(subject).to include('hash' => '0x123')
      end
    end
  end

  context 'when rpc response is not 200' do
    before do
      stub_request(:post, rpc_url).to_return({ status: 500 })
    end

    it 'raises an RPC error' do
      expect { subject_instance.block_number }.to raise_error(RuntimeError).with_message(/#{described_class} RPC Error: 500/)
    end
  end
end
