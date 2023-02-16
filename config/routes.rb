Rails.application.routes.draw do
  devise_for :users, skip: :all
  namespace "api" do
    namespace "v1" do

      scope "user" do
        post 'login', to: 'user#login'
        delete 'logout', to: 'user#logout'
        get "index", to: "user#index"
        get "show/:id", to: "user#show"
        post "create", to: "user#create"
        patch "update/:id", to: "user#update"
        delete "delete/:id", to: "user#delete"
      end

      scope "question" do
        get "index", to: "question#index"
        get "show/:id", to: "question#show"
        post "create", to: "question#create"
        patch "update/:id", to: "question#update"
        delete "delete/:id", to: "question#delete"
      end

      scope "quiz" do
        get "index", to: "quiz#index"
        get "show/:id", to: "quiz#show"
        post "create", to: "quiz#create"
        patch "update/:id", to: "quiz#update"
        delete "delete/:id", to: "quiz#delete"
        post "add_question", to: "quiz#add_question"
      end

      scope "statistic" do
        get "index", to: "statistic#index"
        get "show/:id", to: "statistic#show"
        patch "update/:id", to: "statistic#update"
      end

      scope "team" do
        get "index", to: "team#index"
        get "show/:id", to: "team#show"
        post "create", to: "team#create"
        patch "update/:id", to: "team#update"
        delete "delete/:id", to: "team#delete"
        post "add_user_to_team", to: "team#add_user_to_team"
        delete "remove_user_from_team", to: "team#remove_user_from_team"
      end

    end
  end
end
