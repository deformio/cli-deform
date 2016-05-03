Feature: deform projects count

    # Scenario: Show command help
    #     When I successfully run `deform collection get -h`
    #     Then the output should contain exactly:
    #         """
    #         Usage: deform collection get [OPTIONS] COLLECTION_ID
    #
    #           Returns a collection
    #
    #         Options:
    #           -h, --help  Show this message and exit.
    #
    #         """
    #
    # Scenario: Running command without collection identity argument
    #     When I run `deform collection get`
    #     Then the exit status should be 2
    #     Then the output should contain exactly:
    #         """
    #         Usage: deform collection get [OPTIONS] COLLECTION_ID
    #
    #         Error: Missing argument "collection_id".
    #
    #         """
    #
    # Scenario: Running command with not logged in user
    #     When I run `deform collection get 100`
    #     Then I should be asked to login first
    #
    # Scenario: Running command without current project
    #     Given I am logged in
    #     When I run `deform collection get 100`
    #     Then I should be asked to set current project
    #
    # Scenario: Running command with not existing collection
    #     Given I am logged in
    #     Given I use a current user's project
    #     When I run `deform collection get not-existing-collection`
    #     Then the exit status should be 1
    #     And the stderr should contain exactly:
    #         """
    #         Collection not found.
    #
    #         """

    # Scenario: Running command with existing collection
    #     Given I am logged in
    #     Given I use a current user's project
    #     When I successfully run `deform collection get _files`
    #     Then the stdout should contain exactly:
    #         """
    #         Sosisa
    #
    #         """
