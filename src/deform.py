# -*- coding: utf-8 -*-
import requests
import click

from utils import (
    load_config,
    handle_errors,
    get_client,
    get_session_client,
    get_session_project_client,
    save_session,
    save_settings,
    save_current_project,
    get_session_or_raise,
    echo_json,
    JSONParamType,
    options
)

__version__ = '0.0.1'

VERSION = __version__


requests.packages.urllib3.disable_warnings()


@click.group(context_settings={'help_option_names': ['-h', '--help']})
@click.pass_context
def cli(ctx):
    """Command-line client for Deform.io"""
    pass


@cli.command()
def version():
    """Outputs the client version"""
    click.echo(VERSION)


@cli.group()
@click.pass_context
def settings(ctx):
    """CLI settings"""
    pass


@settings.command()
@options.pretty()
@click.pass_context
def show(ctx, pretty):
    """Show settings"""
    echo_json(
        load_config()['settings'],
        pretty=pretty
    )


@settings.command()
@click.option('--api-host')
@click.option('--api-port', type=int)
@click.option('--api-secure', type=bool)
@click.option('--api-request-defaults', type=JSONParamType())
@click.pass_context
def change(ctx,
           api_host,
           api_port,
           api_secure,
           api_request_defaults):
    """Change settings"""
    save_settings(
        api_host=api_host,
        api_port=api_port,
        api_secure=api_secure,
        api_request_defaults=api_request_defaults,
    )


@cli.command()
@click.option('--email', '-e', prompt=True)
@click.option('--password', '-p', prompt=True, hide_input=True)
@click.pass_context
@handle_errors
def login(ctx, email, password):
    """Authenticates against the API"""
    save_session(
        email=email,
        session_id=get_client().user.login(
            email=email,
            password=password
        )
    )
    click.echo('Successfully logged in!')


@cli.command()
@click.pass_context
@handle_errors
def whoami(ctx):
    """Outputs the current user"""
    click.echo('You are %s' % get_session_or_raise()['email'])


@cli.group()
@click.pass_context
def project(ctx):
    """Project manipulation commands"""
    pass


@project.command()
@options.data()
@click.pass_context
@handle_errors
def create(ctx, data):
    """Creates a project"""
    get_session_client().project.create(data=data)
    click.echo('Project created')


@project.command()
@click.pass_context
@click.argument('project_id')
@options.pretty()
@handle_errors
def get(ctx, project_id, pretty):
    """Returns a project's data"""
    echo_json(
        get_session_client().project.get(identity=project_id),
        pretty=pretty
    )


@project.command()
@options.data()
@click.pass_context
@handle_errors
def save(ctx, data):
    """Saves a project"""
    response = get_session_client().project.save(data=data)
    if response['created']:
        click.echo('Project created')
    else:
        click.echo('Project updated')


@cli.group()
@click.pass_context
def projects(ctx):
    """User's projects"""
    pass


@projects.command()
@options.filter()
@options.text()
@options.pretty()
@click.pass_context
@handle_errors
def find(ctx, filter_, text_, pretty):
    """Find projects available for user"""
    for project in get_session_client().projects.find(
        filter=filter_,
        text=text_
    ):
        echo_json(project, pretty=pretty)


@projects.command()
@options.filter()
@options.text()
@click.pass_context
@handle_errors
def count(ctx, filter_, text_):
    """Number of projects available for user"""
    echo_json(
        get_session_client().projects.count(
            filter=filter_,
            text=text_
        )
    )


@cli.command('use-project')
@click.argument('project_id')
@click.pass_context
@handle_errors
def use_project(ctx, project_id):
    """Sets a current project"""
    has_project = False
    for project in get_session_client().projects.find():
        if project_id == project['_id']:
            has_project = True
            break
    if not has_project:
        msg = "You're not a member of the project %s" % project_id
        click.echo(msg, err=True)
        ctx.exit(1)
    save_current_project(project_id)
    click.echo('Switched to project %s' % project_id)


@cli.group()
@click.pass_context
def collection(ctx):
    """Collection manipulation commands"""
    pass


@collection.command()
@click.argument('collection_id', required=True)
@options.pretty()
@options.property()
@click.pass_context
@handle_errors
def get(ctx, collection_id, pretty, property_):
    """Returns a collection"""
    echo_json(
        get_session_project_client().collection.get(
            identity=collection_id,
            property=property_
        ),
        pretty=pretty
    )


@collection.command()
@options.data()
@click.pass_context
@handle_errors
def create(ctx, data):
    """Creates a collection"""
    get_session_project_client().collection.create(data=data)
    click.echo('Collection created')


@collection.command()
@click.argument('collection_id', required=False)
@options.data()
@options.property()
@click.pass_context
@handle_errors
def save(ctx, collection_id, data, property_):
    """Saves a collection"""
    response = get_session_project_client().collection.save(
        identity=collection_id,
        data=data,
        property=property_
    )
    if property_:
        click.echo('Property saved')
    elif response['created']:
        click.echo('Collection created')
    else:
        click.echo('Collection updated')


@collection.command()
@click.argument('collection_id')
@options.data()
@options.property()
@click.pass_context
@handle_errors
def update(ctx, collection_id, data, property_):
    """Updates a collection"""
    response = get_session_project_client().collection.update(
        identity=collection_id,
        data=data,
        property=property_
    )
    if property_:
        click.echo('Property updated')
    else:
        click.echo('Collection updated')


