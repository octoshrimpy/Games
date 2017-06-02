# Uses Rspec to test
# Expects a file in the same directory called 'bowling_scores.rb' to define a method `score_for_game` which should receive the game array and score it.
# You're free to adjust names and such, obviously. Expand the game into multiple classes/modules as you please as well.

require 'rspec'
require './bowling_scores.rb'

RSpec.describe do
  let(:empty_game) { 10.times.map {['-', '-']} }

  context "Game Scores" do
    it "should score 300 when shooting a perfect game" do
      all_strikes = 10.times.map {['X']}
      all_strikes[9] = ['X', 'X', 'X']
      expect(score_for_game(all_strikes)).to eql(300)
    end
    it "should score 0 when shooting a 0 game" do
      expect(score_for_game(empty_game)).to eql(0)
    end
    it "should score 200 when shooting a dutch 200" do
      score = [%w(9 \\), %w(X), %w(9 \\), %w(X), %w(9 \\), %w(X), %w(9 \\), %w(X), %w(9 \\), %w(X 9 \\)]
      expect(score_for_game(score)).to eql(200)
    end
    it "should score 167 for this random game I calculated" do
      score = [%w(X), %w(7 \\), %w(9 -), %w(X), %w(- 8), %w(8 \\), %w(F 6), %w(X), %w(X), %w(X 8 1)]
      expect(score_for_game(score)).to eql(167)
    end
  end

  context "For any non-10th frame" do
    context "validations" do
      it "sum of scores should never exceed 10" do
        empty_game[5] = %w(5 6)
        expect { score_for_game(empty_game) }.to raise_error(InvalidScore)
      end
      it "should not allow a spare on the first throw" do
        empty_game[5] = %w(\\ -)
        expect { score_for_game(empty_game) }.to raise_error(InvalidFrame)
      end
      it "should not allow a Strike on the second throw" do
        empty_game[5] = %w(- X)
        expect { score_for_game(empty_game) }.to raise_error(InvalidFrame)
      end
    end
    context "scoring" do
      it "should double the next open frame after a Strike" do
        empty_game[0] = ['X']
        empty_game[1] = %w(4 5)
        expect(score_for_game(empty_game)).to eql(28)
      end
      it "should double the next closed frame after a Strike" do
        empty_game[0] = ['X']
        empty_game[1] = %w(4 \\)
        expect(score_for_game(empty_game)).to eql(30)
      end
      it "should double the next 2 consecutive strikes after a Strike" do
        empty_game[0] = ['X']
        empty_game[1] = ['X']
        empty_game[2] = ['X']
        expect(score_for_game(empty_game)).to eql(60)
      end
      it "should double the next 2 throws after a Strike" do
        empty_game[0] = ['X']
        empty_game[1] = %w(4 5)
        expect(score_for_game(empty_game)).to eql(28)
      end
    end
  end

  context "For the 10th frame" do
    context "validations" do
      it "can only have up to 3 throws" do
        empty_game[9] = %w(X X X X)
        expect { score_for_game(empty_game) }.to raise_error(InvalidGame)
      end
      it "allows 3 throws only if one of the first two frames were closed" do
        empty_game[9] = %w(X - -)
        expect { score_for_game(empty_game) }.to_not raise_error
        empty_game[9] = %w(- \\ -)
        expect { score_for_game(empty_game) }.to_not raise_error
        empty_game[9] = %w(- - X)
        expect { score_for_game(empty_game) }.to raise_error(InvalidGame)
      end
      it "should raise an error for not enough throws" do
        empty_game[9] = ['X']
        expect { score_for_game(empty_game) }.to raise_error(InvalidGame)
      end
      it "should raise an error if last frame doesn't add up" do
        empty_game[9] = %w(X 7 8)
        expect { score_for_game(empty_game) }.to raise_error(InvalidScore)
      end
    end

    context "scoring" do
      it "strikes should not compound each others scores" do
        empty_game[9] = %w(X X X)
        expect(score_for_game(empty_game)).to eq(30)
      end
      it "spares should not compound each others scores" do
        empty_game[9] = %w(X 5 \\)
        expect(score_for_game(empty_game)).to eq(20)
      end
      context "should still compound with scoring from the 8th and 9th frames" do
        it "should triple the first strike if a strike was achieved in the 8th and 9th" do
          empty_game[7] = %w(X)
          empty_game[8] = %w(X)
          empty_game[9] = %w(X - -)
          expect(score_for_game(empty_game)).to eq(60)
        end
        it "should double the first 2 throws if a strike was achieved in the 9th" do
          empty_game[8] = %w(X)
          empty_game[9] = %w(X X -)
          expect(score_for_game(empty_game)).to eq(50)
        end
      end
    end
  end
end
