class Evm::Client

  attr_reader :client

  def initialize(rpc_url)
    @client = Faraday.new(url: rpc_url) do |c|
      c.request :json
      c.response :json, content_type: /\bjson/
      c.adapter Faraday.default_adapter
    end
  end

  def balance(address)
    address_valid?(address)
    request(Evm::Methods::GET_BALANCE, address, 'latest')
  end

  def tx_count(address)
    address_valid?(address)
    request(Evm::Methods::GET_TRANSACTION_COUNT, address, 'latest')
  end

  def block_number
    request(Evm::Methods::GET_BLOCK_NUMBER)
  end

  def block_by_number(block_number)
    block_hex = "0x#{block_number.to_s(16)}"
    request(Evm::Methods::GET_BLOCK_BY_NUMBER, block_hex, true)
  end

  private

  def api_key
    ENV.fetch('INFURA_API_KEY')
  end

  def request(method, *params)
    response = @client.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        jsonrpc: '2.0',
        method: method,
        params: params,
        id: 1
      }
    end

    raise "#{self.class} RPC Error: #{response.status} #{response.body}" if response.body['error'] || response.status != 200

    response.body['result']
  end

  def address_valid?(address)
    raise ArgumentError, "#{self.class} invalid address" unless address.match(/^(0x)?[0-9a-fA-F]{40}$/) && address.length == 42
  end

end
