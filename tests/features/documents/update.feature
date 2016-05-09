Feature: deform documents update

    Scenario: Show command help
        When I successfully run `deform documents update -h`
        Then the output should contain exactly:
            """
            Usage: deform documents update [OPTIONS]

              Update documents

            Options:
              -c, --collection TEXT  Collection  [required]
              -f, --filter JSON      Filter query
              -o, --operation JSON   Operation  [required]
              -h, --help             Show this message and exit.

            """

    Scenario: Running command without collection option
        When I run `deform documents update`
        Then the exit status should be 2
        Then the output should contain exactly:
            """
            Usage: deform documents update [OPTIONS]

            Error: Missing option "--collection" / "-c".

            """

    Scenario: Running command without operation option
        When I run `deform documents update -c hello`
        Then the exit status should be 2
        Then the output should contain exactly:
            """
            Usage: deform documents update [OPTIONS]

            Error: Missing option "--operation" / "-o".

            """

    Scenario: Running command with not logged in user
        When I run `deform documents update -c hello -o '{}'`
        Then I should be asked to login first

    Scenario: Running command without current project
        Given I am logged in
        When I run `deform documents update -c hello -o '{}'`
        Then I should be asked to set current project

    Scenario: Running command with not existing collection
        Given I am logged in
        And I use a current user's project
        And there is no "venues" collection in current user's project
        When I run `deform documents update -c venues -o '{}'`
        Then the exit status should be 1
        And the stderr should contain exactly:
            """
            Collection not found.

            """

    Scenario: Running command updating all documents
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
        When I successfully run `deform documents update -c venues -o '{"$set": {"rating": 10}}'`
        Then the output should contain exactly:
            """
            2

            """
        When I successfully run `deform documents find -c venues`
        Then the output should contain exactly:
            """
            {"_id": "mcdonalds","name": "McDonalds","rating": 10}
            {"_id": "subway","name": "Subway","rating": 10}

            """

    Scenario: Running command updating documents by filter
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
        When I successfully run `deform documents update -c venues -o '{"$set": {"rating": 10}}' -f '{"name": "Subway"}'`
        Then the output should contain exactly:
            """
            1

            """
        When I successfully run `deform documents find -c venues`
        Then the output should contain exactly:
            """
            {"_id": "mcdonalds","name": "McDonalds"}
            {"_id": "subway","name": "Subway","rating": 10}

            """
