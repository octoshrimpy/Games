class Log

  def initialize
    $log = []
  end

  def self.last=(val)
    $log[$log.length - 1] = val
  end

  def self.add(log)
    multi_split = " **> x"
    last_log = $log.last || ""
    index = "1"
    if last_log.include?(multi_split)
      stripped_log, index = last_log.split(multi_split)
    else
      stripped_log = last_log
    end
    if "#{$time}: #{log} " == stripped_log
      Log.last = "#{stripped_log}#{multi_split}#{(index.to_i + 1).to_s}"
    else
      $log << "#{$time}: #{log} "
    end
  end

  def self.all
    $log.reverse
  end

  def self.retrieve(num)
    all.first(num)
  end

end
