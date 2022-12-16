require 'rails_helper'

describe "Beerlist page" do
  before :all do
    Capybara.register_driver :chrome_headless do |app|
      options = Selenium::WebDriver::Chrome::Options.new

      options.add_argument('--headless')
      options.add_argument('--disable-gpu')
      options.add_argument('--no-sandbox')
      options.add_argument('--disable-dev-shm-usage')

      Capybara::Selenium::Driver.new app, browser: :chrome, options: options
    end

    Capybara.javascript_driver = :chrome_headless
    WebMock.allow_net_connect!
  end

  before :each do
    @brewery1 = FactoryBot.create(:brewery, name: "Koff")
    @brewery2 = FactoryBot.create(:brewery, name: "Schlenkerla")
    @brewery3 = FactoryBot.create(:brewery, name: "Ayinger")
    @style1 = Style.create name: "Lager"
    @style2 = Style.create name: "Rauchbier"
    @style3 = Style.create name: "Weizen"
    @beer1 = FactoryBot.create(:beer, name: "Nikolai", brewery: @brewery1, style: @style1)
    @beer2 = FactoryBot.create(:beer, name: "Fastenbier", brewery: @brewery2, style: @style2)
    @beer3 = FactoryBot.create(:beer, name: "Lechte Weisse", brewery: @brewery3, style: @style3)
  end

  it "shows one known beer", js: true do
    visit beerlist_path
    find('.tablerow', match: :first)
    expect(page).to have_content "Nikolai"
  end

  it "shows beers in alphabetical order", js: true do
    visit beerlist_path
    find('.tablerow', match: :first)
    rows = find('#beertable').all('.tablerow')

    expect(rows[0]).to have_content "Fastenbier"
    expect(rows[1]).to have_content "Lechte Weisse"
    expect(rows[2]).to have_content "Nikolai"
  end

  it "optionally shows beers in alphabetical order by brewery", js: true do
    visit beerlist_path
    find('.tablerow', match: :first)
    find("span", text: "Brewery", exact_text: true).click

    rows = find('#beertable').all('.tablerow')

    expect(rows[0]).to have_content "Ayinger"
    expect(rows[1]).to have_content "Koff"
    expect(rows[2]).to have_content "Schlenkerla"
  end

  it "optionally shows beers in alphabetical order by style", js: true do
    visit beerlist_path
    find('.tablerow', match: :first)
    find("span", text: "Style", exact_text: true).click

    rows = find('#beertable').all('.tablerow')

    expect(rows[0]).to have_content "Lager"
    expect(rows[1]).to have_content "Rauchbier"
    expect(rows[2]).to have_content "Weizen"
  end
end

