require 'rails_helper'

include Helpers

describe "Beer" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }

  it "can be created with a valid name" do
    visit new_beer_path
    fill_in('beer[name]', with: 'Karhu')

    expect {
      click_button('Create Beer')
    }.to change { Beer.count }.by(1)
  end

  it "cannot be created without a name" do
    visit new_beer_path
    fill_in('beer[name]', with: '')

    expect {
      click_button('Create Beer')
    }.to change { Beer.count }.by(0)

    expect(page).to have_content "Name can't be blank"
  end
end
