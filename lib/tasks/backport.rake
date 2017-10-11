require 'json'
require 'open-uri'
require 'fileutils'

namespace :backport do
  task shots: :environment do
    FileUtils::mkdir_p 'tmp/backport'

    data = {}

    open('https://dataclips.heroku.com/ohvlypkrbjfqsaxxchdyxnpilkob-live-holes.json') do |f|
      data = JSON.parse f.read
    end

    data['values'].each do |row|
      user = User.find_by(username: row[1])

      unless user.present?
        user = User.create(username: row[1], password: "football", password_confirmation: "football")
        puts "Created #{user.username} with password football."
      end

      IO.copy_stream(open("http://screenhole.s3.amazonaws.com/#{row[2]}"), "tmp/backport/#{row[0]}.png")

      new_filename = "#{Shot.hashid.encode(user.id)}/#{Time.parse(row[3]).to_i}.png"

      obj = AWS_S3_BUCKET.object(new_filename)
      obj.upload_file("tmp/backport/#{row[0]}.png", acl: 'public-read')

      shot = user.shots.new
      shot.image_path = obj.key
      shot.created_at = row[3]
      shot.updated_at = row[4]

      shot.save
    end
  end
end
