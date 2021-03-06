require 'spec_helper'

RSpec.describe AttrHash do  
  describe '#new' do

    it 'sets @hsh to the passed hash' do
      hsh = { p00t: 'w00t' }
      a_hash = AttrHash.new(hsh)
      expect(a_hash.hsh[:p00t]).to eq('w00t')
    end

    it 'makes all nested hashes AttrHashs' do
      hsh = { p00ts: { woots: [{ mag00ts: 'galoot' }]}}
      a_hash = AttrHash.new(hsh)
      expect(a_hash.p00ts.woots.first.mag00ts).to eq('galoot')
    end
  end

  describe '#x' do
    it 'returns the hash value for a matching key symbol' do
      hsh = { p00t: 'w00t' }
      a_hash = AttrHash.new(hsh)
      expect(a_hash.p00t).to eq('w00t')
    end

    it 'returns the hash value for a matching key string' do
      hsh = { 'p00t' => 'w00t' }
      a_hash = AttrHash.new(hsh)
      expect(a_hash.p00t).to eq('w00t')
    end
  end
end

RSpec.describe Hash do
  describe '#attr_hash' do
    it 'returns an AttrHash wrapping itself' do
      hsh = { p00ts: 'w00ts' }
      a_hash = hsh.attr_hash
      expect(a_hash).to be_a(AttrHash)
      expect(a_hash.hsh).to eq(hsh)
    end
  end
end
