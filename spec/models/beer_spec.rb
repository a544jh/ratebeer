require 'rails_helper'

describe Beer do
	it "is saved with a name and style" do
		style = Style.create(name:"Lager")
		beer = Beer.create name:"Beer", style:style
		
		expect(beer).to be_valid
		expect(Beer.count).to eq(1)
	end
	
	it "is not saved without a name" do
		style = Style.create(name:"Lager")
		beer = Beer.create style:style
		
		expect(beer).not_to be_valid
		expect(Beer.count).to eq(0)
	end
	
	it "is not saved without a style" do
		beer = Beer.create name:"Beer"
		
		expect(beer).not_to be_valid
		expect(Beer.count).to eq(0)
	end
end

