require 'test_helper'

class FruitTest < ActiveSupport::TestCase

  test "saves a fruit that has seasons defined" do
    fruit = Fruit.new
    fruit.season_start_day = 1
    fruit.season_start_month = "July"
    fruit.season_end_month = "January"
    fruit.season_end_day = 1
    assert fruit.save
  end

  test "requires a season start month" do
    fruit = Fruit.new
    fruit.season_start_day = 1
    fruit.season_end_month = "January"
    fruit.season_end_day = 1
    assert !fruit.save
  end

  test "requires a season start day" do
    fruit = Fruit.new
    fruit.season_start_month = "July"
    fruit.season_end_month = "January"
    fruit.season_end_day = 1
    assert !fruit.save
  end

  test "requires a season end month" do
    fruit = Fruit.new
    fruit.season_start_day = 1
    fruit.season_start_month = "January"
    fruit.season_end_day = 1
    assert !fruit.save
  end

  test "requires a season end day" do
    fruit = Fruit.new
    fruit.season_start_month = "July"
    fruit.season_end_month = "January"
    fruit.season_start_day = 1
    assert !fruit.save
  end

  test "requires that fruit start month is valid" do
    fruit = Fruit.new
    fruit.season_start_day = 1
    fruit.season_start_month = "Foobar"
    fruit.season_end_month = "January"
    fruit.season_end_day = 1
    assert !fruit.save
  end

  test "requires that fruit end month is valid" do
    fruit = Fruit.new
    fruit.season_start_day = 1
    fruit.season_end_month = "Foobar"
    fruit.season_start_month = "January"
    fruit.season_end_day = 1
    assert !fruit.save
  end

end
