class NegotiationsController < ApplicationController
  before_action :set_negotiation, only: %i[update destroy]
  before_action :authenticate_buyer

  def index
    buyer = User.find_by(phone: params[:phone]) 
    negotiated_proposal_ids = buyer.negotiations.pluck(:proposal_id)

    @proposals = Proposal.joins(:user)
                         .where(users: { taluka: buyer.taluka })
                         .where.not(id: negotiated_proposal_ids)
                         .order(updated_at: :desc)
    
    render json: { proposals: @proposals }, status: :ok
  end

  def index_negotiations
    user = User.find_by(phone: params[:phone]) 
    @negotiations = user.negotiations
    render json: { negotiations: @negotiations }, status: :ok
  end

  def create
    @negotiation = Negotiation.new(negotiation_params)
    if @negotiation.save
      render json: { negotiation: @negotiation, message: "Negotiation was successfully created." }, status: :created
    else
      render json: { errors: @negotiation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @negotiation.update(negotiation_params)
      render json: { negotiation: @negotiation, message: "Negotiation was successfully updated." }, status: :ok
    else
      render json: { errors: @negotiation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @negotiation.destroy
    head :no_content
  end

  private

  def set_negotiation
    @negotiation = Negotiation.find(params[:id])
  end

  def negotiation_params
    params.require(:negotiation).permit(:user_id, :proposal_id, :price)
  end

  def authenticate_buyer
    current_user = User.find_by(phone: params[:phone])
    unless current_user&.role == "buyer"
      render json: { error: "You are not authorized." }, status: :unauthorized
    end
  end
end
