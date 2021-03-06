import json
import hashlib

from behave import when, then
from hamcrest import assert_that, has_entry, has_entries, is_not
from cli_bdd.behave.steps import *
from pydeform.exceptions import NotFoundError

from src.deform import VERSION
from src.utils import load_config
from tests.testutils import (
    CONFIG,
    deform_session_client,
    deform_session_project_client,
)


@when('rpdb')
def step_impl(context):
    import rpdb; rpdb.set_trace()


@then('the output should contain current cli-deform version')
def step_impl(context):
    context.execute_steps(
        u'''
            Then the output should contain exactly:
                """
                {version}

                """
        '''.format(version=VERSION)
    )


@when(
    'I run login command with valid credentials providing '
    '(?P<email_arg_name>[-\w]+) and (?P<password_arg_name>[-\w]+) arguments'
)
def step_impl(context, email_arg_name, password_arg_name):
    context.execute_steps(
        u'When I successfully run '
        '`deform login '
        '{email_arg_name} {email} '
        '{password_arg_name} {password}`'.format(
            email_arg_name=email_arg_name,
            email=CONFIG['DEFORM']['EMAIL'],
            password_arg_name=password_arg_name,
            password=CONFIG['DEFORM']['PASSWORD'],
        )
    )


@when('I type valid email credential')
def step_impl(context):
    context.execute_steps(
        u'When I type "%s"' % CONFIG['DEFORM']['EMAIL']
    )


@when('I type valid password credential')
def step_impl(context):
    context.execute_steps(
        u'When I type "%s"' % CONFIG['DEFORM']['PASSWORD']
    )


@given('I am logged in')
def step_impl(context):
    context.execute_steps(
        u'''
            When I run login command with valid credentials providing -e and -p arguments
            Then the output should contain exactly:
                """
                Successfully logged in!

                """
            Then the exit status should be 0
        '''
    )


@then('the output should contain logged in user information')
def step_impl(context):
    context.execute_steps(
        u'''
            Then the output should contain exactly:
                """
                You are {email}

                """
        '''.format(email=CONFIG['DEFORM']['EMAIL'])
    )


@then("the output should contain info about current user's project")
def step_impl(context):
    context.execute_steps(
        u'''
            Then the output should contain exactly:
                """
                Current project is {project_id}

                """
        '''.format(project_id=CONFIG['DEFORM']['PROJECT'])
    )


@then('I should be successfully logged in')
def step_impl(context):
    context.execute_steps(
        u'''
            Then the output should contain:
                """
                Successfully logged in!
                """
        '''
    )
    assert_that(
        load_config(),
        has_entry(
            'session', has_entries({
                'email': CONFIG['DEFORM']['EMAIL'],
                'session_id': is_not(None)
            })
        )
    )


@then(
    'the output should contain available for '
    'user projects\s?(?P<pretty>with pretty print)?'
)
def step_impl(context, pretty):
    for project in deform_session_client.projects.find():
        expected = '"_id": "%s"' % project['_id']
        if pretty:
            expected = '    ' + expected
        context.execute_steps(
            u'''
                Then the output should contain:
                    """
                    %s
                    """
            ''' % expected
        )


@then('the output should contain number of available for user projects')
def step_impl(context):
    context.execute_steps(
        u'''
            Then the output should contain exactly:
                """
                %s

                """
        ''' % deform_session_client.projects.count()
    )


@then('I should be asked to login first')
def step_impl(context):
    context.execute_steps(
        u'''
            Then the output should contain:
                """
                You are not logged in. Use `deform login` for authorization.
                """
            And the exit status should be 1
        '''
    )


@when('I filter projects with (?P<filter_argument>[-\w]+) argument by name')
def step_impl(context, filter_argument):
    context.execute_steps(
        u'When I successfully run '
        '`deform projects find %s \'{"name":"%s"}\'`' % (
            filter_argument,
            CONFIG['DEFORM']['PROJECT_NAME']
        )
    )


@when(
    'I filter projects count '
    'with (?P<filter_argument>[-\w]+) argument by name'
)
def step_impl(context, filter_argument):
    context.execute_steps(
        u'When I successfully run '
        '`deform projects count %s \'{"name":"%s"}\'`' % (
            filter_argument,
            CONFIG['DEFORM']['PROJECT_NAME']
        )
    )


@when('I filter projects with (?P<filter_argument>[-\w]+) argument by text')
def step_impl(context, filter_argument):
    context.execute_steps(
        u'When I successfully run '
        '`deform projects find %s "%s"`' % (
            filter_argument,
            CONFIG['DEFORM']['PROJECT_NAME']
        )
    )


@when(
    'I filter projects count with '
    '(?P<filter_argument>[-\w]+) argument by text'
)
def step_impl(context, filter_argument):
    context.execute_steps(
        u'When I successfully run '
        '`deform projects count %s "%s"`' % (
            filter_argument,
            CONFIG['DEFORM']['PROJECT_NAME']
        )
    )


@then('the output should contain filtered by name projects')
def step_impl(context):
    for project in deform_session_client.projects.find(
        filter={'name': CONFIG['DEFORM']['PROJECT_NAME']}
    ):
        context.execute_steps(
            u'''
                Then the output should contain:
                    """
                    "_id": "%(project_id)s"
                    """
            ''' % dict(
                project_id=project['_id']
            )
        )


