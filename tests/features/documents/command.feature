Feature: deform documents

    Scenario: Show command help
        When I successfully run `deform documents -h`
        Then the output should contain exactly:
            """
            Usage: deform documents [OPTIONS] COMMAND [ARGS]...

              Documents manipulation commands

            Options:
              -h, --help  Show this message and exit.

            Commands:
              count   Number of documents
              find    Find documents
              remove  Removes documents
              update  Update documents
              upsert  Update or insert document

            """
