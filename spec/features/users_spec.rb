require 'rails_helper'

describe "User" do
let!(:user) { FactoryGirl.create :user }

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")
      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end
    
    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
    
    it "when signed up with good credentials, is added to the system" do
	    visit signup_path
	    fill_in('user_username', with:'Brian')
	    fill_in('user_password', with:'Secret55')
	    fill_in('user_password_confirmation', with:'Secret55')
	
	    expect{
	      click_button('Create User')
	    }.to change{User.count}.by(1)
  end
  
	it "can have favorite style and brewery" do
		good = FactoryGirl.create(:brewery, name:"Goodbrewery")
		
		beer = FactoryGirl.create(:beer, style:"Cool")
		FactoryGirl.create(:rating, score:25, beer:beer, user:user)
		good.beers << beer
	
		sign_in(username:"Pekka", password:"Foobar1")
		visit user_path(user)
		
		expect(page).to have_content 'Cool'
		expect(page).to have_content 'Goodbrewery'
	end
		
end
end
