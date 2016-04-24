# -*- coding: utf-8 -*-
import requests
import click

from utils import (
    load_config,
    handle_errors,
    get_client,
    get_session_client,
    save_session,
    echo_json,
    JSONParamType
)

__version__ = '0.0.1'

VERSION = __version__


requests.packages.urllib3.disable_warnings()


@click.group(context_settings={'help_option_names': ['-h', '--help']})
@click.pass_context
def cli(ctx):
    """Command line client for Deform.io"""
    ctx.obj = load_config()


@cli.command()
@click.option('--email', '-e', prompt=True)
@click.option('--password', '-p', prompt=True, hide_input=True)
@click.pass_obj
@handle_errors
def login(config, email, password):
    """Authenticates against the API"""
    save_session(
        config=config,
        email=email,
        auth_session_id=get_client(config).user.login(
            email=email,
            password=password
        )
    )


# @cli.command()
# @click.pass_obj
# def sessions(config):
#     echo_json(config['sessions'])


# @cli.command()
# @click.pass_obj
# @click.option('--filter', '-f', 'filter_', type=JSONParamType(), default='{}')
# @handle_errors
# def projects(config, filter_):
#     for project in get_session_client(config).projects.find(filter=filter_):
#         echo_json(project)
#
#
# @cli.command()
# @click.option('--identity', '-i', prompt=True)
# @click.pass_obj
# @handle_errors
# def project(config, identity):
#     echo_json(
#         get_session_client(config).project.get(identity=identity)
#     )
#
#
# @cli.command('active-project')
# @click.pass_obj
# @handle_errors
# def active_project(config):
#     echo_json(
#         get_session_client(config).use_project(
#             config['sessions'][config['active_session']]['active_project_id']
#         ).info.get()
#     )
#
#
# @cli.command()
# @click.pass_obj
# @handle_errors
# def collections(config):
#     for collection in get_session_client(config).use_project(
#         config['sessions'][config['active_session']]['active_project_id']
#     ).collections.find():
#         echo_json(collection)
#
#
# @cli.command()
# @click.option('--collection', '-c', prompt=True)
# @click.option('--filter', '-f', 'filter_', type=JSONParamType(), default='{}')
# @click.pass_obj
# @handle_errors
# def documents(config, collection, filter_):
#     for document in get_session_client(config).use_project(
#         config['sessions'][config['active_session']]['active_project_id']
#     ).documents.find(collection=collection, filter=filter_):
#         echo_json(document)


if __name__ == '__main__':
    cli()
