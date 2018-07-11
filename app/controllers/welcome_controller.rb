class WelcomeController < ApplicationController
    def home
        redirect_to articles_path if logged_in? # if logged in then redirect to articles page
    end

    def about

    end
end
