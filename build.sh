cd src
if [ "${1}" == "run" ]; then
  ruby app.rb
else
  gem install bundler
  bundle install
  bundle exec rake db:drop
  bundle exec rake db:create
  bundle exec rake db:migrate
fi

