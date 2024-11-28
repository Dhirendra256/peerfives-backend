Rails.application.routes.draw do
  resources :users do
    resources :transactions, only: [:create, :index, :destroy], path: 'p5'
  end
end
