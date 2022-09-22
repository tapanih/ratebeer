require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [Place.new(name: "Oljenkorsi", id: 1)]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if many are returned by the API, they are shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("Helsinki").and_return(
      [Place.new(name: "Bryggeri", id: 1), Place.new(name: "Stadin Panimo", id: 2), Place.new(name: "Bruuveri", id: 3)]
    )

    visit places_path
    fill_in('city', with: 'Helsinki')
    click_button "Search"

    expect(page).to have_content "Bryggeri"
    expect(page).to have_content "Stadin Panimo"
    expect(page).to have_content "Bruuveri"
  end

  it "if none are returned by the API, a notice is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("Espoo").and_return([])

    visit places_path
    fill_in('city', with: 'Espoo')
    click_button "Search"

    expect(page).to have_content "No locations in Espoo"
  end
end
