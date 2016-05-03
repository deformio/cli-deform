Feature: deform project get

    Scenario: Show command help
        When I successfully run `deform project get -h`
        Then the output should contain exactly:
            """
            Usage: deform project get [OPTIONS] PROJECT_ID

              Returns a project's data

            Options:
              --pretty
              -h, --help  Show this message and exit.

            """

    Scenario: Running command with not logged in user
        When I run `deform project get hello`
        Then I should be asked to login first

    Scenario: Running command with user's project
        Given I am logged in
        When I am getting user's project info
        Then the exit status should be 0
        And the output should contain 1 line
        And the output should contain user's project info

    Scenario: Running command with not existing project
        Given I am logged in
        When I run `deform project get not-existing-project-id`
        Then the output should contain exactly:
            """
            Project not found.

            """

    Scenario: Run command with pretty print
        Given I am logged in
        When I am getting user's project info with pretty print
        Then the output should contain user's project info with pretty print