@collection.command()
@click.argument('collection_id')
@options.property()
@click.pass_context
@handle_errors
def remove(ctx, collection_id, property_):
    """Removes a collection"""
    get_session_project_client().collection.remove(
        identity=collection_id,
        property=property_
    )
    if property_:
        click.echo('Property removed')
    else:
        click.echo('Collection removed')


@cli.group()
@click.pass_context
def collections(ctx):
    """Collections manipulation commands"""
    pass


@collections.command()
@options.filter()
@options.text()
@options.pretty()
@click.pass_context
@handle_errors
def find(ctx, filter_, text_, pretty):
    """Find collections"""
    for collection in get_session_project_client().collections.find(
        filter=filter_,
        text=text_
    ):
        echo_json(collection, pretty=pretty)


@collections.command()
@options.filter()
@options.text()
@click.pass_context
@handle_errors
def count(ctx, filter_, text_):
    """Number of collections"""
    click.echo(
        get_session_project_client().collections.count(
            filter=filter_,
            text=text_
        )
    )


@cli.group()
@click.pass_context
def document(ctx):
    """Document manipulation commands"""
    pass


@document.command()
@click.pass_context
@options.data()
@options.collection()
@options.pretty()
@handle_errors
def create(ctx, data, collection_id, pretty):
    """Creates a document"""
    echo_json(
        get_session_project_client().document.create(
            data=data,
            collection=collection_id,
        ),
        pretty=pretty
    )


@document.command()
@click.pass_context
@click.argument('document_id', required=True)
@options.collection()
@options.property()
@options.pretty()
@handle_errors
def get(ctx, document_id, collection_id, property_, pretty):
    """Returns a document"""
    echo_json(
        get_session_project_client().document.get(
            identity=document_id,
            collection=collection_id,
            property=property_
        ),
        pretty=pretty
    )


@document.command('get-file')
@click.argument('document_id')
@options.collection()
@options.property()
@click.pass_context
@handle_errors
def get_file(ctx, document_id, collection_id, property_):
    """Returns a file content"""
    with click.open_file('-', 'w') as stdout:
        for file_part in get_session_project_client().document.get_file(
            identity=document_id,
            collection=collection_id,
            property=property_
        ):
            stdout.write(file_part)


@document.command()
@click.argument('document_id')
@options.collection()
@click.pass_context
@handle_errors
def remove(ctx, document_id, collection_id):
    """Removes a document"""
    get_session_project_client().document.remove(
        identity=document_id,
        collection=collection_id
    )
    click.echo('Document removed')


@document.command()
@click.argument('document_id', required=False)
@options.collection()
@options.data()
@options.property()
@options.pretty()
@click.pass_context
@handle_errors
def save(ctx, document_id, collection_id, data, property_, pretty):
    """Saves a document"""
    echo_json(
        get_session_project_client().document.save(
            data=data,
            collection=collection_id,
            identity=document_id,
            property=property_
        ),
        pretty=pretty
    )


@document.command()
@click.argument('document_id')
@options.collection()
@options.data(required=True, default=None)
@options.property()
@options.pretty()
@click.pass_context
@handle_errors
def update(ctx, document_id, collection_id, data, property_, pretty):
    """Updates a document"""
    echo_json(
        get_session_project_client().document.update(
            data=data,
            collection=collection_id,
            identity=document_id,
            property=property_
        ),
        pretty=pretty
    )


@cli.group()
@click.pass_context
def documents(ctx):
    """Documents manipulation commands"""
    pass


@documents.command()
@options.collection()
@options.filter()
@options.text()
@click.pass_context
@handle_errors
def count(ctx, collection_id, filter_, text_):
    """Number of documents"""
    click.echo(
        get_session_project_client().documents.count(
            collection=collection_id,
            filter=filter_,
            text=text_
        )
    )


@documents.command()
@options.collection()
@options.filter()
@options.sort()
@options.text()
@options.fields()
@options.fields_exclude()
@options.pretty()
@click.pass_context
@handle_errors
def find(ctx,
         collection_id,
         filter_,
         text_,
         fields,
         fields_exclude,
         pretty,
         sort):
    """Find documents"""
    for document in get_session_project_client().documents.find(
        collection=collection_id,
        filter=filter_,
        text=text_,
        fields=fields,
        fields_exclude=fields_exclude,
        sort=sort
    ):
        echo_json(document, pretty=pretty)


@documents.command()
@options.collection()
@options.filter()
@options.operation()
@click.pass_context
@handle_errors
def update(ctx, collection_id, filter_, operation):
    """Update documents"""
    click.echo(
        'Updated documents: %s' % get_session_project_client().documents.update(
            collection=collection_id,
            operation=operation,
            filter=filter_
        )['updated']
    )


@documents.command()
@options.collection()
@options.filter()
@options.operation()
@click.pass_context
@handle_errors
def upsert(ctx, collection_id, filter_, operation):
    """Update or insert document"""
    response = get_session_project_client().documents.upsert(
        collection=collection_id,
        filter=filter_,
        operation=operation
    )
    if response.get('upsertedId'):
        click.echo(
            'Created document with identity %s' % response.get('upsertedId')
        )
    else:
        click.echo(
            'Updated documents: %s' % response.get('updated')
        )


@documents.command()
@options.collection()
@options.filter()
@click.pass_context
@click.confirmation_option(prompt='Are you sure you want to remove documents?')
@handle_errors
def remove(ctx, collection_id, filter_):
    """Removes documents"""
    click.echo(
        'Removed documents: %s' % get_session_project_client().documents.remove(
            collection=collection_id,
            filter=filter_
        )['deleted']
    )


if __name__ == '__main__':
    cli()
