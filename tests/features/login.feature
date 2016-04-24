Feature: deform login

    Scenario: Login help
        When I successfully run `deform login -h`
        Then the output should contain exactly:
            """
            Usage: deform login [OPTIONS]

              Authenticates against the API

            Options:
              -e, --email TEXT
              -p, --password TEXT
              -h, --help           Show this message and exit.

            """

    Scenario: Login with wrong credentials
        When I run `deform login -e some@email.com -p 123456`
        Then the output should contain:
            """
            Wrong credentials provided.
            """
        And the exit status should be 1

    Scenario Outline: Providing auth credentials by short and full argument names
        When I run login command with valid credentials providing <email> and <password> arguments
        Then I should be successfully logged in
    Examples: Argument names
        | email   | password   |
        | -e      | -p         |
        | --email | --password |

    Scenario: Login providing credentials in interactive mode
        When I run `deform login` interactively
        And I got "Email:" for interactive dialog
        And I type valid email credential
        And I got "Password:" for interactive dialog
        And I type valid password credential
        Then I should be successfully logged in
