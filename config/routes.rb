Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # resource :admin, only: :index

  namespace :admin do
    resources :merchants, except: [:new, :create, :destroy]
    # resources :merchants, only: [:index, :show, :update, :edit]
  end

end
