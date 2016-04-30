Feature: deform projects

    Scenario: Show projects help
        When I successfully run `deform projects -h`
        Then the output should contain exactly:
            """
            Usage: deform projects [OPTIONS]

              Shows all projects available for user

            Options:
              -f, --filter JSON
              --pretty
              -h, --help         Show this message and exit.

            """

    Scenario: Running command with not logged in user
        When I run `deform projects`
        Then I should be asked to login first

    Scenario: Run projects command
        Given I am logged in
        When I successfully run `deform projects`
        Then the output should contain available for user projects

    Scenario: Run projects command with pretty print
        Given I am logged in
        When I successfully run `deform projects --pretty`
        Then the output should contain available for user projects with pretty print

    Scenario Outline: Run projects command with filter
        Given I am logged in
        When I filter projects with <argument_name> argument by name
        Then the output should contain filtered by name projects
    Examples: Filter argument names
        | argument_name   |
        | -f              |
        | --filter        |
