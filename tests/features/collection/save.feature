Feature: deform collection save

    Background: Cleaning collections
        Given there is no "venues" collection in current user's project

    Scenario: Show command help
        When I successfully run `deform collection save -h`
        Then the output should contain exactly:
            """
            Usage: deform collection save [OPTIONS] [COLLECTION_ID]

              Saves a collection

            Options:
              -d, --data JSON      Data
              -p, --property TEXT  Work with specified property
              -h, --help           Show this message and exit.

            """

    Scenario: Running command with not logged in user
        When I run `deform collection save -d '{}'`
        Then I should be asked to login first

    Scenario: Running command without current project
        Given I am logged in
        When I run `deform collection save -d '{}'`
        Then I should be asked to set current project

    Scenario: Running command successfully
        Given I am logged in
        And I use a current user's project
        When I successfully run `deform collection save -d '{"_id": "venues", "name": "Venues"}'`
        Then the output should contain exactly:
            """
            Collection created

            """
        When I successfully run `deform collection get venues`
        Then the output should contain:
            """
            "_id": "venues"
            """

    Scenario: Saving collection when it's already exists
        Given I am logged in
        And I use a current user's project
        When I successfully run `deform collection save -d '{"_id": "venues", "name": "Venues"}'`
        And I successfully run `deform collection save -d '{"_id": "venues", "name": "New venues"}'`
        Then the output should contain exactly:
            """
            Collection updated

            """
        When I successfully run `deform collection get venues`
        Then the output should contain:
            """
            "name": "New venues"
            """

    Scenario: Saving collection with identity argument
        Given I am logged in
        And I use a current user's project
        When I successfully run `deform collection save venues -d '{"name": "Venues"}'`
        Then the output should contain exactly:
            """
            Collection created

            """
        When I successfully run `deform collection get venues`
        Then the output should contain:
            """
            "_id": "venues"
            """

    Scenario: Saving property for not existing collection
        Given I am logged in
        And I use a current user's project
        When I successfully run `deform collection save venues -d '"Venues"' -p name`
        Then the output should contain exactly:
            """
            Property saved

            """
        When I successfully run `deform collection get venues`
        Then the output should contain:
            """
            "_id": "venues"
            """

    Scenario: Saving property for existing collection
        Given I am logged in
        And I use a current user's project
        When I successfully run `deform collection save venues -d '{"name": "Venues"}'`
        And I successfully run `deform collection save venues -d '"New venues"' -p name`
        Then the output should contain exactly:
            """
            Property saved

            """
        When I successfully run `deform collection get venues`
        Then the output should contain:
            """
            "name": "New venues"
            """
