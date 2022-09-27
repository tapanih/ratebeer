require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "is saved with name, style and brewery" do
    brewery = Brewery.create name: "Test brewery", year: 2022
    beer = Beer.create name: "Test beer", old_style: "Porter", brewery: brewery

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not created without a name" do
    brewery = Brewery.create name: "Test brewery", year: 2022
    beer = Beer.create old_style: "Porter", brewery: brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not created without a style" do
    brewery = Brewery.create name: "Test brewery", year: 2022
    beer = Beer.create name: "Test beer", brewery: brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
