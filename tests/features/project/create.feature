Feature: deform project create

    Background: Using mock server
        Given I use deform mock server

    Scenario: Show command help
        When I successfully run `deform project create -h`
        Then the output should contain exactly:
            """
            Usage: deform project create [OPTIONS]

              Creates project

            Options:
              -d, --data JSON  Data
              -h, --help       Show this message and exit.

            """

    Scenario: Running command with not logged in user
        When I run `deform project create -d '{}'`
        Then I should be asked to login first

    Scenario: Running command with existing project
        Given I am logged in
        When I run `deform project create -d '{"_id": "existing-project"}'`
        Then the exit status should be 1
        And the output should contain:
            """
            Project already exists

            """

    Scenario: Running command with not existing project
        Given I am logged in
        When I successfully run `deform project create -d '{"_id": "not-existing-project", "name": "new project"}'`
        Then the output should contain exactly:
            """
            Project created

            """
