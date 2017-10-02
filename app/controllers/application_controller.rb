class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  rescue_from ActiveRecord::RecordNotFound, with: :resourse_not_found
  
  protected
  
  def resourse_not_found
    
  end
end
