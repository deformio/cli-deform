Feature: deform collections count

    Scenario: Show collections count help
        When I successfully run `deform collections count -h`
        Then the output should contain exactly:
            """
            Usage: deform collections count [OPTIONS]

              Number of collections

            Options:
              -f, --filter JSON  Filter query
              -t, --text TEXT    Full text search value
              -h, --help         Show this message and exit.

            """

    Scenario: Running command with not logged in user
        When I run `deform collections count`
        Then I should be asked to login first

    Scenario: Running command without current project
        Given I am logged in
        When I run `deform collections count`
        Then I should be asked to set current project

    Scenario: Run command
        Given I am logged in
        And I use a current user's project
        When I successfully run `deform collections count`
        Then the output should contain number of collections in user's project

    Scenario Outline: Run command with filter
        Given I am logged in
        And I use a current user's project
        When I successfully run `deform collections count <argument_name> '{"_id": "_files"}'`
        Then the output should contain exactly:
            """
            1

            """
    Examples: Filter argument names
        | argument_name   |
        | -f              |
        | --filter        |

    Scenario Outline: Run command with full text search
        Given I am logged in
        And I use a current user's project
        When I successfully run `deform collections count <argument_name> files`
        Then the output should contain exactly:
            """
            1

            """
    Examples: Filter argument names
        | argument_name   |
        | -t              |
        | --text        |
