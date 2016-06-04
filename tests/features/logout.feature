Feature: deform logout

    Scenario: Command help
        When I successfully run `deform logout -h`
        Then the output should contain exactly:
            """
            Usage: deform logout [OPTIONS]

              Deletes current user authentication credentials

            Options:
              -h, --help  Show this message and exit.

            """

    Scenario: Running command with not logged in user
        When I run `deform logout`
        Then the exit status should be 1
        And the output should contain exactly:
            """
            You're not logged in.

            """

    Scenario: Run command with logged in user
        Given I am logged in
        When I successfully run `deform logout`
        Then the stderr should contain exactly:
            """
            Successfully logged out.

            """
        When I run `deform whoami`
        Then I should be asked to login first
