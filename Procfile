web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
release: rake db:migrate
fakes3: fakes3 -r tmp/fakes3 -p 4567
ngrok: ngrok http 5000 -subdomain=screenhole-api
