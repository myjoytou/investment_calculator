Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  get 'home/get_schemes'
  get 'home/calculate_units'
  get 'home/mutual_funds'
  get 'home/calculate_investment'
end
