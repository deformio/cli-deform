Feature: deform document remove

    Scenario: Show command help
        When I successfully run `deform document remove -h`
        Then the output should contain exactly:
            """
            Usage: deform document remove [OPTIONS] DOCUMENT_ID

              Removes a document

            Options:
              -c, --collection TEXT  Collection  [required]
              -h, --help             Show this message and exit.

            """

    Scenario: Running command without document identity argument
        When I run `deform document remove -c hello`
        Then the exit status should be 2
        Then the output should contain exactly:
            """
            Usage: deform document remove [OPTIONS] DOCUMENT_ID

            Error: Missing argument "document_id".

            """

    Scenario: Running command without collection option
        When I run `deform document remove 100`
        Then the exit status should be 2
        Then the output should contain exactly:
            """
            Usage: deform document remove [OPTIONS] DOCUMENT_ID

            Error: Missing option "--collection" / "-c".

            """

    Scenario: Running command with not logged in user
        When I run `deform document remove 100 -c hello`
        Then I should be asked to login first

    Scenario: Running command without current project
        Given I am logged in
        When I run `deform document remove 100 -c hello`
        Then I should be asked to set current project

    Scenario: Running command with not existing collection
        Given I am logged in
        And I use a current user's project
        When I run `deform document remove 100 -c hello`
        Then the exit status should be 1
        And the stderr should contain exactly:
            """
            Collection not found.

            """

    Scenario: Running command with not existing document
        Given I am logged in
        And I use a current user's project
        And there is no documents in collection "_files"
        When I run `deform document remove 100 -c _files`
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
            {
                "_id": "subway",
                "name": "Subway"
            }
            """
        When I successfully run `deform document remove subway -c venues`
        Then the output should contain exactly:
            """
            Document removed

            """
        When I run `deform document get subway -c venues`
        Then the stderr should contain exactly:
            """
            Document not found.

            """
