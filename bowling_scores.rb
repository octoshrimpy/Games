class InvalidGame < StandardError; end
class InvalidFrame < StandardError; end
class InvalidScore < StandardError; end

def score_for_game(game_scores)
  raise InvalidGame, "Scores must be an Array. Found #{game_scores.class}" unless game_scores.is_a?(Array)
  raise InvalidGame, "Requires 10 Frames. Found: #{game_scores.count}" unless game_scores.length == 10
  game_total = 0
  carry_next = 0
  carry_second = 0
  game_scores.each_with_index do |frame_rolls, frame|
    frame = frame + 1
    raise InvalidFrame, "Scores must be an Array. Found: #{frame_rolls.class} Frame: #{frame}" unless frame_rolls.is_a?(Array)
    raise InvalidGame, "Frame can only contain 2 rolls! (Or 3 on the 10th) Found: #{frame_rolls.count} on frame: #{frame}" if frame_rolls.count > (frame == 10 ? 3 : 2)
    roll_scores = frame_rolls.map.with_index do |roll, roll_idx|
      case roll
      when '-' then 0
      when 'F' then 0
      when 'X'
        raise InvalidFrame, "Cannot get a Strike and another score in the same frame. Frame: #{frame}" if frame_rolls.count > 1 && frame != 10
        10
      when '\\'
        raise InvalidFrame, "Cannot get a Spare on the first roll. Frame: #{frame}" unless roll_idx > 0 || frame_rolls[roll_idx - 1] == 10
        10 - frame_rolls[roll_idx - 1].to_i
      else roll.to_i
      end
    end
    raise InvalidScore, "Score is too high! Cannot exceed 10 on any individual throw. Got #{roll_scores.max} on frame #{frame}." if roll_scores.any? { |roll| roll > 10}
    raw_score_for_frame = roll_scores.inject(:+)
    raise InvalidScore, "Score is too high! Cannot exceed 10 on non-10th frames. Got #{raw_score_for_frame} on frame #{frame}." if raw_score_for_frame > 10 && frame != 10
    if frame == 10
      if roll_scores[0] == 10
        if roll_scores[1].nil? || roll_scores[2].nil?
          raise InvalidGame, "Closed in the first throw of the tenth, but didn't finish last 2 throws."
        elsif roll_scores[1] != 10 && roll_scores[1] + roll_scores[2] > 10
          raise InvalidScore, "Score for frame is too high! Cannot exceed 10. Got #{roll_scores[0] + roll_scores[1]} in last 2 throws of frame 10."
        end
      else
        if roll_scores[0] + roll_scores[1] > 10
          raise InvalidScore, "Score for frame is too high! Cannot exceed 10. Got #{roll_scores[0] + roll_scores[1]} in first 2 throws of frame 10."
        elsif roll_scores[0] + roll_scores[1] == 10 && roll_scores[2].nil?
          raise InvalidGame, "Closed in the first half of tenth, but didn't finish last throw."
        elsif roll_scores[0] + roll_scores[1] < 10 && roll_scores.count == 3
          raise InvalidGame, "Rolled 3 scores in the 10th, but didn't close the first half of the frame."
        end
      end
    end
    roll_scores.each_with_index do |roll, roll_idx|
      new_score = roll
      tenth_frame = frame == 10
      strike_frame = roll == 10 && roll_idx == 0
      closed_frame = roll_scores[0].to_i + roll_scores[1].to_i == 10 && (strike_frame || roll_idx == 1)

      until carry_next == 0
        new_score += roll
        carry_next -= 1
      end
      carry_next += carry_second
      carry_second = 0
      unless tenth_frame
        carry_next += 1 if closed_frame
        carry_second += 1 if strike_frame
      end
      game_total += new_score
    end
  end
  game_total
end
