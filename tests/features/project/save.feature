Feature: deform project save

    Background: Using mock server
        Given I use deform mock server

    Scenario: Show command help
        When I successfully run `deform project save -h`
        Then the output should contain exactly:
            """
            Usage: deform project save [OPTIONS]

              Saves a project

            Options:
              -d, --data JSON  Data
              -h, --help       Show this message and exit.

            """

    Scenario: Running command with not logged in user
        When I run `deform project create -d '{}'`
        Then I should be asked to login first

    Scenario: Running command with existing project
        Given I am logged in
        When I successfully run `deform project save -d '{"_id": "existing-project", "name": "existing project"}'`
        Then the output should contain exactly:
            """
            Project updated

            """

    Scenario: Running command with existing project
        Given I am logged in
        When I successfully run `deform project save -d '{"_id": "not-existing-project", "name": "not existing project"}'`
        Then the output should contain exactly:
            """
            Project created

            """
