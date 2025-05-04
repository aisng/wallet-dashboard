class DashboardController < ApplicationController
  API_KEY = ENV.fetch('INFURA_API_KEY')
  def index
    @rpc_methods = [
      { label: 'Get Balance', action_type: Evm::Methods::GET_BALANCE },
      { label: 'Get Transaction Count', action_type: Evm::Methods::GET_TRANSACTION_COUNT },
      { label: 'Get Block Number', action_type: Evm::Methods::GET_BLOCK_NUMBER },
      { label: 'Get Block By Number', action_type: Evm::Methods::GET_BLOCK_BY_NUMBER }
    ]
    @available_chains = Evm::ChainRpc::CHAINS.keys.map { |c| c.to_s.capitalize }
    @selected_chain = params[:chain]

    if params[:wallet_address].present? && params[:rpc_method].present?
      rpc_method = params[:rpc_method]
      wallet = params[:wallet_address]
      chain = params[:chain].downcase.to_sym
      testnet = ActiveModel::Type::Boolean.new.cast(params[:testnet])
      puts "-------------------- CHAIN #{chain}"

      network = Evm::ChainRpc.resolve(chain)
      rpc_url = testnet ? network[:testnet] : network[:mainnet]
      @client = Evm::Client.new(rpc_url + API_KEY)

      case rpc_method
      when Evm::Methods::GET_BALANCE then @result = @client.balance(wallet)
      when Evm::Methods::GET_TRANSACTION_COUNT then @result = @client.tx_count(wallet)
      when Evm::Methods::GET_BLOCK_NUMBER then @result = @client.block_number
      when Evm::Methods::GET_BLOCK_BY_NUMBER then @result = @client.block_by_number()
      end
    end

    respond_to do |format|
      format.html
      format.turbo_stream { render partial: 'dashboard/result', locals: { result: @result } }
    end
  end
end
