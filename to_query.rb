require 'rack'
require 'json'

class String
  def to_query
    temp_str = self.dup
    string_replacements = []
    inner_quote_regex = /\"[^\"]*?\"/
    while temp_str.match?(inner_quote_regex)
      temp_str.gsub!(inner_quote_regex) do |match|
        token = uniqueToken(temp_str)
        # puts "\e[31m#{match} => #{token}\e[0m"
        string_replacements << [token, match]
        token
      end
    end
    # puts "\e[31m#{string_replacements}\e[0m"
    # puts "\e[31mTemp #{temp_str}\e[0m"
    replace_syms = temp_str.gsub("=>", ":").gsub(/([^\"])(\w+)(:)/) {"#{$1}\"#{$2}\":"}.gsub(/(:)(\w+)([^\"])/) {"\"#{$2}\"#{$3}"}
    # puts "\e[31m Replace #{replace_syms}\e[0m"
    string_replacements.each do |token, str|
      # puts "\e[31m#{token} => #{str}\e[0m"
      replace_syms.gsub!(token, str)
    end
    # puts "\e[31m End #{replace_syms}\e[0m"
    replace_syms
  end
end

def uniqueToken(str)
  loop do
    token = [('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a].flatten.sample(4).join("")
    break token unless str.include?(token)
  end
end

if ARGV.count != 1
  puts "Must pass a single stringified hash"
else
  puts ARGV[0].to_s.to_query
end
