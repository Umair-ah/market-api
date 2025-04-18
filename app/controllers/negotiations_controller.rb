

class NegotiationsController < ApplicationController
  before_action :set_negotiation, only: %i[ show edit update destroy ]
  before_action :authenticate_buyer


  def index
    buyer = User.find_by(phone: session[:user_id]) 
    negotiated_proposal_ids = buyer.negotiations.pluck(:proposal_id)


    @proposals = Proposal.joins(:user)
                       .where(users: { taluka: buyer.taluka })
                       .where.not(id: negotiated_proposal_ids)
                       .order(updated_at: :desc)
    render json: {proposals: @proposals}
    
  end

  def index_negotiations
    user = User.find_by(phone: session[:user_id]) 
    @negotiations = user.negotiations
    render json: {negotiations: @negotiations}

  end

  def show
  end

  def new
    respond_to do |format|
      @proposal = Proposal.find(params[:proposal_id])
      user = User.find_by(phone: session[:user_id])
      negotiation_present = user.negotiations.find_by(user_id: user.id, proposal_id: @proposal.id)

      if negotiation_present
        @negotiation = Negotiation.find_by(id: negotiation_present.id )
      else
        @negotiation = Negotiation.new
      end

      format.turbo_stream { 
        render turbo_stream:
        turbo_stream.update(
          "auction-#{@proposal.id}",
          partial: "negotiations/form",
          locals: {negotiation: @negotiation}
        )
      }
    end
  end

  def edit
  end

  def create
    @negotiation = Negotiation.new(negotiation_params)
    if @negotiation.save
      redirect_to index_negotiations_url, notice: "Negotiation was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @negotiation.update(negotiation_params)
      redirect_to negotiation_url(@negotiation), notice: "Negotiation was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @negotiation.destroy
    redirect_to negotiations_url, notice: "Negotiation was successfully destroyed."
  end

  private
    def set_negotiation
      @negotiation = Negotiation.find(params[:id])
    end

    def negotiation_params
      params.require(:negotiation).permit(:user_id, :proposal_id, :price)
    end

    def authenticate_buyer
      current_user = User.find_by(phone: session[:user_id])
      if current_user.role != "buyer"
        redirect_to root_path, alert: "you are not authorized."
      end
    end
end













