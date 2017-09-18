require 'spec_helper'

RSpec.describe Mhtml do  
  it 'has a version number' do
    expect(Mhtml::VERSION).not_to be nil
  end

  describe '.is_mhtml' do
    context 'filename has no extension' do
      it 'returns false' do
        expect(Mhtml::is_mhtml('p00ts')).to be false
      end
    end

    context 'filename extension is .html' do
      it 'returns false' do
        expect(Mhtml::is_mhtml('w00ts.html')).to be false
      end
    end

    context 'filename extension is .mht' do
      it 'returns true' do
        expect(Mhtml::is_mhtml('parp.parps.mht')).to be true
      end
    end

    context 'filename extension is .mhtml' do
      it 'returns true' do
        expect(Mhtml::is_mhtml('parp.par_ps.mhtml')).to be true
      end
    end
  end
end
