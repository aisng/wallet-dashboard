class DashboardPresenter
  def initialize
    @methods = Evm::Constants::RPC_METHOD_MAP
    @chains = Evm::ChainRpc::CHAINS
  end

  def rpc_methods
    @methods.keys.map do |key|
      label = key.gsub('eth_get', '').gsub('eth', '').titleize.humanize
      { label: label, method: key }
    end
  end

  def available_chains
    @chains.keys.map { |c| c.to_s.capitalize }
  end
end
