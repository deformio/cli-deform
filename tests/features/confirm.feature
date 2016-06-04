Feature: deform confirm

    Scenario: Command help
        When I successfully run `deform confirm -h`
        Then the output should contain exactly:
            """
            Usage: deform confirm [OPTIONS] CODE

              Confirms email by code

            Options:
              -h, --help  Show this message and exit.

            """

    Scenario: Not providing code argument
        When I run `deform confirm`
        Then the output should contain exactly:
            """
            Usage: deform confirm [OPTIONS] CODE

            Error: Missing argument "code".

            """
        And the exit status should be 2

    Scenario: Providing not existing code
        When I run `deform confirm sosisa`
        Then the output should contain exactly:
            """
            Confirmation code not found.

            """
        And the exit status should be 1

    Scenario: Providing existing code
        Given I use deform mock server
        When I successfully run `deform confirm mock-confirmation-code`
        Then the output should contain exactly:
            """
            Email successfully confirmed! You are logged in as mock@email.com

            """
        When I successfully run `deform whoami`
        Then the output should contain exactly:
            """
            You are mock@email.com

            """
