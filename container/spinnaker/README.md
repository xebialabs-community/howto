# Manage your Pipelines using Spinnaker

Spinnaker is an open-source, multi-cloud continuous delivery platform originally developed by Netflix. It provides powerful deployment orchestration capabilities across cloud providers like AWS, Azure, Google Cloud, and Kubernetes. This integration enables Digital.ai Release to orchestrate Spinnaker pipelines as part of your broader release automation strategy, allowing you to combine Spinnaker's deployment strength with Release's comprehensive release orchestration, approvals, and governance features.

### Before you begin
This how-to involves working with a variety of tools, such as Digital.ai Release and Spinnaker. You can perform this task by following the instructions. However, being familiar with these tools and technologies can significantly help you when you try them out in your test environment.

### What's the objective?
The objective is to interact with Spinnaker pipelines from Digital.ai Release to trigger deployments, inspect pipeline configurations, and monitor execution status as part of your automated release process.

### What do you need?
* A Linux or Windows server (with root and Internet access) that has Digital.ai Release version 24.1.0 (or later) installed
* Remote runner setup for Digital.ai Release
* Spinnaker integration for Digital.ai Release

### What do you have?
* A running Spinnaker instance with Gate API accessible
* Spinnaker credentials

### How does it work?
The Spinnaker integration connects Digital.ai Release to Spinnaker's Gate API, allowing you to trigger pipelines, retrieve application and pipeline information, and monitor pipeline execution status from your release flows.

## Set up Spinnaker Configuration

1. From the navigation pane, under **CONFIGURATION**, click **Connections**.
2. Under **HTTP Server connections**, next to **Spinnaker: Server (Container)**, click the add button.
   The **New Spinnaker: Server (Container)** page opens.
3. In the **Title** field, enter the name of the configuration.
   This name will display in Spinnaker tasks.
4. In the **URL** field, enter the URL of the Spinnaker Gate API server (for example, `http://spin-gate:8084`).
5. In the **UI URL** field, enter the URL of the Spinnaker UI (for example, `http://spinnaker.example.com`).
6. Select the **Authentication method** to use when connecting to Spinnaker:
   * **Basic** — username and password authentication
7. If you selected **Basic** authentication, enter the **Username** and **Password** for your Spinnaker account.
8. To test the connection, click **Test**.
9. To save the configuration, click **Save**.

![Create Spinnaker Configuration](images/connection.png)

## Using Spinnaker Tasks in a Release Flow

Here's an example of how Spinnaker tasks fit into a typical release template. This workflow automates a phased deployment with validation:

### Example Release Flow: Multi-Environment Deployment

```
Release: Deploy Application v2.3.1
├── Phase: Pre-Deployment Validation
│   ├── Get Applications (Container)
│   │   └── Verify "my-app" exists in Spinnaker
│   └── Get Pipelines (Container)
│       └── List available pipelines for validation
│
├── Phase: Deploy to Staging
│   ├── Gate: Approval Task
│   │   └── Manual approval required
│   ├── Trigger Pipeline (Container)
│   │   ├── Application: my-app
│   │   ├── Pipeline Name: deploy-to-staging
│   │   ├── Parameters: {"environment": "staging", "version": "2.3.1"}
│   │   └── Wait For Completion: ✓
│   └── Script: Validate Deployment
│       └── Check health endpoints
│
├── Phase: Deploy to Production
│   ├── Gate: Approval Task
│   │   └── Production gate - requires 2 approvals
│   ├── Trigger Pipeline (Container)
│   │   ├── Application: my-app
│   │   ├── Pipeline Name: deploy-to-production
│   │   ├── Parameters: {"environment": "production", "version": "2.3.1"}
│   │   └── Wait For Completion: ✓
│   └── Notification Task
│       └── Send success notification
│
└── Phase: Monitoring
    └── Get Pipeline Status (Container)
        ├── Execution Id: ${deployTask.execution}
        └── Verify final status
```

![Spinnaker Release Template Example](images/spinnaker-release-template.png)

The screenshot above shows this workflow implemented as a Digital.ai Release template, demonstrating how all the Spinnaker tasks integrate seamlessly into a complete release automation flow.

