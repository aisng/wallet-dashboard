class Api::V1::DashboardController < ApplicationController
  skip_before_action :verify_authenticity_token

  rescue_from Apipie::ParamInvalid, with: :render_param_invalid
  rescue_from Apipie::ParamMissing, with: :render_param_missing

  api :GET, '/api/v1/dashboard', 'Get available chains and RPC methods'
  def index
    resources = Evm::ResourcesDto.from_constants
    render json: resources.to_h
  end

  api :POST, '/api/v1/dashboard', 'Call a blockchain RPC method'
  param :dashboard, Hash, required: true do
    param :chain, String, required: true, desc: 'Blockchain name (e.g. Ethereum)'
    param :testnet, :bool, required: false, desc: 'Flag to indicate if the testnet is used', allow_blank: true
    param :method, String, required: true, desc: 'RPC method to call (e.g. eth_getBalance)'
    param :address, String, required: false, desc: 'Wallet address'
    param :block_tag, String, required: false, desc: 'Block tag (e.g. latest, pending) or block number in decimal', allow_blank: true
    param :block_number, :number, required: false, desc: 'Block number in decimal (e.g. 12345)', allow_blank: true
    param :full_transaction, :bool, required: false, desc: 'Flag to indicate if full transaction details are required', allow_blank: true
  end
  def rpc_action
    dto = Evm::RpcDto.new(rpc_params)

    unless dto.valid?
      render json: { errors: dto.errors }, status: :bad_request
      return
    end

    response = Dashboard::Evm::Rpc.for(dto)
    render json: response
  end

  private

  def render_param_invalid(e)
    param_name = e.param.name
    render json: { error: 'invalid parameter', param: param_name }, status: :bad_request
  end

  def render_param_missing(e)
    param_name = e.param.name
    render json: { error: 'missing parameter', param: param_name }, status: :bad_request
  end

  def rpc_params
    params.require(:dashboard).permit(
      :chain,
      :testnet,
      :method,
      :address,
      :block_tag,
      :block_number,
      :full_transaction
    ).to_h
  end
end
