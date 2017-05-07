require 'spec_helper'

RSpec.describe String do  
  describe '#each_index' do

    it 'yields each index of the substring' do
      count = 0

      'p000ts w00ts mcG00t'.each_index('00ts') do |index| 
        count += 1

        case count
        when 1
          expect(index).to eq(2)
        when 2
          expect(index).to eq(8)
        end
      end

      expect(count).to eq(2)
    end


    it 'yields each index of the matched regex' do
      count = 0

      "p000ts w00ts mcG00t".each_index(/ [^w]/) do |index|
        count += 1
        expect(index).to eq(12) if count == 1
      end

      expect(count).to eq(1)
    end
  end

  describe '#strip_other' do
    it 'strips the str from the start and end and returns a copy of itself' do
      expect('p00ts'.strip_other('s')).to eq('p00t')
      expect('p00ts'.strip_other('p')).to eq('00ts')
      expect('=p00ts='.strip_other('=')).to eq('p00ts')
    end
  end
end
