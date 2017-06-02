require 'wombat'

a = Wombat.crawl do
  base_url "http://www.insiderpages.com"
  path "/b/3722737870/r-c-automotive-salt-lake-city-1"

  headline "css=.business_card_name"
  address "css=.address" do |e|
    e.split.join(" ")
  end
  telephone "css=.telephone"
  website "css=li.website span a"
  reviews "css=.reviewCtn.CitySearch", :iterator do |review|
    description "css=.description"
    reviewer_name "css=.reviewer" do |reviewer_mess|
      # This returns a bunch of messy crap, and the username isn't nested under an element, so this is a hack to retrieve the username
      reviewer_mess.split[0]
    end
    review_date "css=.reviewer .dtreviewed"
  end
end

puts a


{
  "headline" =>" R C Automotive",
  "address" =>" 4022 S State St Salt Lake City, UT 84107 Map & Directions", #You'll want to format this!
  "telephone" =>" 801-268-9911",
  "website" => "Theoretically returns the website, but can be sketchy. See if you can make this better! :D",
  "reviews" => [
    {
      "description" => "This persons review which is a bunch of text",
      "reviewer_name" => "someusername",
      "review_date" => "May 21, 2015"
    },
    {
      "description" => "This persons review which is a bunch of text",
      "reviewer_name" => "someusername",
      "review_date" => "May 21, 2015"
    }
  ]
}
