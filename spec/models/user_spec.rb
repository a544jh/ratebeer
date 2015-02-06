require 'rails_helper'

describe User do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end
  
  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end
  
  it "is not saved with a too short password" do
    user = User.create username:"Pekka", password:"Pw1", password_confirmation:"Pw1"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end
  
  it "is not saved with a password consisting only of letters" do
    user = User.create username:"Pekka", password:"asdfgh", password_confirmation:"asdfgh"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end
  
  
  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end
  
  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end
    
    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(10, user, "Anon")

      expect(user.favorite_beer).to eq(beer)
    end
    
    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, 9, user, "Anon")
      best = create_beer_with_rating(25, user, "Anon")

      expect(user.favorite_beer).to eq(best)
    end
  end
  
  describe "favorite style" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end
    
    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(10, user,"Anon")

      expect(user.favorite_style).to eq("Anon")
    end
    
    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, 9, user, "Anon")
      best = create_beer_with_rating(25, user, "Cool")
      expect(user.favorite_style).to eq("Cool")
    end
  end
  
  describe "favorite brewery" do
	let(:user){FactoryGirl.create(:user)}
	
	it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end
    
    it "is the only rated if only one rating" do
	  b = FactoryGirl.create(:brewery)
      beer = create_beer_with_rating(10, user, "Anon")
      b.beers << beer

      expect(user.favorite_brewery).to eq(b)
    end
    
    it "is the one with highest rating if several rated" do
      bad = FactoryGirl.create(:brewery)
      create_beers_with_ratings_and_brewery(10, 20, 15, 7, 9, user, "Anon", bad)
      good = FactoryGirl.create(:brewery, name:"Goodbrewery")
      best = create_beer_with_rating(25, user, "Cool")
      good.beers << best

      expect(user.favorite_brewery).to eq(good)
    end
  end
  
end

def create_beer_with_rating(score, user, style)
      beer = FactoryGirl.create(:beer, style:style)
      FactoryGirl.create(:rating, score:score, beer:beer, user:user)
      beer
end

def create_beers_with_ratings(*scores, user, style)
  scores.each do |score|
    create_beer_with_rating(score, user, style)
  end
end

def create_beers_with_ratings_and_brewery(*scores, user, style, brewery)
  scores.each do |score|
    beer = create_beer_with_rating(score, user, style)
    brewery.beers << beer
  end
end
