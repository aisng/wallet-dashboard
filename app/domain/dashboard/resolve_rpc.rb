class Dashboard::ResolveRpc
  def self.for(chain, testnet)
    resolve(chain, testnet)
  end

  private

  def self.api_key
    @api_key ||= ENV.fetch('INFURA_API_KEY')
  end

  def self.resolve(chain, testnet)
    chain_data = Evm::ChainRpc.resolve(chain)
    base_url = testnet ? chain_data[:testnet] : chain_data[:mainnet]

    "#{base_url}#{api_key}"
  end
end
