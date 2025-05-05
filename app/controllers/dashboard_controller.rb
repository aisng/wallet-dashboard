class DashboardController < ApplicationController
  before_action :set_presenter_data, only: [:index]

  def index
  end

  def search
    if params[:wallet_address].present? && params[:rpc_method].present?
      rpc_method = params[:rpc_method]

      @result = Dashboard::CallBlockchain.for(rpc_method, params_hash)
    end

    respond_to do |format|
      format.html
      format.turbo_stream { render partial: 'dashboard/result', locals: { result: @result } }
    end
  end

  private

  def params_hash
    {
      address: params[:wallet_address],
      chain: params[:chain].downcase.to_sym,
      testnet: ActiveModel::Type::Boolean.new.cast(params[:testnet])
    }
  end

  def set_presenter_data
    presenter = DashboardPresenter.new

    @rpc_methods = presenter.rpc_methods
    @available_chains = presenter.available_chains
  end
end
