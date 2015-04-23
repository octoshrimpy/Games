class Input
  # Reads keypresses from the user including 2 and 3 escape character sequences.
  def self.read_char
    Game.input(false)

    input = STDIN.getc.chr
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
  ensure

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
    when "\177"
      "BACKSPACE"
    when "\004"
      "DELETE"
    when "\e[3~"
      "DELETE"
    when "\u0003"
      "CONTROL-C"
      Game.input(true)
      exit 0
    when /^.$/
      c
    else
      puts "SOMETHING ELSE: #{c.inspect}"
    end
  end
end
