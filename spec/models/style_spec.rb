require 'rails_helper'

RSpec.describe Style, type: :model do
  it "is saved with a name" do
    style = Style.create name: "Lager"

    expect(style).to be_valid
    expect(Style.count).to eq(1)
  end

  it "is not saved without a name" do
    style = Style.create

    expect(style).not_to be_valid
    expect(Style.count).to eq(0)
  end
end
