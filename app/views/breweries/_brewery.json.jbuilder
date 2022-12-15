json.extract! brewery, :id, :name, :year
json.beerCount brewery.beers.count
json.active brewery.active
