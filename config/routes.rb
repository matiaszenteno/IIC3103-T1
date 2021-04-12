Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'

  # Search character
  post '/search', to: 'welcome#search'

  # Episodes by season show
  get '/seasons/:show/:season_id', to: 'welcome#season'
  get '/episodes/:episode_id', to: 'welcome#episode'
  get '/characters/:character_id', to: 'welcome#char'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

