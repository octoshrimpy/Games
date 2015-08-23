def receive_sms(from, body)
  puts "From: #{from}\nMessage: #{body}"
  if from == "+13852599640"
    if body == 'pass'
      contact_request.update(success: true)
      puts "Allowed contact request from: #{contact_request.name}."
    elsif body.downcase =~ /talk/
      puts "RoccoLogger"
    end
  end
  puts "Body: #{body}, Split: #{body.split('')}, Length: #{body.split('').length}"
  if body.split('').length < 10
    if ["Open.", "Close."].include?(body.split.join)
      puts "activate"
    else
      puts "nothing"
    end
  else
    num = from.split('').map {|x| x[/\d+/]}.join
    puts  "This is an automated text messaging system. \nIf you have questions about class, please contact the Instructor. Their contact information is available in the class details. \nIf you would like to stop receiving Notifications, please disable text notifications in your Account Settings on parkourutah.com/account"
    puts  "To: #{num}\nThis is an automated text messaging system. \nIf you have questions about class, please contact the Instructor. Their contact information is available in the class details. \nIf you would like to stop receiving Notifications, please disable text notifications in your Account Settings on parkourutah.com/account"
  end
end

receive_sms("180792442", "Stop texting me")
