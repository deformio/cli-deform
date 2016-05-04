Feature: deform collection remove

    Scenario: Show command help
        When I successfully run `deform collection remove -h`
        Then the output should contain exactly:
            """
            Usage: deform collection remove [OPTIONS] COLLECTION_ID

              Removes a collection

            Options:
              -p, --property TEXT  Work with specified property
              -h, --help           Show this message and exit.

            """

    Scenario: Running command without collection identity argument
        When I run `deform collection remove`
        Then the exit status should be 2
        Then the output should contain exactly:
            """
            Usage: deform collection remove [OPTIONS] COLLECTION_ID

            Error: Missing argument "collection_id".

            """

    Scenario: Running command with not logged in user
        When I run `deform collection remove 100`
        Then I should be asked to login first

    Scenario: Running command without current project
        Given I am logged in
        When I run `deform collection remove 100`
        Then I should be asked to set current project

    Scenario: Removing existing collection
        Given I am logged in
        And I use a current user's project
        When I successfully run `deform collection save -d '{"_id": "venues", "name": "Venues"}'`
        And I successfully run `deform collection remove venues`
        Then the output should contain exactly:
            """
            Collection removed

            """
        When I run `deform collection get venues`
        Then the exit status should be 1
        And the output should contain exactly:
            """
            Collection not found.

            """

    Scenario: Removing not existing collection
        Given I am logged in
        And I use a current user's project
        And there is no "venues" collection in current user's project
        When I run `deform collection remove venues`
        Then the exit status should be 1
        And the output should contain exactly:
            """
            Collection not found.

            """

    Scenario: Removing existing property
        Given I am logged in
        And I use a current user's project
        When I successfully run `deform collection save -d '{"_id": "venues", "name": "Venues", "schema": {"description": "Some schema", "additionalProperties": true}}'`
        And I successfully run `deform collection remove venues -p schema.additionalProperties`
        Then the output should contain exactly:
            """
            Property removed

            """
        When I successfully run `deform collection get venues`
        Then the output should not contain:
            """
            additionalProperties
            """

    Scenario: Removing not existing property
        Given I am logged in
        And I use a current user's project
        When I successfully run `deform collection save -d '{"_id": "venues", "name": "Venues", "schema": {"description": "Some schema"}}'`
        And I run `deform collection remove venues -p schema.additionalProperties`
        Then the exit status should be 1
        And the output should contain exactly:
            """
            Collection property not found.

            """
