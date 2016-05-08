Command-line interface for [Deform.io](https://deform.io)

Installation:

    $ pip install cli-deform

Usage:

    $ deform  # shows help
    $ deform login --email <email> --password <password>
    $ deform whoami
    $ deform projects
    $ deform project
    $ deform project info mysquare
    $ deform project use mysquare
    $ deform collections
    $ deform documents -c venues
    $ deform document -i subway -c venues
    $ deform document remove -i subway -c venues
    $ deform document edit -i subway -c venues  # opens document in http://click.pocoo.org/5/api/#click.edit. On save saves to server
    $ deform documents -c venues -f '{"name":"subway"}'
    $ deform documents -c venues -t 'subway'

## Tests

Install tox:

    $ pip install tox

For running tests you need to provide all required ENV variables. For example
next command will fail:

    $ tox
    ValueError: You should provide "DEFORM_HOST" environ for settings

You can send variables with command:

    $ DEFORM_HOST='"deform.io"' tox

The more convenient way would be to create a `.test_config` file a save data there.
This file is ignored by git and won't be commeted.

    $ cat .test_config
    DEFORM_HOST='"deform.io"'
    DEFORM_EMAIL='"email@example.ru"'
    DEFORM_PASSWORD='"hello"'
    ...

You can run tests with config from file like this:

    $ eval $(cat .test_config) tox

All config values must be specified with JSON types.

Running BDD tests:

    $ eval $(cat .test_config) tox -e py27-bdd

Running BDD tests for specific feature:

    $ eval $(cat .test_config) tox -e py27-bdd -- -i projects/find.feature

Running unit tests:

    $ eval $(cat .test_config) tox -e py27-unit

### Codestyle

Checking for pep:

    $ tox -e flake8

Checking for imports:

    $ tox -e isort

If you have any problems with imports just run automatic manual fix:

    $ tox -e isort-fix

### Documentation

Documentation is generated by [http://www.mkdocs.org/](http://www.mkdocs.org/)

    $ pip install -r requirements/docs.txt
    $ invoke build-docs

For development:

    $ invoke serve-docs


## Publishing new releases

Increment version in `pydeform/__init__.py`. For example:

    __version__ = '0.0.2'  # from 0.0.1

Run tests.

Commit changes with message "Version 0.0.2"

Publish to pypi:

    $ python setup.py publish

Add new tag version for commit:

    $ git tag 0.0.2

Push to master with tags:

    $ git push origin master --tags
