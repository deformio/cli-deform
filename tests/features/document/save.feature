Feature: deform document save

    Scenario: Show command help
        When I successfully run `deform document save -h`
        Then the output should contain exactly:
            """
            Usage: deform document save [OPTIONS] [DOCUMENT_ID]

              Saves a document

            Options:
              -c, --collection TEXT  Collection  [required]
              -d, --data JSON        Data
              -p, --property TEXT    Work with specified property
              --pretty
              -h, --help             Show this message and exit.

            """

    Scenario: Running command without collection option
        When I run `deform document save -d '{}'`
        Then the exit status should be 2
        Then the output should contain exactly:
            """
            Usage: deform document save [OPTIONS] [DOCUMENT_ID]

            Error: Missing option "--collection" / "-c".

            """

    Scenario: Running command with not logged in user
        When I run `deform document save -d '{}' -c hello`
        Then I should be asked to login first

    Scenario: Running command without current project
        Given I am logged in
        When I run `deform document save -d '{}' -c hello`
        Then I should be asked to set current project

    Scenario: Running command with not existing collection
        Given I am logged in
        And I use a current user's project
        And there is no "venues" collection in current user's project
        When I successfully run `deform document save -d '{"_id":"subway","name":"Subway"}' -c venues`
        Then the output should contain exactly:
            """
            {"created": true,"result": {"_id": "subway","name": "Subway"}}

            """
        When I successfully run `deform document get subway -c venues`
        Then the output should contain exactly:
            """
            {"_id": "subway","name": "Subway"}

            """

    Scenario: Running command with not valid for schema data
        Given I am logged in
        And I use a current user's project
        And there is an empty "venues" collection in current user's project
        When I successfully run `deform collection update venues -p schema -d '{"properties":{"rating": {"type":"number","required":true}}}'`
        When I run `deform document save -d '{"_id":"subway","name":"Subway"}' -c venues`
        Then the exit status should be 1
        Then the output should contain exactly:
            """
            Validation error:
            * "rating" - rating is required
            * "name" - Additional property name is not allowed

            """

    Scenario: Running command with pretty print
        Given I am logged in
        And I use a current user's project
        And there is no "venues" collection in current user's project
        When I successfully run `deform document save -d '{"_id":"subway","name":"Subway"}' -c venues --pretty`
        Then the output should contain exactly:
            """
            {
                "created": true,
                "result": {
                    "_id": "subway",
                    "name": "Subway"
                }
            }

            """

    Scenario: Running command with document identity argument
        Given I am logged in
        And I use a current user's project
        And there is no "venues" collection in current user's project
        When I successfully run `deform document save subway -d '{"name":"Subway"}' -c venues --pretty`
        Then the output should contain exactly:
            """
            {
                "created": true,
                "result": {
                    "_id": "subway",
                    "name": "Subway"
                }
            }

            """

    Scenario: Running command with already existing document
        Given I am logged in
        And I use a current user's project
        And there is no "venues" collection in current user's project
        When I successfully run `deform document save subway -d '{"name":"Subway"}' -c venues`
        And I successfully run `deform document save subway -d '{"name":"SUBWAY"}' -c venues --pretty`
        Then the output should contain exactly:
            """
            {
                "created": false,
                "result": {
                    "_id": "subway",
                    "name": "SUBWAY"
                }
            }

            """

    Scenario: Running command with not existing property
        Given I am logged in
        And I use a current user's project
        And there is no "venues" collection in current user's project
        When I successfully run `deform document save subway -d '{"name":"Subway"}' -c venues`
        And I successfully run `deform document save subway -p rating -d '10' -c venues --pretty`
        Then the output should contain exactly:
            """
            {
                "created": true,
                "result": 10
            }

            """
        When I successfully run `deform document get subway -c venues --pretty`
        Then the output should contain exactly:
            """
            {
                "_id": "subway",
                "name": "Subway",
                "rating": 10
            }

            """

    Scenario: Running command with existing property
        Given I am logged in
        And I use a current user's project
        And there is no "venues" collection in current user's project
        When I successfully run `deform document save subway -d '{"name":"Subway", "rating": 5}' -c venues`
        And I successfully run `deform document save subway -p rating -d '10' -c venues --pretty`
        Then the output should contain exactly:
            """
            {
                "created": false,
                "result": 10
            }

            """
        When I successfully run `deform document get subway -c venues --pretty`
        Then the output should contain exactly:
            """
            {
                "_id": "subway",
                "name": "Subway",
                "rating": 10
            }

            """

    Scenario: Running command with text file
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
        When I successfully run `deform document save subway -d '{"name": "Subway", "logo": @"/tmp/test.txt"}' -c venues --pretty`
        Then the output should contain:
            """
                    "_id": "subway",
            """
        And the output should contain:
            """
                    "name": "Subway"
            """
        And the output should contain:
            """
                    "logo": {
            """
        And the output should contain:
            """
                        "collection_id": "venues",
                        "content_type": "text/plain",
            """
        And the output should contain:
            """
                        "name": "test.txt",
                        "size": 12
            """

    Scenario: Running command with binary file
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
        And I copy a file from "./files/1.png" to "/tmp/1.png"
        When I successfully run `deform document save subway -d '{"name": "Subway", "logo": @"/tmp/1.png"}' -c venues --pretty`
        Then the output should contain:
            """
                    "_id": "subway",
            """
        And the output should contain:
            """
                    "name": "Subway"
            """
        And the output should contain:
            """
                    "logo": {
            """
        And the output should contain:
            """
                        "collection_id": "venues",
                        "content_type": "image/png",
            """
        And the output should contain:
            """
                        "name": "1.png",
            """
        And the output should contain md5 of "/tmp/1.png" binary file
