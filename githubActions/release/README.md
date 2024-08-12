# Create a release and initiate it using GitHub Actions

### Before you begin
This how-to involves working with a variety of tools, such as Digital.ai Release and GitHub Actions. You can perform this task by following the instructions. However, being familiar with these tools and technologies can significantly help you when you try them out in your test environment.

### What's the objective?
The objective is to automate the creation and initiation of a release in Digital.ai Release directly from your GitHub repository by using a GitHub Actions workflow.

### What do you need?
* A Linux or Windows server that has Digital.ai Release version 24.1.2 (or later) installed
* A GitHub account

### What do you have?
* A GitHub repository with action file

### How does it work?
* The GitHub Actions workflow is triggered by a push event to the repository.
* The workflow calls the Digital.ai Release API to create a release using a specified template.
* If the `startRelease` option is set to `true`, the workflow will also initiate the release automatically.


## Example Usage

```yaml
name: Create and Start Release

on: [push]

jobs:
  create-and-start-release:
    runs-on: ubuntu-latest
    steps:

      # Step 1: Use the Digital.ai Release GitHub Action to create and start a release
      - name: Create & Start Release
        id: release
        uses: digital-ai/github-actions-release@v1.0.0
        with:
          serverUrl: 'http://digital-ai-release-server-url:5516'
          username: ${{ secrets.RELEASE_USERNAME }}
          password: ${{ secrets.RELEASE_PASSWORD }}
          templateId: 'Applications/FolderXXXXXXXXX/ReleaseXXXXXXXXX'
          releaseTitle: 'New Release from GitHub Actions'
          variables: '{"var1": "value1", "var2": "value2"}'
          startRelease: 'true'

      # Step 2: Output the response from the release creation
      - name: Get Release Data
        run: echo ${{ steps.release.outputs.response }}

      # Step 3: Output the ID of the newly created release
      - name: Get Release Id
        run: echo ${{ steps.release.outputs.id }}

      # Step 4: Output the status of the newly created release
      - name: Get Release Status
        run: echo ${{ steps.release.outputs.status }}
 ```

## Inputs

| Name           | Description                                                                                                                                                                                                                              | Required | Default                          |
|----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|----------------------------------|
| `serverUrl`    | The address of the Digital.ai Release server.                                                                                                                                                                                            | Yes      | -                                |
| `username`     | Username for authentication to the Digital.ai Release server. Required if `token` is not provided.                                                                                                                                       | Yes*     | -                                |
| `password`     | Password for authentication to the Digital.ai Release server. Required if `token` is not provided.                                                                                                                                       | Yes*     | -                                |
| `token`        | Personal access token for authentication to the Digital.ai Release server. If provided, `username` and `password` are not required.                                                                                                      | Yes*     | -                                |
| `templateId`   | The full template identifier in Digital.ai Release is as follows: For example, `Applications/Folder3f5cf31df/Releasec4e4b7bce4` <br/>For more details, [click here](https://apidocs.digital.ai/xl-release/22.3.x/rest-docs/#identifiers) | Yes      | -                                |
| `releaseTitle` | Optional. Title of the release. If not provided, a default title will be assigned.                                                                                                                                                       | No       | GITHUB_TAG /<br/>GITHUB_HEAD_REF |
| `variables`    | Optional. JSON string representing the variables object to be passed to the release template.                                                                                                                                            | No       | -                                |
| `startRelease` | Optional. It indicating whether to start the release. Default is true.                                                                                                                                                                   | No       | true                             |

## Outputs

| Name       | Description                                                    |
|------------|----------------------------------------------------------------|
| `response` | The response containing the data of the newly created release. |
| `id`       | The id of the newly created release.                           |
| `status`   | The status of the newly created release.                       |