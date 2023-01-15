Rails.application.routes.draw do
  
  namespace :admin do
    resources :merchants, except: [:destroy]
    resources :invoices, only: [:index, :show]
    resources :dashboard, only: [:index]
  end

  resources :merchants, only:[] do
    resources :items, except: [:destroy], controller: "merchant_items"
    resources :invoices, except: [:destroy], controller: "merchant_invoices"
    resources :dashboard, only: [:index], controller: "merchants"
    resources :bulk_discounts, only: [:index], controller: "merchants/bulk_discounts"
  end

  resources :invoices, only:[:update]
  resources :invoice_items, only: [:update]
end

