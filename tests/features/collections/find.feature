Feature: deform projects find

    Scenario: Show projects find help
        When I successfully run `deform collections find -h`
        Then the output should contain exactly:
            """
            Usage: deform collections find [OPTIONS]

              Find collections

            Options:
              -f, --filter JSON  Filter query
              -t, --text TEXT    Full text search value
              --pretty
              -h, --help         Show this message and exit.

            """

    Scenario: Running command with not logged in user
        When I run `deform collections find`
        Then I should be asked to login first

    Scenario: Running command without current project
        Given I am logged in
        When I run `deform collections find`
        Then I should be asked to set current project

    Scenario: Run command
        Given I am logged in
        And I use a current user's project
        When I successfully run `deform collections find`
        Then the output should contain collections in user's project

    Scenario: Run command with pretty print
        Given I am logged in
        And I use a current user's project
        When I successfully run `deform collections find --pretty`
        Then the output should contain collections in user's project with pretty print

    Scenario Outline: Run command with filter
        Given I am logged in
        And I use a current user's project
        When I successfully run `deform collections find <argument_name> '{"_id": "_files"}'`
        Then the output should contain 1 line
        Then the output should contain:
            """
            "_id": "_files"
            """
    Examples: Filter argument names
        | argument_name   |
        | -f              |
        | --filter        |


    Scenario Outline: Run command with full text search
        Given I am logged in
        And I use a current user's project
        When I successfully run `deform collections find <argument_name> files`
        Then the output should contain 1 line
        Then the output should contain:
            """
            "_id": "_files"
            """
    Examples: Filter argument names
        | argument_name   |
        | -t              |
        | --text          |
