Feature: deform documents remove

    Scenario: Show command help
        When I successfully run `deform documents remove -h`
        Then the output should contain exactly:
            """
            Usage: deform documents remove [OPTIONS]

              Removes documents

            Options:
              -c, --collection TEXT  Collection  [required]
              -f, --filter JSON      Filter query
              --yes                  Confirm the action without prompting.
              -h, --help             Show this message and exit.

            """

    Scenario: Running command without collection option
        When I run `deform documents remove --yes`
        Then the exit status should be 2
        Then the output should contain exactly:
            """
            Usage: deform documents remove [OPTIONS]

            Error: Missing option "--collection" / "-c".

            """

    Scenario: Running command with not logged in user
        When I run `deform documents remove -c hello --yes`
        Then I should be asked to login first

    Scenario: Running command without current project
        Given I am logged in
        When I run `deform documents remove -c hello --yes`
        Then I should be asked to set current project

    Scenario: Running command with not existing collection
        Given I am logged in
        And I use a current user's project
        And there is no "venues" collection in current user's project
        When I run `deform documents remove -c venues --yes`
        Then the exit status should be 1
        And the stderr should contain exactly:
            """
            Collection not found.

            """

    Scenario: Running command and say no
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
        When I run `deform documents remove -c venues` interactively
        And I got "Are you sure you want to remove documents?" for interactive dialog
        And I type "no"
        Then the output should contain exactly:
            """
            Aborted!

            """
        When I run `deform documents count -c venues`
        Then the output should contain exactly:
            """
            2

            """

    Scenario: Running command and say yes
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
        When I run `deform documents remove -c venues` interactively
        And I got "Are you sure you want to remove documents?" for interactive dialog
        And I type "yes"
        Then the output should contain exactly:
            """
            Removed documents: 2

            """
        When I run `deform documents count -c venues`
        Then the output should contain exactly:
            """
            0

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
        When I run `deform documents remove -c venues -f '{"name": "McDonalds"}' --yes`
        Then the output should contain exactly:
            """
            Removed documents: 1

            """
        When I run `deform documents find -c venues --pretty`
        Then the output should contain exactly:
            """
            {
                "_id": "subway",
                "name": "Subway"
            }

            """
