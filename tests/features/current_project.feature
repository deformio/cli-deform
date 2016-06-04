Feature: deform current-project

    Scenario: Show command help
        When I successfully run `deform current-project -h`
        Then the output should contain exactly:
            """
            Usage: deform current-project [OPTIONS]

              Outputs a current project

            Options:
              -h, --help  Show this message and exit.

            """

    Scenario: Running command with no current project
        When I run `deform current-project`
        Then the output should contain exactly:
            """
            You don't have a current project. Use `deform use-project PROJECT_ID`.

            """
        And the exit status should be 1

    Scenario: Running command with current project
        Given I am logged in
        Given I use current user's project
        Then the output should contain successfull switch to project info
        When I run `deform current-project`
        Then the output should contain info about current user's project
