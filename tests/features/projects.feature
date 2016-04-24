Feature: deform projects

    Scenario: Show projects help
        When I successfully run `deform projects -h`
        Then the output should contain exactly:
            """
            Usage: deform projects [OPTIONS]

              Shows all projects available for user

            Options:
              -f, --filter JSON
              -h, --help         Show this message and exit.

            """

    Scenario: Run projects command
        Given I am logged in
        When I successfully run `deform projects`
        Then the output should contain available for user projects

    # Scenario: Run projects command with filter
    #     Given I am logged in
    #     When I successfully run `deform projects <argument_name> `
    #     Examples: Filter argument names
    #         | argument_name   |
    #         | -f              |
    #         | --filter        |
    #     Then the output should contain available for user projects
