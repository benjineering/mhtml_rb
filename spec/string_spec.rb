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

  describe '#underscore' do
    it 'converts camel case to snake' do
      expect('Document'.underscore).to eq('document')
      expect('HttpHeader'.underscore).to eq('http_header')
    end
  end

  describe '#index_of_split' do
    context 'begins with part of other' do
      it 'returns the index of the first character following other' do
        expect('ploprsky'.index_of_split('diplo')).to eq(2)
      end
    end

    context "doesn't begin with any part of other" do
      it 'returns nil' do
        expect('hambone'.index_of_split('jim')).to be(nil)
      end
    end
  end

  describe '#rindex_of_split' do
    context 'ends with part of other' do
      it 'returns the index of the first character of other' do
        expect('ploprsky'.rindex_of_split('skynet')).to eq(5)
      end
    end

    context "doesn't end with any part of other" do
      it 'returns nil' do
        expect('hambone'.rindex_of_split('jim')).to be(nil)
      end
    end
  end
end