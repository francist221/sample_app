require 'spec_helper'

describe "LayoutLinks" do

  it "should have a Home page at '/'" do # Show home page
    get '/'
    response.should have_selector('title', :content => "Home")
  end

  it "should have a Contact page at '/contact'" do 
    get '/contact'
    response.should have_selector('title', :content => "Contact")
  end

  it "should have an About page at '/about'" do
    get '/about'
    response.should have_selector('title', :content => "About")
  end

  it "should have a Help page at '/help'" do
    get '/help'
    response.should have_selector('title', :content => "Help")
  end

  it "should have a signup page at '/signup'" do
    get '/signup'
    response.should have_selector('title', :content => "Sign up")
  end

  describe "when not signed in" do # When the user has not sign in, it shows a sign in link
    it "should have a signin link" do
      visit root_path
      response.should have_selector("a", :href => signin_path,
                                         :content => "Sign in")
    end
  end

  describe "when signed in" do # when the user has sign in

    before(:each) do # fill in the user
      @user = Factory(:user)
      visit signin_path
      fill_in :email,    :with => @user.email
      fill_in :password, :with => @user.password
      click_button
    end

    it "should have a signout link" do # Show a sign out link
      visit root_path
      response.should have_selector("a", :href => signout_path,
                                         :content => "Sign out")
    end

    it "should have a profile link" # Show a profile link
      visit root_path
      response.should have_selector("a", :href => user_path(@user),
                                         :content => "Profile")
  end
end

