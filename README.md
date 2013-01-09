# Asset caching is fun!
This repo is relative to a question [@tensafefrogs](http://twitter.com/tensafefrogs) asked on Stackoverflow.com: [http://stackoverflow.com/questions/14229418/how-do-i-reset-the-django-cache-for-static-file-names](http://stackoverflow.com/questions/14229418/how-do-i-reset-the-django-cache-for-static-file-names):

### My answer...

In this case I'd say that `heroku config:add ...` is your friend.

For example: you can create a bash script that pushes your latest app for you and, on doing so, fires, say: `heroku config:add GIT_LAST_COMMIT=$(git rev-parse HEAD)`.

Then in your Python code you can reference that variable by using `os.environ['GIT_LAST_COMMIT']`.

For example here's my Heroku app: http://stormy-badlands-7331.herokuapp.com/

The code for `app.py` is:

    import os
    from flask import Flask

    app = Flask(__name__)

    @app.route('/')
    def hello():
      return 'Hello World! The latest commit sha is %s' % os.environ['GIT_LAST_COMMIT']

    if __name__ == '__main__':
      # Bind to PORT if defined, otherwise default to 5000.
      port = int(os.environ.get('PORT', 5000))
      app.run(host='0.0.0.0', port=port)

And my `deploy.sh` is:

    git push heroku master
    heroku config:add GIT_LAST_COMMIT=$(git rev-parse HEAD)

Note that I update the variable after I push, this way I ensure that users don't get served the old assets under a new hash.

You can then take this `os.environ['GIT_LAST_COMMIT']` and use it as the `x` var, for example, when loading your assets, eg:

    <link rel="stylesheet" type="text/css" href="/assets/css/styles.css?{{ git_last_commit}}" />