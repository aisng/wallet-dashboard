class Evm::ChainRpc

  CHAINS = {
    ethereum: {
      mainnet: 'https://mainnet.infura.io/v3/',
      testnet: 'https://sepolia.infura.io/v3/'
    },
    base: {
      mainnet: 'https://base-mainnet.infura.io/v3/',
      testnet: 'https://base-sepolia.infura.io/v3/'
    },
    linea: {
      mainnet: 'https://linea-mainnet.infura.io/v3/',
      testnet: 'https://linea-sepolia.infura.io/v3/'
    },
    polygon: {
      mainnet: 'https://polygon-mainnet.infura.io/v3/',
      testnet: 'https://polygon-amoy.infura.io/v3/'
    }
  }.freeze

  def self.resolve(name)
    CHAINS[name.to_sym] || raise(ArgumentError, "unsupported chain: #{name}")
  end

end
