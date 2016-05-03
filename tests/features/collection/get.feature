Feature: deform collection get

    Scenario: Show command help
        When I successfully run `deform collection get -h`
        Then the output should contain exactly:
            """
            Usage: deform collection get [OPTIONS] COLLECTION_ID

              Returns a collection

            Options:
              --pretty
              -p, --property TEXT  Work with specified property
              -h, --help           Show this message and exit.

            """

    Scenario: Running command without collection identity argument
        When I run `deform collection get`
        Then the exit status should be 2
        Then the output should contain exactly:
            """
            Usage: deform collection get [OPTIONS] COLLECTION_ID

            Error: Missing argument "collection_id".

            """

    Scenario: Running command with not logged in user
        When I run `deform collection get 100`
        Then I should be asked to login first

    Scenario: Running command without current project
        Given I am logged in
        When I run `deform collection get 100`
        Then I should be asked to set current project

    Scenario: Running command with not existing collection
        Given I am logged in
        Given I use a current user's project
        When I run `deform collection get not-existing-collection`
        Then the exit status should be 1
        And the stderr should contain exactly:
            """
            Collection not found.

            """

    Scenario: Running command with existing collection
        Given I am logged in
        Given I use a current user's project
        When I successfully run `deform collection get _files`
        Then the stdout should contain:
            """
            "_id": "_files"
            """

    Scenario: Getting a collection with pretty print
        Given I am logged in
        Given I use a current user's project
        When I successfully run `deform collection get _files --pretty`
        Then the stdout should contain:
            """
                "_id": "_files"
            """

    Scenario Outline: Getting a collection property
        Given I am logged in
        Given I use a current user's project
        When I successfully run `deform collection get _files <argument_name> documents_permissions.removeable`
        Then the stdout should contain exactly:
            """
            true

            """
    Examples: property argument names
        | argument_name |
        | -p            |
        | --property    |

    Scenario: Getting a collection not existing property
        Given I am logged in
        Given I use a current user's project
        When I run `deform collection get _files -p not.existing.property`
        Then the exit status should be 1
        Then the stdout should contain exactly:
            """
            Collection property not found.

            """
