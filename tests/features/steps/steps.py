from behave import when, then
from hamcrest import assert_that, has_entry, has_entries, is_not
from cli_bdd.behave.steps import *

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
        u'When I run login command with valid '
        'credentials providing -e and -p arguments'
    )


@then('the output should contain logged in user information')
def step_impl(context):
    context.execute_steps(
        u'''
            Then the output should contain:
                """
                You are {email}

                """
        '''.format(email=CONFIG['DEFORM']['EMAIL'])
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
