class NegotiationsController < ApplicationController
  before_action :set_negotiation, only: %i[update destroy]
  #before_action :authenticate_buyer


  def deal
    negotiation_id = params[:negotiation_id]
    neg = Negotiation.find(negotiation_id)
    neg.deal = true
    neg.save
    render json: {negotiation: neg, message: "Deal Success"}, status: :ok
  end

  # display buyer (self) negotiations
  def my_negotiations
    user = User.find_by(phone: params[:phone])

    if user.role == "Buyer"
      negotiations = user.negotiations.includes(:proposal)

      merged_negotiations = negotiations.map do |negotiation|
        negotiation.attributes.merge(negotiation.proposal.attributes.except("created_at", "updated_at", "user_id", "id"))
      end

      render json: {
        negotiations: merged_negotiations,
        message: "Display Negotiations Made By Buyer Works"
      }, status: :ok
    else
      render json: { error: "Unauthorized or user not foundssss" }, status: :unauthorized
    end
  end

  # display all proposals taluka wise (buyer pov)
  def index
    buyer = User.find_by(phone: params[:phone]) 
    negotiated_proposal_ids = buyer.negotiations.pluck(:proposal_id)

    @proposals = Proposal.joins(:user)
                         .where(users: { taluka: buyer.taluka })
                         .where.not(id: negotiated_proposal_ids)
                         .order(updated_at: :desc)
    
    render json: { proposals: @proposals }, status: :ok
  end

  # display all negotiations of respective proposal (farmer pov)
  def index_negotiations
    proposal = Proposal.find(params[:proposal_id])
    @negotiations = proposal.negotiations
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
