Rails.application.routes.draw do
  resources :loans, defaults: {format: :json}
  resources :payments, defaults: {format: :json}
  
  get 'payments/loan/:loan_id', to: 'payments#show_loan_payments'
  post 'payments/create', to: 'payments#create'
end
