require 'json'
require 'open-uri'
require 'fileutils'

namespace :backport do
  task memos: :environment do
    memos = Memo.where.not(media_path: nil)

    memos.each do |memo|
      unless memo.media_path.start_with? 'http'
        puts "=== SKIPPING memo #{memo.id}"
        next
      end

      puts "=== TRANSLOADING memo #{memo.id}"

      object_path = "#{memo.user.hashid}/voice_memo/#{Time.now.to_i}.mp3"
      TransloadRemoteFile.new(memo.media_path).upload_to_s3(object_path, 'audio/mpeg')

      puts memo.media_path, object_path

      memo.update_attribute(:media_path, object_path)
    end
  end
end
