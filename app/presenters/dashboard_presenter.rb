class DashboardPresenter
  def initialize
    @methods = Evm::Constants::METHODS
    @chains = Evm::ChainRpc
  end

  def rpc_methods
    @methods.map do |key, val|
      label = key.to_s.gsub('get_', '').gsub('_', ' ').capitalize
      { label: label, method: val }
    end
  end

  def available_chains
    Evm::ChainRpc::CHAINS.keys.map { |c| c.to_s.capitalize }
  end
end