@then('the output should contain filtered by full text projects')
def step_impl(context):
    for project in deform_session_client.projects.find(
        text=CONFIG['DEFORM']['PROJECT_NAME']
    ):
        context.execute_steps(
            u'''
                Then the output should contain:
                    """
                    "_id": "%(project_id)s"
                    """
            ''' % dict(
                project_id=project['_id']
            )
        )


@given("I use current user's project")
def step_impl(context):
    context.execute_steps(
        u'When I successfully run '
        '`deform use-project %s`' % (
            CONFIG['DEFORM']['PROJECT']
        )
    )


@then("the output should contain successfull switch to project info")
def step_impl(context):
    context.execute_steps(
        u'''
            Then the output should contain exactly:
                """
                Switched to project %s

                """
        ''' % CONFIG['DEFORM']['PROJECT']
    )


@then("the current project in settings should be current user's project")
def step_impl(context):
    assert_that(
        load_config(),
        has_entry(
            'current_project',
            CONFIG['DEFORM']['PROJECT']
        )
    )


@then("I should be asked to set current project")
def step_impl(context):
    context.execute_steps(
        u'''
            Then the output should contain:
                """
                You didn't specify current project. Use `deform use-project`.
                """
            And the exit status should be 1
        '''
    )


@given("I use a current user's project")
def step_impl(context):
    context.execute_steps(
        u'''
            When I successfully run `deform use-project %s`
        ''' % CONFIG['DEFORM']['PROJECT']
    )


@given("I use deform mock server")
def step_impl(context):
    context.execute_steps(
        (
            u'When I successfully run '
             '`deform settings change '
             '--api-host %(host)s '
             '--api-port %(port)s '
             '--api-secure false`'
        ) % {
            'host': CONFIG['MOCK_SERVER']['HOST'],
            'port': CONFIG['MOCK_SERVER']['PORT'],
        } + (
            u'\n'
             'Then the exit status should be 0'
        )
    )

@when("I am getting user's project info\s?(?P<pretty>with pretty print)?")
def step_impl(context, pretty):
    command = u'When I run `deform project get %s%s`' % (
        CONFIG['DEFORM']['PROJECT'],
        ' --pretty' if pretty else ''
    )
    context.execute_steps(command )


@when("I try to signup with current user's email")
def step_impl(context):
    command = u'When I run `deform signup -e %s -p whatever`' % (
        CONFIG['DEFORM']['EMAIL'],
    )
    context.execute_steps(command)


@then("the output should contain user's project info\s?(?P<pretty>with pretty print)?")
def step_impl(context, pretty):
    expected = '"_id": "%s"' % CONFIG['DEFORM']['PROJECT']
    if pretty:
        expected = '    ' + expected
    context.execute_steps(
        u'''
            Then the output should contain:
                """
                %s
                """
        ''' % expected
    )


@given('there is no "(?P<collection_id>\w+)" collection in current user\'s project')
def step_impl(context, collection_id):
    try:
        deform_session_project_client.collection.remove(
            identity=collection_id
        )
    except NotFoundError:
        pass


@given(
    'there is an empty "(?P<collection_id>\w+)" '
    'collection in current user\'s project\s?(?P<schema>with schema)?'
)
def step_impl(context, collection_id, schema):
    context.execute_steps(
        u'''
            Given there is no "%s" collection in current user\'s project
        ''' % collection_id
    )
    if schema:
        schema = context.text
    else:
        schema = {
            'description': 'schema of collection %s' % collection_id,
            'additionalProperties': True
        }
    deform_session_project_client.collection.create(
        data={
            '_id': collection_id,
            'name': 'Collection %s' % collection_id,
            'schema': schema
        }
    )


@then("the output should contain number of collections in user's project")
def step_impl(context):
    context.execute_steps(
        u'''
            Then the output should contain exactly:
                """
                %s

                """
        ''' % deform_session_project_client.collections.count()
    )

@then(
    "the output should contain collections in user's "
    "project\s?(?P<pretty>with pretty print)?"
)
def step_impl(context, pretty):
    for collection in deform_session_project_client.collections.find():
        expected = '"_id": "%s"' % collection['_id']
        if pretty:
            expected = '    ' + expected
        context.execute_steps(
            u'''
                Then the output should contain:
                    """
                    %s
                    """
            ''' % expected
        )

@given(
    'there is a document in collection "(?P<collection_id>\w+)"'
)
def step_impl(context, collection_id):
    deform_session_project_client.document.save(
        data=json.loads(context.text),
        collection=collection_id
    )


@given(
    'there is no documents in collection "(?P<collection_id>\w+)"'
)
def step_impl(context, collection_id):
    deform_session_project_client.documents.remove(
        collection=collection_id
    )


@then(
    'the output should contain md5 of '
    '"(?P<file_path>[^"]*)"(?P<binary>\sbinary)? file'
)
def step_impl(context, file_path, binary):
    mode = 'r' if not binary else 'rb'
    context.execute_steps(
        u'''
            Then the output should contain:
                """
                    "md5": "%s"
                """
        ''' % hashlib.md5(open(file_path, mode).read()).hexdigest()
    )
