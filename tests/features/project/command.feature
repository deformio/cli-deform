Feature: deform project

    Scenario: Show command help
        When I successfully run `deform project -h`
        Then the output should contain exactly:
            """
            Usage: deform project [OPTIONS] COMMAND [ARGS]...

              Project manipulation commands

            Options:
              -h, --help  Show this message and exit.

            Commands:
              create  Creates project
              get     Returns project's data
              save    Saves project

            """
