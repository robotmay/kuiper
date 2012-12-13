web: bundle exec puma -p $PORT
worker: bundle exec sidekiq -q high,3 -q medium,2 -q default,1 -q low
