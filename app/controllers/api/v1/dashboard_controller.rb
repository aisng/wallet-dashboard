class Api::V1::DashboardController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    resources = Evm::ResourcesDto.from_constants
    render json: resources.to_h
  end

  def rpc_action
    dto = Evm::RpcDto.new(rpc_params.to_h)

    unless dto.valid?
      render json: { errors: dto.errors }, status: :bad_request
      return
    end

    response = Dashboard::Evm::Rpc.for(dto)

    render json: response
  end

  private

  def rpc_params
    params.require(:dashboard).permit(
        :chain,
        :testnet,
        :method,
        :address,
        :block_tag,
        :block_number,
        :full_transaction
      )
  end
end
