Feature: deform projects

    Scenario: Show projects help
        When I successfully run `deform projects -h`
        Then the output should contain exactly:
            """
            Usage: deform projects [OPTIONS] COMMAND [ARGS]...

              User's projects

            Options:
              -h, --help  Show this message and exit.

            Commands:
              count  Number of projects available for user
              find   Find projects available for user

            """
