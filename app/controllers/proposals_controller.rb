class ProposalsController < ApplicationController
  before_action :set_proposal, only: %i[ show edit update destroy ]
  before_action :authenticate_farmer

  def index
    @user = User.find_by(phone: session[:user_id])
    @proposals = @user.proposals
    render json: {proposals: @proposals}
  end

  def show
  end

  def new
    @proposal = Proposal.new
    render json: {proposal: @proposal}

  end

  def edit
  end

  def create
    @proposal = Proposal.new(proposal_params)
    
    if @proposal.save
      redirect_to proposal_url(@proposal), notice: "Proposal was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @proposal.update(proposal_params)
      redirect_to proposal_url(@proposal), notice: "Proposal was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # def destroy
  #   @proposal.destroy
  #   redirect_to proposals_url, notice: "Proposal was successfully destroyed."
  # end

  private
    def set_proposal
      @proposal = Proposal.find(params[:id])
    end

    def proposal_params
      params.require(:proposal).permit(:title, :quantity, :unit, :price, :user_id)
    end
  
    def authenticate_farmer
      current_user = User.find_by(phone: session[:user_id])
      if current_user.role != "farmer" || !current_user.verified?
        redirect_to root_path, alert: "you are not authorized."
      end
    end
end
