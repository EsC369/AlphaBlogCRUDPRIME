class ArticlesController < ApplicationController
    before_action :require_user, except: [:index, :show, :vote, :new] # except for the index and show action we need a logged in user
    before_action :require_same_user, only: [:edit, :update, :destroy] # further ensuring only current user can have access to these actions
    respond_to :js, :json, :html

    def index
        if !logged_in?
            flash[:danger] = "You must be logged in to access articles!"
            redirect_to root_path
        else
            @articles = Article.paginate(page: params[:page], per_page: 5)  #instead of Article.all, we have added evertything to show in pages
        end
    end

    def new
        @article = Article.new
    end

    def edit
        # require_same_user
        @article = Article.find(params[:id]) # pulls the already exisiting info
    end

    def create
        @article = Article.new(article_params) #white listing
        @article.user = current_user
        if @article.save
            flash[:notice] = "Article was successfully created"
            redirect_to article_path(@article)
        else
            render "new" 
        end
    end

    def update
        @article = Article.find(params[:id])
        if @article.update(article_params) #white listing
            flash[:notice] = "Article was updated!"
            redirect_to article_path(@article)
        else
            render "edit"
        end
    end

    def show
        @article = Article.find(params[:id]) #Show article id from the params hash
    end

    def destroy
        @article = Article.find(params[:id])
        @article.destroy
        flash[:notice] = "Article was successfully deleted!"
        redirect_to articles_path
    end

    # def liked
    #     if params[:articles] == "like"
    #       User.find(current_user.id).likes.create(article:Article.find(params[:articles_id]))
    #     end
    #     if params[:articles] == "unlike"
    #       User.find(current_user.id).likes.find(params[:articles_id]).destroy
    #     end
    #     redirect_to articles_path
    # end

    def vote
        @article = Article.find(params[:id]) #Show article id from the params hash
        if !current_user.liked? @article
            @article.liked_by current_user
        elsif current_user.liked? @article
            @article.unliked_by current_user
        end
    end

    private
    def article_params
        params.require(:article).permit(:title, :description) # Making them private yet allowing title and description to be allowed through the params hash
    end

    def require_same_user
        @article = Article.find(params[:id]) # Since this is a before action, you must reclarify youre instance variables
        if current_user != @article.user
            flash[:danger] = "You can only manipulate your own articles"
            redirect_to root_path
        end
    end

end
