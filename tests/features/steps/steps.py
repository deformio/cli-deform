from behave import when, then
from hamcrest import assert_that, has_entry, has_entries, is_not
from cli_bdd.behave.steps import *

from src.deform import VERSION
from src.utils import load_config
from tests.testutils import CONFIG


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


@then('the output should contain available for user projects')
def step_impl(context):
    context.execute_steps(
        u'''
            Then the output should contain:
                """
                {
                    "_id": "%(project_id)s",
                    "name": "%(project_name)s",
                """
        ''' % dict(
            project_id=CONFIG['DEFORM']['PROJECT'],
            project_name=CONFIG['DEFORM']['PROJECT_NAME'],
        )
    )
