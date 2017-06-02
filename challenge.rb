class Challenge

  attr_reader :data

  data =
      [
        {"school_slug"=>"foo", "lead_buyer_id"=>"1234"},
        {"school_slug"=>"bar", "lead_buyer_id"=>"567"}
      ]
  def initialize(data)
    @data = data
  end

  # Should return an array of school slugs from data
  def school_slugs
    data.map {|school| school["school_slug"] }
  end

  # Should return true if school_slug is included in data
  # Hint: you can use the method `school_slugs` above
  def applicable_school?(school_slug)
    data.map {|school| school["school_slug"]}
    school.any
  end

  # Should return the lead_buyer_id associated with school_slug
  def lead_buyer_id_for_school(school_slug)
    # TODO
  end

end

require 'minitest/autorun'

class TestData < Minitest::Test

  def setup
    test_data = [
      {"school_slug"=>"foo", "lead_buyer_id"=>"1234"},
      {"school_slug"=>"bar", "lead_buyer_id"=>"567"}
    ]
    @challenge = Challenge.new(test_data)
  end

  def test_school_slugs
    assert_equal ["foo", "bar"], @challenge.school_slugs
  end

  def test_applicable_school
    assert_equal false, @challenge.applicable_school?('jedi-school')
    assert_equal true, @challenge.applicable_school?('foo')
  end

  def test_lead_buyer_id_for_school
    assert_equal '1234', @challenge.lead_buyer_id_for_school('foo')
    assert_equal '567', @challenge.lead_buyer_id_for_school('bar')
  end

end
