module Blacklist
  def self.words
    @words ||= file.split("\n").map(&:strip)
  end

  def self.file
    @file ||= File.read(Rails.root.join('config', 'blacklist.txt'))
  end
end
