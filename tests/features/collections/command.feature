Feature: deform collections

    Scenario: Show collections help
        When I successfully run `deform collections -h`
        Then the output should contain exactly:
            """
            Usage: deform collections [OPTIONS] COMMAND [ARGS]...

              Collections manipulation commands

            Options:
              -h, --help  Show this message and exit.

            Commands:
              count  Number of collections
              find   Find collections

            """
