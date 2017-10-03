require "rails_helper"

RSpec.feature "Showing an article" do
  before do
    john = User.create(email: "john@example.com", password: "password")
    @article =  Article.create(title: "The first article", body: "Lorem Ipsum", user: john)
  end
  
  scenario "A user shows and article" do
    visit "/"
    click_link @article.title
    
    expect(page).to have_content(@article.title)
    expect(page).to have_content(@article.body)
    expect(current_path).to eq(article_path(@article))
  end
end
  