class UsersController < ApplicationController
  before_action :set_user_by_session, only: [:logout]

  def signup
    @user = User.new(user_params)
    @user.verified = true if @user.role == "buyer"

    if @user.save
      render json: { message: "Successfully Signed Up", user: user_response(@user) }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    phone = params[:phone]
    @user = User.find_by(phone: phone)

    if @user
      render json: { message: "Successfully Logged In", user: user_response(@user) }, status: :ok
    else
      render json: { error: "Invalid phone number" }, status: :unauthorized
    end
  end

  def logout
    render json: { message: "Successfully Logged Out" }, status: :ok
  end



  def talukas
    india_data = YAML.load_file(Rails.root.join('config', 'India.yml'))
    district = params[:id]
    talukas = india_data.select { |_, data| data[:district] == district }.map { |_, data| data[:city] }.uniq
    render json: talukas, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:name, :phone, :role, :district, :taluka)
  end

  def set_user_by_session
    @user = User.find_by(phone: params[:phone])
  end

  def user_response(user)
    {
      id: user.id,
      name: user.name,
      phone: user.phone,
      role: user.role,
      district: user.district,
      taluka: user.taluka,
      verified: user.verified
    }
  end
end
