require 'rails_helper'

describe "Beer" do

	let!(:user) { FactoryGirl.create :user }

	before :each do
		FactoryGirl.create(:brewery)
		FactoryGirl.create(:style)
		sign_in(username:"Pekka", password:"Foobar1")
	end
	
	it "can be created with valid name" do
		
		visit new_beer_path
		fill_in('beer_name',with: "Beer")
		expect{click_button "Create Beer"}.to change{Beer.count}.from(0).to(1)
	end
	
	it "cannot be created with invalid name" do
		visit new_beer_path
		click_button "Create Beer"
		
		expect(Beer.count).to eq(0)
		expect(page).to have_content "Name can't be blank"
	end
end
