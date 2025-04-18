require 'yaml'
class UsersController < ApplicationController
  before_action :load_districts_and_talukas

  def signup_page
    @user = User.new
    render json: { user: @user, districts: @districts, talukas: @talukas }
  end

  def signup
    @user = User.new(user_params)

    if @user.role == "buyer"
      @user.verified = true
    end

    if @user.save
      session[:user_id] = @user.phone
      redirect_to root_path, notice: "Successfully Signed Up!"
    else
      render :signup_page, status: :unprocessable_entity
    end

  end


  def login_page; end

  def login
    phone = params[:phone]
    @user = User.find_by(phone: phone)

    if @user
      session[:user_id] = @user.phone
      redirect_to root_path, notice: "Successfully Logged In!"
    end
  end

  def logout
    session.clear
    redirect_to root_path, notice: "Successfully Logged Out!"
  end

  def settings
    @user = User.find_by(phone: session[:user_id])
  end

  def settings_save
    @user = User.find_by(phone: session[:user_id])
    @user.update!(user_params)
    redirect_to settings_path, notice: "Saved!"

  end

  def talukas
    india_data = YAML.load_file(Rails.root.join('config', 'India.yml'))
    district = params[:id]
    talukas = india_data.select { |_, data| data[:district] == district }.map { |_, data| data[:city] }.uniq
    render json: talukas
  end


  private

  def user_params
    params.require(:user).permit(:name, :phone, :role, :district, :taluka)
  end

  def load_districts_and_talukas
    india_data = YAML.load_file(Rails.root.join('config', 'India.yml'))
    @districts = india_data.values.map { |data| data[:district] }.uniq
    @talukas = india_data.values.map { |data| data[:city] }.uniq
  end
  
  
end