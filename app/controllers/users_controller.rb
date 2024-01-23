class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy, :financial_year_net_payable]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def financial_year_net_payable
    @year = params[:year]
    unless @user.present?
      render json: {success: false, message: "Invalide user"}
    end
    @user_salary = @user.tax_deductions(@year)
    render json: { success: true,  
      user: {
		    user_code: @user.user_code ,
		    first_name: @user.first_name ,
		    last_name: @user.last_name ,
		    email: @user.email ,
		    date_of_join: @user.date_of_join ,
		    created_at: @user.created_at ,
		    updated_at: @user.updated_at 
	    },
	    contact: {
        phone: @user&.contact.phone
	    },
      net_payable: {
	      gross: @user_salary[:gp],
	      tax: @user_salary[:tax],
	      net_pay: @user_salary[:np],
	      cess: @user_salary[:cess]
      }
    }
  end

  private
    def set_user
      key = {user_code: params[:user_code]} if params[:user_code].present?
      key = {id: params[:id] || params[:user_id]} if params[:id].present? || params[:user_id].present?
      @user = user.find_by(params[:id]) || user.find_by(user_code: params[:user_code])
    end

    def user_params
      params.require(:user).permit(:user_code, :first_name, :last_name, :email, :date_of_join, contacts_attributes: [:id, :phone, :primary])
    end
end
