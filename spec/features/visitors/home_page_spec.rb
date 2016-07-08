# Feature: Home page
#   As a visitor
#   I want to visit a home page
#   So I can learn more about the website
feature 'Home page' do

  # Scenario: Visit the home page
  #   Given I am a visitor
  #   When I visit the home page
  #   Then I see "Welcome"
  scenario 'visit the home page' do
    visit root_path
    user = FactoryGirl.create(:user)
    signin(user.email, user.password)
    expect(page).to have_content 'Assalam-o-Alaikum'
    expect(page).to have_content 'Mitglieder'
    expect(page).to have_content 'Alle Belege'
    expect(page).to have_content 'Chanda'
  end

end
