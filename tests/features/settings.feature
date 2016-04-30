Feature: deform settings

    Scenario: Settings help
        When I successfully run `deform settings -h`
        Then the output should contain exactly:
            """
            Usage: deform settings [OPTIONS] COMMAND [ARGS]...

              CLI settings

            Options:
              -h, --help  Show this message and exit.

            Commands:
              change  Change settings
              show    Show settings

            """

    Scenario: Settings show help
        When I successfully run `deform settings show -h`
        Then the output should contain exactly:
            """
            Usage: deform settings show [OPTIONS]

              Show settings

            Options:
              --pretty
              -h, --help  Show this message and exit.

            """

    Scenario: Show default settings
        When I successfully run `deform settings show`
        Then the output should contain exactly:
            """
            {"api": {"host": "deform.io"}}

            """

    Scenario: Show settings with pretty
        When I successfully run `deform settings show --pretty`
        Then the output should contain exactly:
            """
            {
                "api": {
                    "host": "deform.io"
                }
            }

            """

    Scenario: Settings change help
        When I successfully run `deform settings change -h`
        Then the output should contain exactly:
            """
            Usage: deform settings change [OPTIONS]

              Change settings

            Options:
              --api-host TEXT
              --api-port INTEGER
              --api-secure BOOLEAN
              --api-request-defaults JSON
              -h, --help                   Show this message and exit.

            """

    Scenario: Settings change host
        When I successfully run `deform settings change --api-host newhost.io`
        And I successfully run `deform settings show --pretty`
        Then the output should contain exactly:
            """
            {
                "api": {
                    "host": "newhost.io"
                }
            }

            """

    Scenario: Settings change port
        When I successfully run `deform settings change --api-port 99`
        And I successfully run `deform settings show --pretty`
        Then the output should contain exactly:
            """
            {
                "api": {
                    "host": "deform.io",
                    "port": 99
                }
            }

            """

    Scenario: Settings change secure
        When I successfully run `deform settings change --api-secure false`
        And I successfully run `deform settings show --pretty`
        Then the output should contain exactly:
            """
            {
                "api": {
                    "host": "deform.io",
                    "secure": false
                }
            }

            """

    Scenario: Settings change request defaults
        When I successfully run `deform settings change --api-request-defaults '{"verify":false}'`
        And I successfully run `deform settings show --pretty`
        Then the output should contain exactly:
            """
            {
                "api": {
                    "host": "deform.io",
                    "request_defaults": {
                        "verify": false
                    }
                }
            }

            """

    Scenario: Settings change reseting request defaults
        When I successfully run `deform settings change --api-request-defaults '{"verify":false}'`
        And I successfully run `deform settings change --api-request-defaults '{}'`
        And I successfully run `deform settings show --pretty`
        Then the output should contain exactly:
            """
            {
                "api": {
                    "host": "deform.io",
                    "request_defaults": {}
                }
            }

            """
