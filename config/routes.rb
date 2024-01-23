Rails.application.routes.draw do
  resources :users do
    resources :tax_deductions, only: [:create, :show, :update]
    member do
      get :financial_year_net_payable
    end
  end
end

