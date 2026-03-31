# Hands-On: Orchestrate Spinnaker CD Pipelines from Digital.ai Release

In this how-to you will create a sample application and pipelines in Spinnaker, import a ready-made Release template, and run a multi-environment CD workflow end-to-end — complete with approval gates, automated status checks, and notifications.

## What you will build

```
Digital.ai Release
│
├── Phase 1 — Pre-flight
│   ├── Get Applications      →  verify "my-app" exists in Spinnaker
│   └── Get Pipelines         →  verify "deploy-to-staging" and "deploy-to-production" exist
│
├── Phase 2 — Staging
│   ├── Approval Gate         →  manual sign-off
│   └── Trigger Pipeline      →  POST /pipelines/my-app/deploy-to-staging  (waits for SUCCEEDED)
│
├── Phase 3 — Production
│   ├── Approval Gate         →  manual sign-off (× 2)
│   ├── Get Pipeline Config   →  validate pipeline settings before running
│   └── Trigger Pipeline      →  POST /pipelines/my-app/deploy-to-production (waits for SUCCEEDED)
│
└── Phase 4 — Monitoring
    └── Get Pipeline Status   →  final spot-check on execution ID
```

## Before you begin

| What you need | Notes |
|---|---|
| Digital.ai Release 24.1.0+ with the Spinnaker (Container) plugin installed | See [plugin installation docs](https://docs.digital.ai/bundle/devops-release-version-24.1/page/release/how-to/plugin-installation.html) |
| Remote runner configured and running | See [remote runner setup](https://docs.digital.ai/bundle/devops-release-version-24.1/page/release/remote-runner/remote-runner-setup.html) |
| A running Spinnaker instance with Gate API reachable | See [Spinnaker installation guide](https://spinnaker.io/docs/setup/install/) |
| XL CLI (`xl`) 24.1.0+ | `xl version` |

---

## Step 1 — Configure the Spinnaker connection in Release

1. In Release, under **CONFIGURATION**, click **Connections**.
2. Next to **Spinnaker: Server (Container)**, click **+**.
3. Fill in the fields:

   | Field | Value |
   |---|---|
   | Title | `My Spinnaker Server` (must match the template) |
   | URL | Gate API URL — e.g. `http://spin-gate:8084` |
   | UI URL | Deck URL — e.g. `http://spinnaker.example.com` |
   | Authentication method | Basic |
   | Username | your Spinnaker username |
   | Password | your Spinnaker password |

4. Click **Test**, then **Save**.

![Spinnaker connection configuration](images/connection.png)

---

## Step 2 — Create a sample application and pipelines in Spinnaker

You need an application called `my-app` with two pipelines (`deploy-to-staging`, `deploy-to-production`) before the template can run. If you already have them, skip ahead.

### 2.1 Create the application

In the Spinnaker UI:

1. Click **Actions → Create Application**.
2. Set **Name** to `my-app` and fill in your email.
3. Click **Create**.

Or via the Gate API:

```bash
curl -u <user>:<pass> -X POST http://<gate-url>/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "job": [{
      "type": "createApplication",
      "application": {
        "name": "my-app",
        "description": "Demo app for Release integration",
        "email": "devops@example.com"
      }
    }],
    "application": "my-app",
    "description": "Create my-app"
  }'
```

### 2.2 Create the staging pipeline

In the Spinnaker UI for `my-app`:

1. Go to **Pipelines → Configure a new pipeline**.
2. Name it `deploy-to-staging`.
3. Add a **Wait** stage (10 seconds) — this simulates an actual deploy so the pipeline completes quickly.
4. Under **Pipeline Actions → Edit as JSON**, add parameters so Release can pass values through:

```json
"parameterConfig": [
  {"name": "environment", "default": "staging", "required": false},
  {"name": "version",     "default": "latest",  "required": false}
]
```

5. Save the pipeline.

Or via the Gate API:

```bash
curl -u <user>:<pass> -X POST http://<gate-url>/pipelines \
  -H "Content-Type: application/json" \
  -d '{
    "name": "deploy-to-staging",
    "application": "my-app",
    "stages": [
      {
        "type": "wait",
        "name": "Simulated Deploy",
        "waitTime": 10,
        "refId": "1",
        "requisiteStageRefIds": []
      }
    ],
    "parameterConfig": [
      {"name": "environment", "default": "staging"},
      {"name": "version",     "default": "latest"}
    ]
  }'
```

### 2.3 Create the production pipeline

Repeat 2.2 with the name `deploy-to-production`.

Confirm both pipelines appear at **my-app → Pipelines** in the Spinnaker UI.

---

## Step 3 — Import the demo Release template

The template file [spinnaker-demo-template.yaml](spinnaker-demo-template.yaml) in this folder contains the complete four-phase workflow and all required release variables.

### 3.1 Create your secrets file

```bash
cp secrets.xlvals.example secrets.xlvals
# Edit secrets.xlvals and replace the placeholder with your real Spinnaker password
```

`secrets.xlvals` is in `.gitignore` — never commit it.

### 3.2 Apply the template

```bash
xl apply -f spinnaker-demo-template.yaml \
  --values secrets.xlvals \
  --xl-release-url http://<release-url> \
  --xl-release-username admin \
  --xl-release-password <password>
```

In the Release UI go to **Design → Templates → Spinnaker Demo**. You should see the **Multi-Environment Deployment** template.

![Imported release template](images/spinnaker-release-template.png)

> **Before running:** open the template, go to **Settings**, and update the **My Spinnaker Server** connection reference to point to the connection you created in Step 1. Also verify the `url` and `uiurl` fields on the server CI match your environment.

---

## Step 4 — Run the template

### 4.1 Create a release

1. Open **Multi-Environment Deployment**.
2. Click **New release** and name it `my-app v2.3.1`.
3. Review the variables — update `appName`, `releaseVersion`, and region values if needed:

   | Variable | Default |
   |---|---|
   | `appName` | `my-app` |
   | `releaseVersion` | `2.3.1` |
   | `stagingRegion` | `us-west-2` |
   | `productionRegion` | `us-east-1` |

4. Click **Create**, then **Start release**.

### 4.2 Phase 1 — Pre-flight validation

The tasks in this phase run automatically in sequence.

**Get Applications** calls `GET /applications` and stores all application names in `${applicationsList}`.

![Get Applications task](images/get-applications.png)

The **Verify Application Exists** script then checks that `my-app` is in that list and fails fast if it isn't — catching misconfiguration before any deployment starts.

**Get Pipelines** calls `GET /applications/my-app/pipelines` and stores pipeline names in `${pipelinesList}`.

![Get Pipelines task](images/get-pipelines.png)

**Verify Pipelines Exist** checks that both `deploy-to-staging` and `deploy-to-production` are present.

Click any running task and open the **Log** tab to watch real-time output.

### 4.3 Phase 2 — Deploy to Staging

The **Staging Deployment Approval** gate pauses the release. Click it, then click **Complete** to approve.

**Trigger Staging Pipeline** posts to `POST /pipelines/my-app/deploy-to-staging` with the parameters `environment=staging` and `version=2.3.1`, then polls for completion. The execution ID is stored in `${stagingExecutionId}`.

![Trigger Pipeline task](images/trigger-pipeline.png)

Watch the pipeline run live in Spinnaker at `http://<spinnaker-ui>/#/applications/my-app/executions`.

Once Spinnaker reports `SUCCEEDED`, the Release script task validates the status and the phase finishes green.

### 4.4 Phase 3 — Deploy to Production

The **Production Deployment Approval** gate requires two sign-offs. Complete both conditions, then:

- **Get Pipeline Config** fetches the full production pipeline JSON and stores it in `${productionPipelineConfig}` so the next script can validate configuration before any changes go live.

  ![Get Pipeline Config task](images/get-pipeline-config.png)

- **Trigger Production Pipeline** fires `deploy-to-production` and waits for `SUCCEEDED`.

### 4.5 Phase 4 — Monitoring

**Get Pipeline Status** makes one final call to `GET /pipelines/{productionExecutionId}` to confirm the deployment is still `SUCCEEDED` after the monitoring window.

![Get Pipeline Status task](images/get-pipeline-status.png)

When all phases complete, the release status changes to **Completed**.

---

## How the tasks map to the Gate API

| Release task | Gate API call | Key output |
|---|---|---|
| Get Applications | `GET /applications` | `${applicationsList}` |
| Get Pipelines | `GET /applications/{app}/pipelines` | `${pipelinesList}` |
| Get Pipeline Config | `GET /applications/{app}/pipelineConfigs/{name}` | `${productionPipelineConfig}` |
| Trigger Pipeline | `POST /pipelines/{app}/{pipeline}` → polls `GET /pipelines/{id}` | `${*ExecutionId}`, `${*Status}` |
| Get Pipeline Status | `GET /pipelines/{executionId}` | `${finalProductionStatus}` |

---

## Troubleshooting

**Test connection fails**  
Verify the Gate URL is reachable from the Release server or remote runner network. If Release runs in a container, use the service hostname (`spin-gate`) rather than `localhost`.

**"Application not found" in Release script task**  
The application name in `my-app` variable must exactly match the Spinnaker application name (case-sensitive).

**Trigger Pipeline times out**  
Increase **Max Retries** on the task (each retry waits **Retry Wait Time** seconds). For a 10-second wait stage, the default 40 × 15 s = 600 s is more than enough.

**`xl apply` fails — "unknown type containerSpinnaker.Server"**  
The Spinnaker (Container) plugin is not installed in Release. Install it first, then re-apply.


