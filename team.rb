class Team
  attr_accessor :name, :plays

  def initialize(name)
    @name = name
    @plays = []
  end

  def play!(details)
    details.select { |k,v| [:opposing_team_name, :victory, :field, :day, :time].include?(k.to_sym) }
    @plays << details
  end
end

@fields = 6
@days = 3
@time_slots_per_day = 24

def assign_teams_to_fields(teams)
  eligible_teams = teams
  completed_teams = []

  @days.times do |day_idx|
    day = day_idx + 1
    puts "----- Day #{day} -----"
    @time_slots_per_day.times do |time_slot|
      time_of_day = 9 + (time_slot / 2.00)
      meridiam = time_of_day >= 12 ? "PM" : "AM"
      hour_of_day = time_of_day.floor - (time_of_day >= 13 ? 12 : 0)
      minute_of_day = (time_of_day % 1) == 0.5 ? '30' : '00'

      puts "-- Time: #{hour_of_day}:#{minute_of_day} #{meridiam} --"
      fields_names = @fields.times.map do |field_idx|
        "Field: #{(field_idx + 1).to_s.rjust(2, "0")}"
      end.join(" - ")
      teams_played_last_time_slot = []
      teams = eligible_teams.sample(2)


      teams_matches = @fields.times.map do |field_idx|
        "#{'XXX'.rjust(3, "0")} * #{'YYY'.rjust(3, "0")}"
      end.join(" | ")
      puts fields_names, teams_matches, ""
    end
    puts "\n\n"
  end
end


assign_teams_to_fields((1..100).to_a.map(&:to_s))
# t.play!(opposing_team_name: "Nope", victory: true, field: 5, day: 1, time: 9.5)
