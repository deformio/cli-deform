Feature: deform projects find

    Scenario: Show projects help
        When I successfully run `deform projects find -h`
        Then the output should contain exactly:
            """
            Usage: deform projects find [OPTIONS]

              Find projects available for user

            Options:
              -f, --filter JSON  Filter query
              -t, --text TEXT    Full text search value
              --pretty
              -h, --help         Show this message and exit.

            """

    Scenario: Running command with not logged in user
        When I run `deform projects find`
        Then I should be asked to login first

    Scenario: Run command
        Given I am logged in
        When I successfully run `deform projects find`
        Then the output should contain available for user projects

    Scenario: Run command with pretty print
        Given I am logged in
        When I successfully run `deform projects find --pretty`
        Then the output should contain available for user projects with pretty print

    Scenario Outline: Run command with filter
        Given I am logged in
        When I filter projects with <argument_name> argument by name
        Then the output should contain filtered by name projects
        And the output should contain 1 line
    Examples: Filter argument names
        | argument_name   |
        | -f              |
        | --filter        |


    Scenario Outline: Run command with full text search
        Given I am logged in
        When I filter projects with <argument_name> argument by text
        Then the output should contain filtered by full text projects
        And the output should contain 1 line
    Examples: Filter argument names
        | argument_name   |
        | -t              |
        | --text        |
