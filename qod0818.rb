# QOD: Making change
# I'm sure there is an easier way to do this, but my specs are almost done running.



require 'rspec'

def make_change(cents)
  change = {}
  coin_values = {half_dollars: 50, quarters: 25, dimes: 10, nickels: 5, pennies: 1}
  coin_values.each do |coin, value|
    coins_found = cents / value
    cents -= coins_found * value
    change[coin] = coins_found if coins_found > 0
  end
  change
end

RSpec.describe do
  it { expect(make_change(0)).to eql({}) }
  it { expect(make_change(1)).to eql({ pennies: 1 }) }
  it { expect(make_change(43)).to eql({ quarters: 1, dimes: 1, nickels: 1, pennies: 3}) }
  it { expect(make_change(91)).to eql({ half_dollars: 1, quarters: 1, dimes: 1, nickels: 1, pennies: 1 }) }
  it { expect(make_change(277)).to eql({ half_dollars: 5, quarters: 1, pennies: 2 }) }
end