**Real-World Scenario:**
In a typical enterprise release flow, you might:
1. Use **Get Applications** to validate that all required Spinnaker applications exist
2. Use **Get Pipeline Config** to verify pipeline configuration matches requirements
3. Use **Trigger Pipeline** with **Wait For Completion** for sequential deployments across environments
4. Add Digital.ai Release **Gates** between Spinnaker deployments for approval workflows
5. Use **Get Pipeline Status** in monitoring tasks or failure recovery scenarios

## Trigger Pipeline (Container)

The _Trigger Pipeline (Container)_ task triggers a Spinnaker pipeline for a given application and optionally waits for the pipeline execution to complete.

1. In the release flow tab of a Release template, add a task of type **Spinnaker** > **Trigger Pipeline (Container)**.
2. Click the added task to open it.
3. In the **Capabilities** field, enter a value that matches the capability set for your remote runner.
   This will help you to route jobs to that particular remote runner.
4. In the **Server** field, select the Spinnaker server configuration.
5. In the **Application** field, enter the name of the Spinnaker application.
6. In the **Pipeline Name** field, enter the name of the Spinnaker pipeline to trigger.
7. In the **Parameters** field, provide any key-value pairs to pass as pipeline parameters.
8. Switch on the **Wait For Completion** toggle if you want the task to wait until the pipeline execution finishes.
9. In the **Retry Wait Time** field, enter the number of seconds to wait between status check retries (default: 15).
10. In the **Max Retries** field, enter the maximum number of status check retries (default: 5).

**Output properties:**
* **execution** — the Spinnaker pipeline execution ID
* **executionStatus** — the final status of the pipeline execution

![Trigger Pipeline Container](images/trigger-pipeline.png)

## Get Applications (Container)

The _Get Applications (Container)_ task retrieves the list of all applications registered in Spinnaker.

1. In the release flow tab of a Release template, add a task of type **Spinnaker** > **Get Applications (Container)**.
2. Click the added task to open it.
3. In the **Capabilities** field, enter a value that matches the capability set for your remote runner.
   This will help you to route jobs to that particular remote runner.
4. In the **Server** field, select the Spinnaker server configuration.

**Output properties:**
* **applications** — the list of Spinnaker application names

![Get Applications Container](images/get-applications.png)

## Get Pipelines (Container)

The _Get Pipelines (Container)_ task retrieves all pipeline definitions for a given Spinnaker application.

1. In the release flow tab of a Release template, add a task of type **Spinnaker** > **Get Pipelines (Container)**.
2. Click the added task to open it.
3. In the **Capabilities** field, enter a value that matches the capability set for your remote runner.
   This will help you to route jobs to that particular remote runner.
4. In the **Server** field, select the Spinnaker server configuration.
5. In the **Application** field, enter the name of the Spinnaker application whose pipelines you want to retrieve.

**Output properties:**
* **pipelines** — the list of pipeline names for the specified application

![Get Pipelines Container](images/get-pipelines.png)

## Get Pipeline Config (Container)

The _Get Pipeline Config (Container)_ task retrieves the full configuration of a specific Spinnaker pipeline.

1. In the release flow tab of a Release template, add a task of type **Spinnaker** > **Get Pipeline Config (Container)**.
2. Click the added task to open it.
3. In the **Capabilities** field, enter a value that matches the capability set for your remote runner.
   This will help you to route jobs to that particular remote runner.
4. In the **Server** field, select the Spinnaker server configuration.
5. In the **Application** field, enter the name of the Spinnaker application.
6. In the **Pipeline Name** field, enter the name of the pipeline whose configuration you want to retrieve.

**Output properties:**
* **configuration** — the pipeline configuration as a JSON

![Get Pipeline Config Container](images/get-pipeline-config.png)

## Get Pipeline Status (Container)

The _Get Pipeline Status (Container)_ task retrieves the current execution status of a running or completed Spinnaker pipeline.

1. In the release flow tab of a Release template, add a task of type **Spinnaker** > **Get Pipeline Status (Container)**.
2. Click the added task to open it.
3. In the **Capabilities** field, enter a value that matches the capability set for your remote runner.
   This will help you to route jobs to that particular remote runner.
4. In the **Server** field, select the Spinnaker server configuration.
5. In the **Execution Id** field, enter the Spinnaker pipeline execution ID to check. You can reference the output of a **Trigger Pipeline** task here.

**Output properties:**
* **executionStatus** — the current status of the pipeline execution (for example, `RUNNING`, `SUCCEEDED`, `FAILED`)

![Get Pipeline Status Container](images/get-pipeline-status.png)
