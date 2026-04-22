# ═══════════════════════════════════════════════════════════════
# YOUNG BLACK NAMELESS COALITION — Rails Scaffold
# Ashley Dorelus · Vallejo, CA · Black Liberation
# ═══════════════════════════════════════════════════════════════


# ── config/routes.rb ────────────────────────────────────────────

Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resources :dashboards
  resources :pages
  root "landing_pages#index"

  # Public pages
  get "/mission",     to: "pages#mission",     as: :mission
  get "/focus",       to: "pages#focus",        as: :focus
  get "/about",       to: "pages#about",        as: :about
  get "/resources",   to: "pages#resources",    as: :resources
  get "/contact",     to: "pages#contact",      as: :contact
  get "/privacy",     to: "pages#privacy",      as: :privacy
  get "/donate",      to: "pages#donate",       as: :donate

  # Events
  resources :events, only: [:index, :show] do
    collection { get :past }
  end

  # Initiatives / campaigns
  resources :initiatives, only: [:index, :show]

  # Resources library
  resources :resource_items, only: [:index], path: "library"

  # Member-facing actions
  resources :newsletter_subscriptions, only: [:create], path: "subscribe"
  resources :volunteer_applications,   only: [:create], path: "volunteer"
  resources :contact_messages,         only: [:create], path: "contact"
  resources :donation_intents,         only: [:create], path: "donate"

  # Admin (protect with simple HTTP auth or Devise in production)
  namespace :admin do
    root "dashboard#index"
    resources :events
    resources :initiatives
    resources :resources, as: :resource_items, controller: :resources
    resources :members do
      member { patch :approve; patch :deactivate }
    end
    resources :newsletter_subscriptions, only: [:index, :destroy]
    resources :volunteer_applications    do
      member { patch :mark_reviewed; patch :accept; patch :decline }
    end
    resources :contact_messages,  only: [:index, :show, :destroy] do
      member { patch :mark_read }
    end
    resources :donations,         only: [:index, :show]
    resource  :settings,          only: [:show, :update]
  end
end