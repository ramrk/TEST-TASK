class User < ApplicationRecord
	has_many :contacts
	has_many :salaries
	COMPANY_CODE = "EMPLOYEE"	
	validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
	validates :user_code, presence: true
  	validates :user_code_id, presence: true, uniqueness: { scope: :user_code }
  	before_validation :generate_user_code, on: :create


	def tax_deductions(year = nil)
	   puts financial_year_range(nil)
	   total_amount = self.salaries.where(monthly_salaried_date: financial_year_range(year)).sum(:amount)
	   tax_amount = User.calculate_income_tax(total_amount)
	   cess = User.cess(total_amount)
	   {gp: total_amount, tax: tax_amount, np: (total_amount - (tax_amount+cess)), cess: cess}
	end

  	def financial_year_range(year)
    	current_year = year.nil? ? Time.now.year : year 
    	business_year_start = Date.new(current_year, 4, 1)
    	business_year_end = Date.new((current_year + 1), 3, 31)
    	business_year_start..business_year_end
  	end

  	def generate_user_code
    	self.user_code ||= "#{COMPANY_CODE}/#{generate_user_code_id}" 
    	self.user_code_id ||= generate_user_code_id
  	end

  	def generate_user_code_id
    	previou_user = user.where(user_code: user_code).order(user_code_id: :desc).first
    	previou_id = previou_user&.user_code_id || 0
    	previou_id + 1
  	end
    
	def self.calculate_income_tax(amount)
		if income.between?(0, 250000)
			tax = 0
		elsif income.between?(250001, 500000)
			tax = (income - 250000) * 0.05
		elsif income.between?(500001, 1000000)
			tax = 250000 * 0.05 + (income - 500000) * 0.1
  		else
    	  tax = 250000 * 0.05 + 500000 * 0.1 + (income - 1000000) * 0.2
  		end
		return tax
	end

	def self.cess(income)
		(income > 2500000) ? (income * 0.02) : 0  
	end
end

  

