Feature: deform use-project

    Scenario: Show command help
        When I successfully run `deform use-project -h`
        Then the output should contain exactly:
            """
            Usage: deform use-project [OPTIONS] PROJECT_ID

              Set current project

            Options:
              -h, --help  Show this message and exit.

            """

    Scenario: Running command with not logged in user
        When I run `deform use-project hello`
        Then I should be asked to login first

    Scenario: Run command with not user's project
        Given I am logged in
        When I run `deform use-project not-mine-project-id`
        Then the exit status should be 1
        And the stderr should contain exactly:
            """
            You're not a member of the project not-mine-project-id

            """

    Scenario: Run command with user's project
        Given I am logged in
        Given I use current user's project
        Then the exit status should be 0
        And the output should contain successfull switch to project info
        And the current project in settings should be current user's project
