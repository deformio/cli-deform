Feature: deform whoami

    Scenario: Running command with logged in user
        Given I am logged in
        When I successfully run `deform whoami`
        Then the output should contain logged in user information

    # Scenario: Running command with not logged in user
    #     When I run `deform whoami`
    #     Then the output should contain:
    #         """
    #         You are not logged in.
    #         """
