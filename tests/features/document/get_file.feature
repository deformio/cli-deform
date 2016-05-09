Feature: deform document get-file

    Scenario: Show command help
        When I successfully run `deform document get-file -h`
        Then the output should contain exactly:
            """
            Usage: deform document get-file [OPTIONS] DOCUMENT_ID

              Returns a file content

            Options:
              -c, --collection TEXT  Collection  [required]
              -p, --property TEXT    Work with specified property
              -h, --help             Show this message and exit.

            """

    Scenario: Running command without document identity argument
        When I run `deform document get-file -c hello`
        Then the exit status should be 2
        Then the output should contain exactly:
            """
            Usage: deform document get-file [OPTIONS] DOCUMENT_ID

            Error: Missing argument "document_id".

            """

    Scenario: Running command without collection option
        When I run `deform document get-file 100`
        Then the exit status should be 2
        Then the output should contain exactly:
            """
            Usage: deform document get-file [OPTIONS] DOCUMENT_ID

            Error: Missing option "--collection" / "-c".

            """

    Scenario: Running command with not logged in user
        When I run `deform document get-file 100 -c hello`
        Then I should be asked to login first

    Scenario: Running command without current project
        Given I am logged in
        When I run `deform document get-file 100 -c hello`
        Then I should be asked to set current project

    Scenario: Running command with not existing collection
        Given I am logged in
        And I use a current user's project
        When I run `deform document get-file 100 -c hello`
        Then the exit status should be 1
        And the stderr should contain exactly:
            """
            Collection not found.

            """

    Scenario: Running command with not existing document
        Given I am logged in
        And I use a current user's project
        And there is no documents in collection "_files"
        When I run `deform document get-file 100 -c _files`
        Then the exit status should be 1
        And the stderr should contain exactly:
            """
            Document not found.

            """

    Scenario: Running command with existing text document
        Given I am logged in
        And I use a current user's project
        And a file "/tmp/test.txt" with "some content"
        When I successfully run `deform document save text_file -d '@"/tmp/test.txt"' -c _files`
        And I successfully run `deform document get-file text_file -c _files`
        Then the stdout should contain exactly:
            """
            some content
            """

    Scenario: Running command with existing binary document
        Given I am logged in
        And I use a current user's project
        And I copy a file from "./files/1.png" to "/tmp/1.png"
        When I successfully run `deform document save binary_file -d '@"/tmp/1.png"' -c _files`
        And I successfully run `deform document get-file binary_file -c _files > /tmp/binary_file.png`
        And I run `cmp /tmp/binary_file.png /tmp/1.png`
        Then the exit status should be 0

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
        When I run `deform document get-file subway -p logo -c venues`
        Then the exit status should be 1
        Then the stderr should contain exactly:
            """
            Document property not found.

            """

    Scenario: Running command with existing property but not it's not file
        Given I am logged in
        And I use a current user's project
        And there is a document in collection "venues":
            """
            {
                "_id": "subway",
                "name": "Subway"
            }
            """
        When I run `deform document get-file subway -p name -c venues`
        Then the exit status should be 1
        Then the stderr should contain exactly:
            """
            Document property not found.

            """

    Scenario: Running command with existing file property
        Given I am logged in
        And I use a current user's project
        And there is an empty "venues" collection in current user's project with schema:
            """
            {
                "properties": {
                    "name": {
                        "type": "string"
                    },
                    "logo": {
                        "type": "file"
                    }
                }
            }
            """
        And a file "/tmp/test.txt" with "some content"
        When I successfully run `deform document save subway -d '{"name": "Subway", "logo": @"/tmp/test.txt"}' -c venues`
        And I successfully run `deform document get-file subway -p logo -c venues`
        Then the stdout should contain exactly:
            """
            some content
            """
