cd src
gem install bundler
bundle install
bundle exec rake db:create
bundle exec rake db:migrate

