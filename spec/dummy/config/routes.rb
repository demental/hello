Rails.application.routes.draw do
  get 'middleware/bad_kitty', constraints: -> (request) { request.env['hello'].signed_in? }

  # Hello::Routing

  get 'routing/foo' => 'root#index'
  authenticated do
    get 'routing/auth' => 'root#index'
  end

  not_authenticated do
    get 'routing/not_auth' => 'root#index'
  end

  current_user -> (u) { u.blank? } do
    get 'routing/current_user_blank' => 'root#index'
  end

  current_user -> (u) { u.present? } do
    get 'routing/current_user_present' => 'root#index'
  end

  # Hello::Railsy::Controller::KickingConcern
  get 'my_areas/guest_page'
  get 'my_areas/authenticated_page'
  get 'my_areas/onboarding_page'
  get 'my_areas/user_page'
  get 'my_areas/webmaster_page'
  get 'my_areas/non_webmaster_page'

  get 'onboarding' => 'onboarding#index'
  post 'onboarding' => 'onboarding#continue'

  resources :users, only: [:index, :show] do
    collection do
      get 'list'
    end
    member do
      post 'impersonate'
    end
  end


  # not_authenticated do
  #   get 'some/route'
  # end
  #
  # authenticated do
  #   get 'some/route'
  #
  #   current_user -> (u) { u.webmaster? } do
  #     get 'some/route'
  #   end
  #
  #   current_user -> (u) { u.user? } do
  #     get 'some/route'
  #   end
  # end

  root to: 'root#index'
  mount Hello::Engine => '/hello'
end
