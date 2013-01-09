git push heroku master
heroku config:add GIT_LAST_COMMIT=$(git rev-parse HEAD)