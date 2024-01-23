class TaxDeductionsController < ApplicationController
	before_action :user, only: [:create]
	
	def create
	   render json: {success: false,message: "Invalide user"} && return unless user.present?
	   @salary = Salary.new(salary_params)
	   @salary.employee_id = @user.id
	   if @salary.save
      	render json: @salary, status: :created, location: @user
       else
        render json: @salary.errors, status: :unprocessable_entity
       end
	end

	private

	def user
		@user ||= user.find_by(id: params[:employee_id])
	end

	def salary_params
      params.require(:salary).permit(:employee_id, :amount, :credit_date, :start_date, :end_date)
    end
end
