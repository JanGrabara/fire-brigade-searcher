Rails.application.routes.draw do
  root 'firestations#show', as: 'home'
  get 'firestations' => 'firestations#show', as: 'show'
end
