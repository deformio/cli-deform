Feature: deform collection

    Scenario: Show collection help
        When I successfully run `deform collection -h`
        Then the output should contain exactly:
            """
            Usage: deform collection [OPTIONS] COMMAND [ARGS]...

              Collection manipulation commands

            Options:
              -h, --help  Show this message and exit.

            Commands:
              create  Creates a collection
              get     Returns a collection
              remove  Removes a collection
              save    Saves a collection
              update  Updates a collection

            """
