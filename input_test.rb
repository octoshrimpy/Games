require 'io/console'

class Input
  # Reads keypresses from the user including 2 and 3 escape character sequences.
  def self.read_char
    system "stty -echo -raw"
    STDIN.raw!
    input = STDIN.getc.chr
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
  ensure
    system "stty echo raw"
    STDIN.cooked!

    return input
  end

  def self.read_single_key
    c = read_char

    case c
    when " "
      "SPACE"
    when "\t"
      "TAB"
    when "\r"
      "RETURN"
    when "\n"
      "LINEFEED"
    when "\e"
      "ESCAPE"
    when "\e[A"
      "UP"
    when "\e[B"
      "DOWN"
    when "\e[C"
      "RIGHT"
    when "\e[D"
      "LEFT"
    # when "\e[Z"
    #   "Shift-Tab"
    when "\e[1;2A"
      "Shift-Up"
    when "\e[1;2B"
      "Shift-Down"
    when "\e[1;2C"
      "Shift-Right"
    when "\e[1;2D"
      "Shift-Left"
    when "\177"
      "BACKSPACE"
    when "\004"
      "BACKSPACE"
    when "\e[3~"
      "BACKSPACE"
    when "\u0003"
      "CONTROL-C"
    when /^.$/
      c
    else
      puts "SOMETHING ELSE: #{c.inspect}"
    end
  end
end

while true
  input = Input.read_single_key
  puts input
  break if input == "CONTROL-C"
end
