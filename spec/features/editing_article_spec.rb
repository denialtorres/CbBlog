require "rails_helper"
RSpec.feature "Editing and Article" do
  before do 
    john = User.create(email: "john@example.com", password: "password")
    login_as(john)
    @article = Article.create(title: "First Article", body: "Lorem Ipsum", user: john)
  end

  scenario "A user updates an article" do
    visit "/"
    click_link @article.title
    click_link "Edit Article"
    fill_in "Title", with: "Update Article"
    fill_in "Body", with: "Lorem Ipsum"
    click_button "Update Article"
    expect(page).to have_content("Article has been update")
    expect(page.current_path).to eq(article_path(@article))
  end
  
  scenario "A user fails to update an article" do
    visit "/"
    click_link @article.title 
    click_link "Edit Article"
    fill_in "Title", with: ""
    fill_in "Body", with: "Lorem Ipsum"
    click_button "Update Article"
    expect(page).to have_content("Article has not been update")
    expect(current_path).to eq(article_path(@article))
  end
end