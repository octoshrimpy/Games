require 'unirest'

response = Unirest.post("https://calldrip.colynk.com/api/api.php",
                        parameters: {
  fname: 'test',
  lname: 'test',
  email: 'britton@orcahealth.com',
  phone: '801-361-3186',
  user: 'orcahealth',
  apipass: '1gkjsoVy',
  apikey: '3f89432775fc2487b645948562b8066e605669cab962b',
  widgetid: 6985
})

puts response.body
