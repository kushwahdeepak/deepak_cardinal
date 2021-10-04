heroku pg:backups:capture --app ch-job-marketplace-prod
heroku pg:backups:download -a ch-job-marketplace-prod
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U example -d ch-job-marketplace-development ./latest.dump
rake sunspot:reindex
