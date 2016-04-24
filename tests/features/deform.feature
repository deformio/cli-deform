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
              login     Authenticates against the API
              projects  Shows all projects available for user
              settings  CLI settings
              version   Outputs the client version
              whoami    Outputs the current user

            """
