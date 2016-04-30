# -*- coding: utf-8 -*-
import os
import json
import click
import pydeform
from pydeform.exceptions import DeformException
from requests import Session
import pygments.style
from pygments import highlight
from pygments.lexers import JsonLexer
from pygments.formatters import TerminalFormatter, Terminal256Formatter
from functools import wraps


CONFIG_DIR = os.path.join(os.path.expanduser("~"), '.deform/')
CONFIG_PATH = os.path.join(CONFIG_DIR, 'config.json')


class AuthRequired(Exception):
    pass


def get_or_create_config_file(mode='rt'):
    try:
        return open(CONFIG_PATH, mode)
    except IOError:
        # ensure config dir exists
        try:
            os.makedirs(CONFIG_DIR)
        except OSError:
            pass

        # create config file
        with open(CONFIG_PATH, 'wt') as config_file:
            config_file.write(
                json.dumps({
                    'settings': {
                        'api': {
                            'host': 'deform.io'
                        }
                    }
                })
            )
        return open(CONFIG_PATH, mode)


def load_config():
    return json.load(get_or_create_config_file())


def save_config(data):
    get_or_create_config_file('wt').write(json.dumps(data))


def handle_errors(f):
    @wraps(f)
    def wrapper(ctx, *args, **kwargs):
        try:
            return f(ctx, *args, **kwargs)
        except DeformException as e:
            error = str(e)
            if e.errors:
                error = '%s: %s' % (error, json.dumps(e.errors))
            click.echo(error, err=True)
            ctx.exit(1)
        except AuthRequired as e:
            click.echo(
                'You are not logged in. Use `deform login` for authorization.',
                err=True
            )
            ctx.exit(1)

    return wrapper


def get_client():
    config = load_config()
    return pydeform.Client(**config['settings']['api'])


def get_session_client():
    return get_client().auth(
        'session',
        get_session_or_raise()['session_id']
    )


def save_settings(api_host=None,
                  api_port=None,
                  api_secure=None,
                  api_request_defaults=None):
    config = load_config()

    if api_host is not None:
        config['settings']['api']['host'] = api_host

    if api_port is not None:
        config['settings']['api']['port'] = api_port

    if api_secure is not None:
        config['settings']['api']['secure'] = api_secure

    if api_request_defaults is not None:
        config['settings']['api']['request_defaults'] = api_request_defaults

    save_config(config)


def get_session_or_raise():
    config = load_config()
    if 'session' in config:
        return config['session']
    else:
        raise AuthRequired()


def save_session(email, session_id):
    config = load_config()
    config['session'] = {
        'email': email,
        'session_id': session_id
    }
    save_config(config)


def echo_json(data, pretty=False, color=False, nl=True):
    click.echo(
        get_json(
            data=data,
            pretty=pretty,
            color=color,
        ),
        nl=nl
    )


def get_json(data, pretty=False, color=False):
    if pretty:
        indent = 4
    else:
        indent = None

    json_data = json.dumps(
        data,
        sort_keys=True,
        indent=indent,
        separators=(',', ': ')
    )

    if color:
        json_data = highlight(
            json_data,
            JsonLexer(),
            Terminal256Formatter(style=Solarized256Style),
        )
    return json_data


class JSONParamType(click.types.StringParamType):
    name = 'json'

    def convert(self, value, param, ctx):
        value = super(JSONParamType, self).convert(
            value=value,
            param=param,
            ctx=ctx,
        )
        try:
            return json.loads(value)
        except ValueError:
            self.fail(value, param, ctx)


class Solarized256Style(pygments.style.Style):
    """
    solarized256
    ------------
    A Pygments style inspired by Solarized's 256 color mode.
    :copyright: (c) 2011 by Hank Gay, (c) 2012 by John Mastro.
    :license: BSD, see LICENSE for more details.
    """
    BASE03 = "#1c1c1c"
    BASE02 = "#262626"
    BASE01 = "#4e4e4e"
    BASE00 = "#585858"
    BASE0 = "#808080"
    BASE1 = "#8a8a8a"
    BASE2 = "#d7d7af"
    BASE3 = "#ffffd7"
    YELLOW = "#af8700"
    ORANGE = "#d75f00"
    RED = "#af0000"
    MAGENTA = "#af005f"
    VIOLET = "#5f5faf"
    BLUE = "#0087ff"
    CYAN = "#00afaf"
    GREEN = "#5f8700"

    background_color = BASE03
    styles = {
        pygments.token.Keyword: GREEN,
        pygments.token.Keyword.Constant: ORANGE,
        pygments.token.Keyword.Declaration: BLUE,
        pygments.token.Keyword.Namespace: ORANGE,
        pygments.token.Keyword.Reserved: BLUE,
        pygments.token.Keyword.Type: RED,
        pygments.token.Name.Attribute: BASE1,
        pygments.token.Name.Builtin: BLUE,
        pygments.token.Name.Builtin.Pseudo: BLUE,
        pygments.token.Name.Class: BLUE,
        pygments.token.Name.Constant: ORANGE,
        pygments.token.Name.Decorator: BLUE,
        pygments.token.Name.Entity: ORANGE,
        pygments.token.Name.Exception: YELLOW,
        pygments.token.Name.Function: BLUE,
        pygments.token.Name.Tag: BLUE,
        pygments.token.Name.Variable: BLUE,
        pygments.token.String: CYAN,
        pygments.token.String.Backtick: BASE01,
        pygments.token.String.Char: CYAN,
        pygments.token.String.Doc: CYAN,
        pygments.token.String.Escape: RED,
        pygments.token.String.Heredoc: CYAN,
        pygments.token.String.Regex: RED,
        pygments.token.Number: CYAN,
        pygments.token.Operator: BASE1,
        pygments.token.Operator.Word: GREEN,
        pygments.token.Comment: BASE01,
        pygments.token.Comment.Preproc: GREEN,
        pygments.token.Comment.Special: GREEN,
        pygments.token.Generic.Deleted: CYAN,
        pygments.token.Generic.Emph: 'italic',
        pygments.token.Generic.Error: RED,
        pygments.token.Generic.Heading: ORANGE,
        pygments.token.Generic.Inserted: GREEN,
        pygments.token.Generic.Strong: 'bold',
        pygments.token.Generic.Subheading: ORANGE,
        pygments.token.Token: BASE1,
        pygments.token.Token.Other: ORANGE,
    }
