class DashboardPresenter
  def initialize
    @methods = Evm::Constants::METHODS
    @chains = Evm::ChainRpc::CHAINS
  end

  def rpc_methods
    @methods.keys.map do |key|
      label = key.to_s.gsub('get', '').titleize.humanize
      { label: label, method: key.to_s }
    end
  end

  def available_chains
    @chains.keys.map { |c| c.to_s.capitalize }
  end
end
