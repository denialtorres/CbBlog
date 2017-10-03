require 'rails_helper'
RSpec.describe "Articles", type: :request do
  before do
    @john = User.create(email: "john@example.com", password: "password")
    @fred = User.create(email: "fred@example.com", password: "password")
    @article = Article.create!(title: "Title One", body: "Body of article one", user: @john)
  end
  
      
      describe 'GET /articles/:id/edit' do
        context 'with non-signed in user' do
          before{ get "/articles/#{@article.id}/edit"}
          
          it "redirecs to the signing page" do
            expect(response.status).to eq 302
            flash_message = "You need to sign in or sign up before continuing."
            expect(flash[:alert]).to eq flash_message
          end
        end
        
        context 'with signed in user who is non-owner' do
          before do 
            login_as(@fred)
            get "/articles/#{@article.id}/edit"
          end
          
          it "redirecs to the home page" do 
            expect(response.status).to eq 302
            flash_message = "You can only edit your own article."
            expect(flash[:alert]).to eq flash_message
          end
        end
        
        context 'with signed in user as owner successful edit' do
          before do
            login_as(@john)
            get "/articles/#{@article.id}/edit"
          end
          
          it "successfully edits article" do
            expect(response.status).to eq 200
          end
        end
      end
      
      describe 'GET /articles/:id' do
        context 'with exisiting article' do
          before{ get "/articles/#{@article.id}"}
          
          it "handles exisiting article" do
            expect(response.status).to eq 200
          end
        end
        
        context 'with non existing article' do
          before {get "/articles/xxxxx"}
          it "handles non-existing article" do
            expect(response.status).to eq 302
            flash_message = "The article you are looking for could not be found"
            expect(flash[:alert]).to eq flash_message
          end
        end
      end
      
    
    # Attempt at avoiding random users deleting articles
    
    describe 'DELETE /articles/:id/' do
      context 'non signed in user cannot delete the article' do
        before { delete "/articles/#{@article.id}/" }
        
        it "redirects to signin page" do
          expect(response.status).to eq 302
          flash_message = "You need to sign in or sign up before continuing."
          expect(flash[:alert]).to eq flash_message
        end
      end
      
      context 'Signed in user but not article owner cannot delete article' do
        before do
          login_as(@fred)
          delete "/articles/#{@article.id}"
        end
        
        it "Redirects to homepage" do
          expect(response.status).to eq 302
          flash_message = "You can only delete your own article."
          expect(flash[:danger]).to eq flash_message
        end
      end
      
      context 'with signed in user as owner successful delete' do
          before do
            login_as(@john)
            delete "/articles/#{@article.id}/"
          end
          
          it "successfully edits article" do
            flash_message = "Article has been deleted"
            expect(flash[:success]).to eq flash_message
            expect(response.status).to eq 302
          end
      end
    end
  
end