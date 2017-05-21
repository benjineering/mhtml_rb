module Mhtml
  class Reader

    def self.read(io)
      raise LocalJumpError, 'Block required' unless block_given?
      Reader.new.read(io) { |item| yield item }
    end
  end
end
