Feature: deform without parameters

    Scenario: Runs CLI without parameters
        When I successfully run `deform`
        Then the output should contain exactly:
            """
            Usage: deform [OPTIONS] COMMAND [ARGS]...

              Command line client for Deform.io

            Options:
              -h, --help  Show this message and exit.

            Commands:
              active-project  Current project
              collections     List of the collections in the project
              documents       List of the documents in the collection
              login           Authenticates against the API
              project         Project info
              projects        List of the projects of the user
              sessions        List of the sessions (logins)
            """
