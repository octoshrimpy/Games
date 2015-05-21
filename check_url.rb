require 'net/http'
uri = URI("http://parkourutah.com/talk.json")

while true
  res = Net::HTTP.get_response(uri)
  if res.body == "true"
    print "\e[32m.\e[0m"
    new_uri = URI("http://parkourutah.com/listen")
    req = Net::HTTP::Post.new(new_uri)
    req.set_form_data('secret' => 'Rocco')
    new_res = Net::HTTP.start(new_uri.hostname, new_uri.port) do |http|
      http.request(req)
    end
  end
  sleep 1
end
