Feature: deform documents find

    Scenario: Show command help
        When I successfully run `deform documents find -h`
        Then the output should contain exactly:
            """
            Usage: deform documents find [OPTIONS]

              Find documents

            Options:
              -c, --collection TEXT      Collection  [required]
              -f, --filter JSON          Filter query
              -s, --sort TEXT            Sort by field
              -t, --text TEXT            Full text search value
              -i, --fields TEXT          Return specified fields only
              -e, --fields-exclude TEXT  Return all but the excluded fields
              --pretty
              -h, --help                 Show this message and exit.

            """

    Scenario: Running command without collection option
        When I run `deform documents find`
        Then the exit status should be 2
        Then the output should contain exactly:
            """
            Usage: deform documents find [OPTIONS]

            Error: Missing option "--collection" / "-c".

            """

    Scenario: Running command with not logged in user
        When I run `deform documents find -c hello`
        Then I should be asked to login first

    Scenario: Running command without current project
        Given I am logged in
        When I run `deform documents find -c hello`
        Then I should be asked to set current project

    Scenario: Running command with not existing collection
        Given I am logged in
        And I use a current user's project
        And there is no "venues" collection in current user's project
        When I run `deform documents find -c venues`
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
        When I successfully run `deform documents find -c venues`
        Then the output should contain exactly:
            """
            {"_id": "mcdonalds","name": "McDonalds"}
            {"_id": "subway","name": "Subway"}

            """

    Scenario: Running command with custom sort
        Given I am logged in
        And I use a current user's project
        And there is an empty "venues" collection in current user's project
        And there is a document in collection "venues":
            """
            {
                "_id": "subway",
                "name": "Subway",
                "rating": 1
            }
            """
        And there is a document in collection "venues":
            """
            {
                "_id": "mcdonalds",
                "name": "McDonalds",
                "rating": 2
            }
            """
        When I successfully run `deform documents find -c venues -s rating`
        Then the output should contain exactly:
            """
            {"_id": "subway","name": "Subway","rating": 1}
            {"_id": "mcdonalds","name": "McDonalds","rating": 2}

            """
        When I successfully run `deform documents find -c venues -s -rating`
        Then the output should contain exactly:
            """
            {"_id": "mcdonalds","name": "McDonalds","rating": 2}
            {"_id": "subway","name": "Subway","rating": 1}

            """

    Scenario: Running command with pretty print
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
        When I successfully run `deform documents find -c venues --pretty`
        Then the output should contain exactly:
            """
            {
                "_id": "subway",
                "name": "Subway"
            }

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
        When I successfully run `deform documents find -c venues -f '{"name":"McDonalds"}'`
        Then the output should contain exactly:
            """
            {"_id": "mcdonalds","name": "McDonalds"}

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
        And I successfully run `deform documents find -c venues -t mcdonalds`
        Then the output should contain exactly:
            """
            {"_id": "mcdonalds","name": "McDonalds"}

            """

    Scenario: Running command with fields include and exclude
        Given I am logged in
        And I use a current user's project
        And there is an empty "venues" collection in current user's project
        And there is a document in collection "venues":
            """
            {
                "_id": "subway",
                "name": "Subway",
                "rating": 10,
                "phones": {
                    "local": 1234,
                    "global": 4321
                }
            }
            """
        When I successfully run `deform documents find -c venues -i rating -i phones.global --pretty`
        Then the output should contain exactly:
            """
            {
                "_id": "subway",
                "phones": {
                    "global": 4321
                },
                "rating": 10
            }

            """
        When I successfully run `deform documents find -c venues -e rating -e phones.global --pretty`
        Then the output should contain exactly:
            """
            {
                "_id": "subway",
                "name": "Subway",
                "phones": {
                    "local": 1234
                }
            }

            """
