Feature: deform document get

    Scenario: Show command help
        When I successfully run `deform document get -h`
        Then the output should contain exactly:
            """
            Usage: deform document get [OPTIONS] DOCUMENT_ID

              Returns a document

            Options:
              -c, --collection TEXT  Collection  [required]
              -p, --property TEXT    Work with specified property
              --pretty
              -h, --help             Show this message and exit.

            """

    Scenario: Running command without document identity argument
        When I run `deform document get -c hello`
        Then the exit status should be 2
        Then the output should contain exactly:
            """
            Usage: deform document get [OPTIONS] DOCUMENT_ID

            Error: Missing argument "document_id".

            """

    Scenario: Running command without collection option
        When I run `deform document get 100`
        Then the exit status should be 2
        Then the output should contain exactly:
            """
            Usage: deform document get [OPTIONS] DOCUMENT_ID

            Error: Missing option "--collection" / "-c".

            """

    Scenario: Running command with not logged in user
        When I run `deform document get 100 -c hello`
        Then I should be asked to login first

    Scenario: Running command without current project
        Given I am logged in
        When I run `deform document get 100 -c hello`
        Then I should be asked to set current project

    Scenario: Running command with not existing collection
        Given I am logged in
        And I use a current user's project
        When I run `deform document get 100 -c hello`
        Then the exit status should be 1
        And the stderr should contain exactly:
            """
            Collection not found.

            """

    Scenario: Running command with not existing document
        Given I am logged in
        And I use a current user's project
        And there is an empty "venues" collection in current user's project
        When I run `deform document get 100 -c venues`
        Then the exit status should be 1
        And the stderr should contain exactly:
            """
            Document not found.

            """

    Scenario: Running command with existing document
        Given I am logged in
        And I use a current user's project
        And there is a document in collection "venues":
            """
            {"_id": "mcdonalds","name": "McDonalds"}
            """
        When I successfully run `deform document get mcdonalds -c venues`
        Then the output should contain exactly:
            """
            {"_id": "mcdonalds","name": "McDonalds"}

            """

    Scenario: Running command with pretty print
        Given I am logged in
        And I use a current user's project
        And there is a document in collection "venues":
            """
            {"_id": "mcdonalds","name": "McDonalds"}
            """
        When I successfully run `deform document get mcdonalds -c venues --pretty`
        Then the output should contain exactly:
            """
            {
                "_id": "mcdonalds",
                "name": "McDonalds"
            }

            """

    Scenario: Getting not existing property
        Given I am logged in
        And I use a current user's project
        And there is a document in collection "venues":
            """
            {"_id": "mcdonalds","name": "McDonalds"}
            """
        When I run `deform document get mcdonalds -c venues -p address`
        Then the exit status should be 1
        And the stderr should contain exactly:
            """
            Document property not found.

            """

    Scenario: Getting existing property
        Given I am logged in
        And I use a current user's project
        And there is a document in collection "venues":
            """
            {"_id": "mcdonalds","phones": ["one", "two", {"value": "three"}]}
            """
        When I successfully run `deform document get mcdonalds -c venues -p phones[2].value`
        Then the output should contain exactly:
            """
            "three"

            """
