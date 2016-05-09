Feature: deform document update

    Scenario: Show command help
        When I successfully run `deform document update -h`
        Then the output should contain exactly:
            """
            Usage: deform document update [OPTIONS] DOCUMENT_ID

              Updates a document

            Options:
              -c, --collection TEXT  Collection  [required]
              -d, --data JSON        Data  [required]
              -p, --property TEXT    Work with specified property
              --pretty
              -h, --help             Show this message and exit.

            """

    Scenario: Running command without document identity argument
        When I run `deform document update -c hello`
        Then the exit status should be 2
        Then the output should contain exactly:
            """
            Usage: deform document update [OPTIONS] DOCUMENT_ID

            Error: Missing argument "document_id".

            """

    Scenario: Running command without collection option
        When I run `deform document update 100`
        Then the exit status should be 2
        Then the output should contain exactly:
            """
            Usage: deform document update [OPTIONS] DOCUMENT_ID

            Error: Missing option "--collection" / "-c".

            """

    Scenario: Running command without data option
        When I run `deform document update 100 -c hello`
        # Then the exit status should be 2
        Then the output should contain exactly:
            """
            Usage: deform document update [OPTIONS] DOCUMENT_ID

            Error: Missing option "--data" / "-d".

            """

    Scenario: Running command with not logged in user
        When I run `deform document update 100 -d '{}' -c hello`
        Then I should be asked to login first

    Scenario: Running command without current project
        Given I am logged in
        When I run `deform document update 100 -d '{}' -c hello`
        Then I should be asked to set current project

    Scenario: Running command with not existing collection
        Given I am logged in
        And I use a current user's project
        When I run `deform document update 100 -d '{"rating": 1}' -c hello`
        Then the exit status should be 1
        And the stderr should contain exactly:
            """
            Collection not found.

            """

    Scenario: Running command with existing collection but not existing document
        Given I am logged in
        And I use a current user's project
        And there is an empty "venues" collection in current user's project
        When I run `deform document update 100 -d '{"rating": 1}' -c venues`
        Then the exit status should be 1
        And the stderr should contain exactly:
            """
            Document not found.

            """

    Scenario: Running command with existing collection and document
        Given I am logged in
        And I use a current user's project
        And there is a document in collection "venues":
            """
            {
                "_id": "subway",
                "name": "Subway"
            }
            """
        When I successfully run `deform document update subway -d '{"rating": 1}' -c venues`
        Then the output should contain exactly:
            """
            {"_id": "subway","name": "Subway","rating": 1}

            """

    Scenario: Running command with pretty print
        Given I am logged in
        And I use a current user's project
        And there is a document in collection "venues":
            """
            {
                "_id": "subway",
                "name": "Subway"
            }
            """
        When I successfully run `deform document update subway -d '{"rating": 1}' -c venues --pretty`
        Then the output should contain exactly:
            """
            {
                "_id": "subway",
                "name": "Subway",
                "rating": 1
            }

            """

    Scenario: Running command with not existing property
        Given I am logged in
        And I use a current user's project
        And there is a document in collection "venues":
            """
            {
                "_id": "subway",
                "name": "Subway"
            }
            """
        When I successfully run `deform document update subway -d '123456' -p phone.local -c venues`
        Then the output should contain exactly:
            """
            123456

            """
        When I successfully run `deform document get subway -c venues`
        Then the output should contain exactly:
            """
            {"_id": "subway","name": "Subway","phone": {"local": 123456}}

            """

    Scenario: Running command with existing property
        Given I am logged in
        And I use a current user's project
        And there is a document in collection "venues":
            """
            {
                "_id": "subway",
                "name": "Subway",
                "phone": {
                    "local": 98765,
                    "world": 11111
                }
            }
            """
        When I successfully run `deform document update subway -d '123456' -p phone.local -c venues`
        Then the output should contain exactly:
            """
            123456

            """
        When I successfully run `deform document get subway -c venues`
        Then the output should contain exactly:
            """
            {"_id": "subway","name": "Subway","phone": {"local": 123456,"world": 11111}}

            """
