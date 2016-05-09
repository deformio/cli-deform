Feature: deform documents count

    Scenario: Show command help
        When I successfully run `deform documents count -h`
        Then the output should contain exactly:
            """
            Usage: deform documents count [OPTIONS]

              Number of documents

            Options:
              -c, --collection TEXT  Collection  [required]
              -f, --filter JSON      Filter query
              -t, --text TEXT        Full text search value
              -h, --help             Show this message and exit.

            """

    Scenario: Running command without collection option
        When I run `deform documents count`
        Then the exit status should be 2
        Then the output should contain exactly:
            """
            Usage: deform documents count [OPTIONS]

            Error: Missing option "--collection" / "-c".

            """

    Scenario: Running command with not logged in user
        When I run `deform documents count -c hello`
        Then I should be asked to login first

    Scenario: Running command without current project
        Given I am logged in
        When I run `deform documents count -c hello`
        Then I should be asked to set current project

    Scenario: Running command with not existing collection
        Given I am logged in
        And I use a current user's project
        And there is no "venues" collection in current user's project
        When I run `deform documents count -c venues`
        Then the exit status should be 1
        And the stderr should contain exactly:
            """
            Collection not found.

            """

    Scenario: Running command with existing collection
        Given I am logged in
        And I use a current user's project
        And there is an empty "venues" collection in current user's project
        And there is a document in collection "venues":
            """
            {
                "_id": "subway",
                "name": "Subway"
            }
            """
        And there is a document in collection "venues":
            """
            {
                "_id": "mcdonalds",
                "name": "McDonalds"
            }
            """
        When I successfully run `deform documents count -c venues`
        Then the output should contain exactly:
            """
            2

            """

    Scenario: Running command with filter
        Given I am logged in
        And I use a current user's project
        And there is an empty "venues" collection in current user's project
        And there is a document in collection "venues":
            """
            {
                "_id": "subway",
                "name": "Subway"
            }
            """
        And there is a document in collection "venues":
            """
            {
                "_id": "mcdonalds",
                "name": "McDonalds"
            }
            """
        When I successfully run `deform documents count -c venues -f '{"name":"McDonalds"}'`
        Then the output should contain exactly:
            """
            1

            """

    Scenario: Running command with full text search
        Given I am logged in
        And I use a current user's project
        And there is an empty "venues" collection in current user's project
        And there is a document in collection "venues":
            """
            {
                "_id": "subway",
                "name": "Subway"
            }
            """
        And there is a document in collection "venues":
            """
            {
                "_id": "mcdonalds",
                "name": "McDonalds"
            }
            """
        When I successfully run `deform collection update venues -d '{"indexes":[{"type": "text", "property": "name", "language": "english"}]}'`
        And I successfully run `deform documents count -c venues -t mcdonalds`
        Then the output should contain exactly:
            """
            1

            """
