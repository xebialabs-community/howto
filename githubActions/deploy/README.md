# Create, Publish, and Deploy the Package Using GitHub Actions

### Before you begin
This how-to involves working with a variety of tools, such as Digital.ai Deploy and GitHub Actions. You can perform this task by following the instructions. However, being familiar with these tools and technologies can significantly help you when you try them out in your test environment.

### What's the objective?
The objective is to automate the creation, publishing, and deployment of packages in Digital.ai Deploy directly from your GitHub repository by using a GitHub Actions workflow.

### What do you need?
* A Linux or Windows server that has Digital.ai Deploy version 24.1.2 (or later) installed
* A GitHub account

### What do you have?
* A GitHub repository with action file

### How does it work?
* The GitHub Actions workflow is triggered by a push event to the repository.
* The workflow steps :
    1. **Creating the Package**: The action creates a DAR (Deployable Archive) package using the specified manifest file.
    2. **Publishing the Package**: The created package is then published to the Digital.ai Deploy server.
    3. **Deploying the Package**: Finally, the published package is deployed to the specified environment in Digital.ai Deploy.


## Example Usage

```yaml
name: Build and Deploy Package

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:

      - name: Create Publish and Deploy Package
        id: deploy
        uses: digital-ai/github-actions-deploy@v1.0.0
        with:
          serverUrl: 'http://digital-ai-deploy-server-url:4516'
          username: ${{ secrets.USERNAME }}
          password: ${{ secrets.PASSWORD }}
          manifestPath: '/deployit-manifest.xml'
          action: 'create_publish_deploy'
          outputPath: '/outputdar'
          versionNumber: ${{ vars.VERSIONNUMBER }}
          packageName: 'appForAction-1.0.dar'
          environmentId: 'Environments/envForAction'
          rollback: 'yes'
 ```

## Inputs

| Name             | Description                                                                                                                                                                   | Required | Default                 |
|------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|-------------------------|
| `serverUrl`      | The URL of the Digital.ai Deploy server.                                                                                                                                      | Yes      |                         |
| `username`       | The username for authenticating with Digital.ai Deploy.                                                                                                                       | Yes      |                         |
| `password`       | The password for authenticating with Digital.ai Deploy.                                                                                                                       | Yes      |                         |
| `action`         | Action to perform: create, publish, deploy. <br/>Supported actions are:<br/>`create_publish`, `publish_deploy`, `create_publish_deploy`.                                      | No       | `create_publish_deploy` |
| `manifestPath`   | The path to the deployit-manifest.xml file. <br/> It is mandatory for the `create_publish`, `create_publish_deploy` action. <br/>Example: `/deployit-manifest.xml`            | Yes      |                         |
| `outputPath`     | The path for storing the newly created DAR package. <br/> It is mandatory for the `create_publish`, `create_publish_deploy` action. <br/>Example: `/outputdar`                | Yes      |                         |
| `packageName`    | Optional. The name of the newly created DAR package. <br/>Example: `appForAction-1.0.dar`                                                                                     | No       | `package.dar`           |
| `versionNumber`  | Optional. Specify a version number to set in your manifest file.  <br/>Example: `1.0`                                                                                         | No       |                         |
| `darPackagePath` | The path to the DAR package. <br/> It is mandatory for the `publish_deploy` action. <br/>Example: `/dar/appForAction-1.0.dar`                                                 | Yes*     |                         |
| `environmentId`  | ID of the target environment in Digital.ai Deploy. <br/> It is mandatory for the `publish_deploy`, `create_publish_deploy` action. <br/> Example: `Environments/envForAction` | Yes*     |                         |
| `rollback`       | Optional. Invoke a rollback in case of deployment failure. <br/> Example: `true`                                                                                              | no       | `false`                 |