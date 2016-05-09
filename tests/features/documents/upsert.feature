Feature: deform documents update

    Scenario: Show command help
        When I successfully run `deform documents upsert -h`
        Then the output should contain exactly:
            """
            Usage: deform documents upsert [OPTIONS]

              Update or insert document

            Options:
              -c, --collection TEXT  Collection  [required]
              -f, --filter JSON      Filter query
              -o, --operation JSON   Operation  [required]
              -h, --help             Show this message and exit.

            """

    Scenario: Running command without collection option
        When I run `deform documents upsert`
        Then the exit status should be 2
        Then the output should contain exactly:
            """
            Usage: deform documents upsert [OPTIONS]

            Error: Missing option "--collection" / "-c".

            """

    Scenario: Running command without operation option
        When I run `deform documents upsert -c hello`
        Then the exit status should be 2
        Then the output should contain exactly:
            """
            Usage: deform documents upsert [OPTIONS]

            Error: Missing option "--operation" / "-o".

            """

    Scenario: Running command with not logged in user
        When I run `deform documents upsert -c hello -o '{}'`
        Then I should be asked to login first

    Scenario: Running command without current project
        Given I am logged in
        When I run `deform documents upsert -c hello -o '{}'`
        Then I should be asked to set current project

    Scenario: Running command with not existing collection
        Given I am logged in
        And I use a current user's project
        And there is no "venues" collection in current user's project
        When I successfully run `deform documents upsert -c venues -o '{"$set": {"name": "Subway"}}'`
        Then the output should contain:
            """
            Created document with identity
            """

    Scenario: Running command with not existing by filter documents
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
        When I successfully run `deform documents upsert -c venues -o '{"$set": {"rating": 10}}' -f '{"name": "Pizza Hut"}'`
        Then the output should contain:
            """
            Created document with identity
            """
        When I successfully run `deform documents find -c venues -f '{"rating": 10}'`
        Then the output should contain 1 line
        And the output should contain:
            """
            "name": "Pizza Hut"
            """

    Scenario: Running command with existing by filter documents
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
        When I successfully run `deform documents upsert -c venues -o '{"$set": {"rating": 10}}' -f '{"name": "McDonalds"}'`
        Then the output should contain exactly:
            """
            Updated documents: 1

            """
        When I successfully run `deform documents find -c venues --pretty`
        Then the output should contain exactly:
            """
            {
                "_id": "mcdonalds",
                "name": "McDonalds",
                "rating": 10
            }
            {
                "_id": "subway",
                "name": "Subway"
            }

            """
