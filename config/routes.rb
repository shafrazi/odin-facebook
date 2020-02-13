Rails.application.routes.draw do
  devise_for(:users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" })
  get("static_pages/home")
  root("static_pages#home")

  resources(:posts)
  resources(:users)
  resources(:friendships)
  resources :friend_requests

  post "friend_requests/accept_friend_request", to: "friend_requests#accept_friend_request", as: "accept_friend_request"

  get("/user_posts", to: "posts#user_posts", as: "user_posts")
end
