# Feature: Navigation links
#   As a visitor
#   I want to see navigation links
#   So I can find home, sign in, or sign up
feature 'Navigation links', :devise do

  # Scenario: View navigation links
  #   Given I am a visitor
  #   When I visit the home page
  #   Then I see "home," "sign in," and "sign up"
  scenario 'view navigation links' do
    visit root_path
    user = FactoryGirl.create(:user)
    signin(user.email, user.password)
    expect(page).to have_content I18n.t 'user.logout'
    expect(page).to have_content I18n.t 'reporter.title'
    expect(page).to have_content I18n.t 'pdf_reporter.title'
    expect(page).to have_content I18n.t 'view.donation.title'
    expect(page).to have_content I18n.t 'view.member.title'
    expect(page).to have_content I18n.t 'view.budget.title'
  end

end
