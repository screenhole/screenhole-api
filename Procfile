web: bundle exec puma -C config/puma.rb
release: rake db:migrate
fakes3: fakes3 -r tmp/fakes3 -p 4567
ngrok: ngrok http 5000 -subdomain=screenhole-api
