Rails.application.routes.draw do
  root 'dashboard#index'

  resources :reconcile_transactions do
    resources :summaries do
      collection do
        get :general_summary
      end
      member do
        get :export_discrepancies
      end
    end

    member do
      get :imported_data
    end
  end
end
