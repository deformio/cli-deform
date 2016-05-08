Feature: deform document create

    Scenario: Show command help
        When I successfully run `deform document create -h`
        Then the output should contain exactly:
            """
            Usage: deform document create [OPTIONS]

              Creates a document

            Options:
              -d, --data JSON        Data
              -c, --collection TEXT  Collection  [required]
              --pretty
              -h, --help             Show this message and exit.

            """

    Scenario: Running command without collection option
        When I run `deform document create -d '{}'`
        Then the exit status should be 2
        Then the output should contain exactly:
            """
            Usage: deform document create [OPTIONS]

            Error: Missing option "--collection" / "-c".

            """

    Scenario: Running command with not logged in user
        When I run `deform document create -d '{}' -c hello`
        Then I should be asked to login first

    Scenario: Running command without current project
        Given I am logged in
        When I run `deform document create -d '{}' -c hello`
        Then I should be asked to set current project

    Scenario: Running command with not existing collection
        Given I am logged in
        And I use a current user's project
        And there is no "venues" collection in current user's project
        When I successfully run `deform document create -d '{"_id":"subway","name":"Subway"}' -c venues`
        Then the output should contain exactly:
            """
            {"_id": "subway","name": "Subway"}

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
        When I run `deform document create -d '{"_id":"subway","name":"Subway"}' -c venues`
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
        When I successfully run `deform document create -d '{"_id":"subway","name":"Subway"}' -c venues --pretty`
        Then the output should contain exactly:
            """
            {
                "_id": "subway",
                "name": "Subway"
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
        When I successfully run `deform document create -d '{"_id": "subway", "name": "Subway", "logo": @"/tmp/test.txt"}' -c venues --pretty`
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
        When I successfully run `deform document create -d '{"_id": "subway", "name": "Subway", "logo": @"/tmp/1.png"}' -c venues --pretty`
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
