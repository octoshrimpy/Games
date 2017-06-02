# Color List: http://xkcd.com/color/rgb.txt
require 'rspec'

def convert_color(color)
end

RSpec.describe do
  it { expect(convert_color('nasty green')).to eql({ hex: '#70b23f', name: 'nasty green' }) }
  it { expect(convert_color('#054907')).to eql({ hex: '#054907', name: 'darkgreen' })
  it { expect(convert_color('awesome blue')).to eql({ hex: nil, name: 'awesome blue' })
  it { expect(convert_color('light periwinkle')).to eql({ hex: '#c1c6fc', name: 'light periwinkle' })
  it { expect(convert_color('#FF0000')).to eql({ hex: '#FF0000', name: nil })
end
