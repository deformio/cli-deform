Feature: deform collection create

    Background: Cleaning collections
        Given there is no "venues" collection in current user's project

    Scenario: Show command help
        When I successfully run `deform collection create -h`
        Then the output should contain exactly:
            """
            Usage: deform collection create [OPTIONS]

              Creates a collection

            Options:
              -d, --data JSON  Data
              -h, --help       Show this message and exit.

            """

    Scenario: Running command with not logged in user
        When I run `deform collection create -d '{}'`
        Then I should be asked to login first

    Scenario: Running command without current project
        Given I am logged in
        When I run `deform collection create -d '{}'`
        Then I should be asked to set current project

    Scenario: Running command successfully
        Given I am logged in
        And I use a current user's project
        When I successfully run `deform collection create -d '{"_id": "venues", "name": "Venues"}'`
        Then the output should contain exactly:
            """
            Collection created

            """
        When I successfully run `deform collection get venues`
        Then the output should contain:
            """
            "_id": "venues"
            """

    Scenario: Trying to create collection when it's already exists
        Given I am logged in
        And I use a current user's project
        When I successfully run `deform collection create -d '{"_id": "venues", "name": "Venues"}'`
        And I run `deform collection create -d '{"_id": "venues", "name": "Venues"}'`
        Then the exit status should be 1
        Then the output should contain exactly:
            """
            Collection already exists.

            """
