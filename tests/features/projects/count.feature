Feature: deform projects count

    Scenario: Show projects count help
        When I successfully run `deform projects count -h`
        Then the output should contain exactly:
            """
            Usage: deform projects count [OPTIONS]

              Number of projects available for user

            Options:
              -f, --filter JSON  Filter query
              -t, --text TEXT    Full text search value
              -h, --help         Show this message and exit.

            """

    Scenario: Running command with not logged in user
        When I run `deform projects count`
        Then I should be asked to login first

    Scenario: Run command
        Given I am logged in
        When I successfully run `deform projects count`
        Then the output should contain number of available for user projects

    Scenario Outline: Run command with filter
        Given I am logged in
        When I filter projects count with <argument_name> argument by name
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
        When I filter projects count with <argument_name> argument by text
        Then the output should contain exactly:
            """
            1

            """
    Examples: Filter argument names
        | argument_name   |
        | -t              |
        | --text        |
