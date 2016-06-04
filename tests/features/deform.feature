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
              collection       Collection manipulation commands
              collections      Collections manipulation commands
              current-project  Outputs a current project
              document         Document manipulation commands
              documents        Documents manipulation commands
              login            Authenticates against the API
              logout           Logs out current user
              project          Project manipulation commands
              projects         User's projects
              settings         CLI settings
              signup           Creates an account
              use-project      Sets a current project
              version          Outputs the client version
              whoami           Outputs the current user

            """
