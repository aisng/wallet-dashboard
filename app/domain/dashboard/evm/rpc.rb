class Dashboard::Evm::Rpc
  attr_reader :chain, :method, :testnet, :address, :block_tag, :block_number, :full_transaction

  def self.for(dto)
    new(dto).call
  end

  def initialize(dto)
    @chain = dto.chain
    @testnet = dto.testnet
    @method = dto.method
    @address = dto.address
    @block_tag = dto.block_tag
    @block_number = dto.block_number
    @full_transaction = dto.full_transaction
  end

  def call
    case method
    when :get_balance
      client.balance(address, block_tag)
    when :get_transaction_count
      client.tx_count(address, block_tag)
    when :block_number
      client.block_number
    when :get_block_by_number
      client.block_by_number(block_number, full_transaction)
    else
      raise ArgumentError, "#{self.class} unsupported method: #{method}"
    end
  end

  private

  def rpc_url
    Dashboard::Evm::RpcUrl.for(chain, testnet)
  end

  def client
    @client ||= Evm::Client.new(rpc_url)
  end
end
