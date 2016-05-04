Feature: deform collection update

    Scenario: Show command help
        When I successfully run `deform collection update -h`
        Then the output should contain exactly:
            """
            Usage: deform collection update [OPTIONS] COLLECTION_ID

              Updates a collection

            Options:
              -d, --data JSON      Data
              -p, --property TEXT  Work with specified property
              -h, --help           Show this message and exit.

            """

    Scenario: Running command without collection identity argument
        When I run `deform collection update -d '{}'`
        Then the exit status should be 2
        Then the output should contain exactly:
            """
            Usage: deform collection update [OPTIONS] COLLECTION_ID

            Error: Missing argument "collection_id".

            """

    Scenario: Running command with not logged in user
        When I run `deform collection update venues -d '{}'`
        Then I should be asked to login first

    Scenario: Running command without current project
        Given I am logged in
        When I run `deform collection update venues -d '{}'`
        Then I should be asked to set current project

    Scenario: Running command successfully
        Given I am logged in
        And I use a current user's project
        When I successfully run `deform collection save -d '{"_id": "venues", "name": "Venues"}'`
        When I successfully run `deform collection update venues -d '{"schema": {"description": "Venues here"}}'`
        Then the output should contain exactly:
            """
            Collection updated

            """
        When I successfully run `deform collection get venues`
        Then the output should contain:
            """
            "schema": {"description": "Venues here"}
            """

    Scenario: Trying to update not existing collection
        Given I am logged in
        And I use a current user's project
        And there is no "venues" collection in current user's project
        When I run `deform collection update venues -d '{"schema": {"description": "Venues here"}}'`
        Then the exit status should be 1
        And the output should contain exactly:
            """
            Collection not found.

            """

    Scenario: Updating property
        Given I am logged in
        And I use a current user's project
        When I successfully run `deform collection save -d '{"_id": "venues", "name": "Venues", "schema": {"description": "Venues here", "additionalProperties": true}}'`
        When I successfully run `deform collection update venues -d 'false' -p schema.additionalProperties`
        Then the output should contain exactly:
            """
            Property updated

            """
        When I successfully run `deform collection get venues`
        Then the output should contain:
            """
            "additionalProperties": false
            """
        And the output should contain:
            """
            "description": "Venues here"
            """

    Scenario: Updating not existing property
        Given I am logged in
        And I use a current user's project
        When I successfully run `deform collection save -d '{"_id": "venues", "name": "Venues", "schema": {"description": "Venues here"}}'`
        When I run `deform collection update venues -d 'false' -p schema.additionalProperties`
        Then the exit status should be 1
        And the output should contain exactly:
            """
            Collection property not found.

            """
