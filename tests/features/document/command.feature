Feature: deform document

    Scenario: Show command help
        When I successfully run `deform document -h`
        Then the output should contain exactly:
            """
            Usage: deform document [OPTIONS] COMMAND [ARGS]...

              Document manipulation commands

            Options:
              -h, --help  Show this message and exit.

            Commands:
              create    Creates a document
              get       Returns a document
              get-file  Returns a file content
              remove    Removes a document
              save      Saves a document
              update    Updates a document

            """
