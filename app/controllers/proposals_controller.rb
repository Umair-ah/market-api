class ProposalsController < ApplicationController
  before_action :set_proposal, only: %i[update destroy]
  # before_action :authenticate_farmer

  def index
    user = User.find_by(phone: params[:phone])

    proposals = user.proposals
    render json: { proposals: proposals }, status: :ok
  end

  def create
    proposal = Proposal.new(proposal_params)

    if proposal.save
      render json: { message: "Proposal created successfully", proposal: proposal }, status: :created
    else
      render json: { errors: proposal.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @proposal.update(proposal_params)
      render json: { message: "Proposal updated successfully", proposal: @proposal }, status: :ok
    else
      render json: { errors: @proposal.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @proposal.destroy
    render json: { message: "Proposal deleted successfully" }, status: :ok
  end

  private

  def set_proposal
    @proposal = Proposal.find(params[:id])
  end

  def proposal_params
    params.require(:proposal).permit(:title, :quantity, :unit, :price, :user_id)
  end

  def authenticate_farmer
    current_user = User.find_by(phone: params[:phone])
    unless current_user&.role == "farmer" && current_user.verified?
      render json: { error: "You are not authorized" }, status: :forbidden
    end
  end
end
