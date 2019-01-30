CleanUpControllerApp::Application.routes.draw do
  resources :users do
    resources :expenses do
      member do
        post "approve" => "expense_approvals#create"
      end
    end
  end
end
