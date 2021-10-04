
heroku pg:copy ch-job-marketplace-prod::DATABASE_URL DATABASE_URL --app ch-job-marketplace-stage  --confirm ch-job-marketplace-stage
heroku pg:backups:capture --app ch-job-marketplace-prod
heroku pg:backups:download -a ch-job-marketplace-prod ./tmp/prod.dump
herokur run "bin/rails db:migrate; rake sunspot:solr:reindex" -a ch-job-marketplace-stage
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U example -d ch-job-marketplace-development ./tmp/prod.dump
bin/rails db:environment:set RAILS_ENV=development
bin/rails db:migrate
rake sunspot:solr:reindex

