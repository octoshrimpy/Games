class MapSolver
  attr_accessor :map, :error_message

  def self.solve(map_to_solve, options={})
    new.solve(map_to_solve, options)
  end

  def solve(map_to_solve, options={})
    @start = options[:start] || 'o'
    @finish = options[:finish] || 'x'
    @wall = options[:wall] || '#'
    @space = options[:space] || ' '
    @up = options[:up] || 'N'
    @down = options[:down] || 'S'
    @left = options[:left] || 'W'
    @right = options[:right] || 'E'

    if map_to_solve.nil?
      @error_message = 'No map to solve.'
      return self
    end

    if map_to_solve.is_a?(String)
      if map_to_solve.include?("\\n")
        @map = map_to_solve.split("\\n").scan(/.{1,2}/).map(&:first)
      else
        return error!('Map must have \\n as row delimiter.')
      end
    else
      return error!("Map must be in String format!")
    end

    return self unless map_is_valid?
  end

  def map_is_valid?
    # @error_message
  end

  def error!(msg)
    @error_message = msg
    return self
  end

end
