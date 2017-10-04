class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  
  def index
    @articles = Article.all
    @article = Article.new
  end
  
  def new
    @article = Article.new
  end
  
  def create
    @article = Article.new(article_params)
    @article.user = current_user
    respond_to do |format|
      if @article.save
        format.html { 
          flash[:sucess] = "Article has been created"
          redirect_to articles_path, 
          notice: 'Article has been created'
        }
        format.json { render :show, status: :created, location: @article}
        format.js
      else
        format.html { 
          flash.now[:danger] = "Article has not been created"
          render :new 
        }
        format.json { render json: @article.errors, status: :unprocessable_entity}
        format.js
      end
    end
  end
  
  def show
    @comment = @article.comments.build
    @comments = @article.comments
  end
  
  def edit
    unless @article.user == current_user
      flash[:alert] = "You can only edit your own article."
      redirect_to root_path
    end
  end
  
  def update 
    unless @article.user == current_user
      flash[:alert] = "You can only edit your own article."
      redirect_to root_path
    else
      if @article.update(article_params)
        flash[:success] = "Article has been update"
        redirect_to @article
      else
        flash.now[:danger] = "Article has not been updated"
        render :edit
      end
    end
  end
  
  def destroy 
    unless @article.user == current_user
      flash[:danger] = "You can only delete your own article."
      redirect_to articles_path
    else
      if @article.destroy
        flash[:success] = "Article has been deleted"
        redirect_to articles_path
      else
        flash.now[:danger] = "Article has not been deleted"
        redirect_to articles_path
      end
    end
  end
  
  protected
  def resourse_not_found
    message = "The article you are looking for could not be found"
    flash[:alert] = message
    redirect_to root_path
  end
  
  private
    def article_params
      params.require(:article).permit(:title, :body)
    end
    
    def set_article
      @article = Article.find(params[:id])
    end
end
