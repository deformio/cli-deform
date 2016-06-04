Feature: deform signup

    Scenario: Show command help
        When I successfully run `deform signup -h`
        Then the output should contain exactly:
            """
            Usage: deform signup [OPTIONS]

              Creates an account

            Options:
              -e, --email TEXT
              -p, --password TEXT
              -h, --help           Show this message and exit.

            """


    Scenario Outline: Providing auth credentials by short and full argument names
        Given I use deform mock server
        When I run `deform signup <email> mock@email.com <password> mockpassword`
        Then the output should contain exactly:
            """
            Account successfully created! Check your email for confirmation code

            """
    Examples: Argument names
        | email   | password   |
        | -e      | -p         |
        | --email | --password |

    Scenario: Signup providing credentials in interactive mode
        Given I use deform mock server
        When I run `deform signup` interactively
        And I got "Email:" for interactive dialog
        And I type "mock@email.com"
        And I got "Password:" for interactive dialog
        And I type "mockpassword"
        Then the output should contain:
            """
            Account successfully created! Check your email for confirmation code
            """

    Scenario: Signup providing already existing email
        When I try to signup with current user's email
        Then the output should contain:
            """
            User already exists.

            """
        And the exit status should be 1
