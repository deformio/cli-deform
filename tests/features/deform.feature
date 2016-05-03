Feature: deform without parameters

    Scenario: Runs CLI without parameters
        When I successfully run `deform`
        Then the output should contain exactly:
            """
            Usage: deform [OPTIONS] COMMAND [ARGS]...

              Command-line client for Deform.io

            Options:
              -h, --help  Show this message and exit.

            Commands:
              collection   Collection manipulation commands
              login        Authenticates against the API
              project      Project manipulation commands
              projects     User's projects
              settings     CLI settings
              use-project  Sets a current project
              version      Outputs the client version
              whoami       Outputs the current user

            """
