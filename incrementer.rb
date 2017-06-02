class Incrementer
  attr_accessor :count, :total

  def initialize(total, message="")
    @count = 0
    @total = total
    puts "\n#{message}"
  end

  def increment!
    @count += 1
    print "\r#{@count}/#{@total}  "
  end
end


def doit
  ActiveRecord::Base.logger.level = 1

  month_of = DateTime.current
  leaderboards = Game.published.map do |game|
    Leaderboard.from_options(game_id: game.id, start_date: month_of.beginning_of_month, end_date: month_of.end_of_month)
  end

  user_counter = Incrementer.new(User.count, "User Counter")
  User.find_each do |u|
    new_golf_score = leaderboards.map { |l| l.rank_for_user(u).try(:rank) || l.leaderboard_ranks.count }.sum
    u.golf_tracker.update(at_0: new_golf_score)
    user_counter.increment!
  end

  golf_counter = Incrementer.new(GolfTracker.count, "Golf Tracker Refresher")
  GolfTracker.find_each do |g|
    golf_counter.increment!
    g.refresh!(false)
  end
end
