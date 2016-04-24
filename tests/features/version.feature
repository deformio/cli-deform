Feature: deform version

    Scenario: Show version help
        When I successfully run `deform version -h`
        Then the output should contain exactly:
            """
            Usage: deform version [OPTIONS]

              Outputs the client version

            Options:
              -h, --help  Show this message and exit.

            """

    Scenario: Run version command
        When I successfully run `deform version`
        Then the output should contain current cli-deform version
