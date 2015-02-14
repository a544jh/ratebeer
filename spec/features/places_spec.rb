require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name:"Oljenkorsi", id: 1 ) ]
    )
	do_search('kumpula')
    expect(page).to have_content "Oljenkorsi"
  end
  
  it "if many are returned by the API, all are shown on the page" do
	allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name:"Place1", id: 1 ),
      Place.new( name:"Place 2", id: 2 ),
      Place.new( name:"place3", id: 3 ) ]
    )
	do_search('kumpula')
    expect(page).to have_content "Place1"
    expect(page).to have_content "Place 2"
    expect(page).to have_content "place3"
  end
  
  it "if none are returned by the API, notice is shown on page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [  ]
    )
	do_search('kumpula')
    expect(page).to have_content "No locations in kumpula"
  end
end

def do_search(city)
	visit places_path
    fill_in('city', with: city)
    click_button "Search"
end
