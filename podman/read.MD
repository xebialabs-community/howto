---
title: How to use the Podman plugin
product:
- deploy
category:
- Plugins and integrations
subject:
- Cloud and container plugins
tags:
- podman
- plugin
order: 1300
---

## Deploy a podman Container

1. Create an [application](/deploy/how-to/add-a-package-to-xl-deploy.html#create-a-package) and a deployment package.
2. Hover over the deployment package, click ![Explorer action menu](../../images/menu_three_dots.png) > **New**, and then select `podman.ContainerSpec`.
3. Hover over the deployment package containing the new `podman.ContainerSpec`, click ![Explorer action menu](../../images/menu_three_dots.png) > **Deploy**, and select the target environment.
4. Click **Continue** and then click **Deploy** to execute the plan.

**Sample Manifest**
```bash
<?xml version="1.0" encoding="UTF-8"?>
<udm.DeploymentPackage version="1.0" application="Test-Container-Spec">
    <application />
    <orchestrator />
    <deployables>
        <podman.ContainerSpec name="/newcont">
            <tags />
            <containerName>sample-newcontainer2505</containerName>
            <image>docker.io/library/tomcat:latest</image>
            <labels />
            <environment />
            <showLogsAfter>1</showLogsAfter>
            <networks />
            <dnsOptions />
            <links />
            <portBindings />
            <volumeBindings />
        </podman.ContainerSpec>
    </deployables>
    <applicationDependencies />
    <dependencyResolution>LATEST</dependencyResolution>
    <undeployDependencies>false</undeployDependencies>
    <templates />
    <boundTemplates />
</udm.DeploymentPackage>
```

## Deploy a podman Pod

1. Create an [application](/deploy/how-to/add-a-package-to-xl-deploy.html#create-a-package) and a deployment package.
2. Hover over the deployment package, click ![Explorer action menu](../../images/menu_three_dots.png) > **New**, and then select `podman.Service`.
3. Hover over the deployment package containing the new `podman.Pod`, click ![Explorer action menu](../../images/menu_three_dots.png) > **Deploy**.
4. Click **Continue** and then click **Deploy** to execute the plan.

**Sample Manifest**
```bash
<?xml version="1.0" encoding="UTF-8"?>
<udm.DeploymentPackage version="1.0" application="Test-Pod-Spec">
    <application />
    <orchestrator />
    <deployables>
        <podman.PodSpec name="/newpod">
            <tags />
            <PodName>sample-newpod2505</PodName>
            <labels />
            <cpu_period>1</cpu_period>
            <cpu_quota>1</cpu_quota>
            <infra_command />
            <no_infra>true</no_infra>
            <no_manage_hosts>true</no_manage_hosts>
            <start_pod>false</start_pod>
            <pod_create_command />
            <pod_devices />
            <portmappings />
        </podman.PodSpec>
    </deployables>
    <applicationDependencies />
    <dependencyResolution>LATEST</dependencyResolution>
    <undeployDependencies>false</undeployDependencies>
    <templates />
    <boundTemplates />
</udm.DeploymentPackage>
```
> **Note**: You can deploy a podman Pod.

## Deploy a Podman Volume

### Create an independent volume

1. Create an [application](/deploy/how-to/add-a-package-to-xl-deploy.html#create-a-package) and a deployment package.
2. Hover over the deployment package, click ![Explorer action menu](../../images/menu_three_dots.png) > **New**, and then select `podman.VolumeSpec`.
3. Enter a name for the service in the **Name** field and specify a **Volume Name** for the volume.
4. Hover over the deployment package containing the new `podman.VolumeSpec`, click ![Explorer action menu](../../images/menu_three_dots.png) > **Deploy** and select the target environment.
5. Click **Continue** and then click **Deploy** to execute the plan.
6. To check if the volume is created, run this command:
    ```bash
    podman volume ls
    ```
**Sample Manifest**
```bash
<?xml version="1.0" encoding="UTF-8"?>
<udm.DeploymentPackage version="1.0" application="Test-Volume-Spec">
    <application />
    <orchestrator />
    <deployables>
        <podman.VolumeSpec name="/newvol">
            <tags />
            <volumeName>sample-newvol2505</volumeName>
            <driver>local</driver>
            <driverOptions />
            <labels />
        </podman.VolumeSpec>
    </deployables>
    <applicationDependencies />
    <dependencyResolution>LATEST</dependencyResolution>
    <undeployDependencies>false</undeployDependencies>
    <templates />
    <boundTemplates />
</udm.DeploymentPackage>
```

### Attach a volume to a Podman container

1. Hover over the created container, click ![Explorer action menu](../../images/menu_three_dots.png) > **New**, and then select **MountedVolumeSpec**.
2. Enter a name for the application version, specify a name for the volume, enter the directory of the Podman container where the volume will be attached in the **Mountpoint** field, and set the default value to *false* in the **Read Only** field.
3. [Deploy](/deploy/how-to/deploy-an-application.html) the created package to the target environment.

The Podman container is created with the mounted volume attached at the mount point.

## Create a Podman Network

1. Create an [application](/deploy/how-to/add-a-package-to-xl-deploy.html#create-a-package) and a deployment package.
2. Hover over the deployment package, click ![Explorer action menu](../../images/menu_three_dots.png) > **New**, and then select `podman.NetworkSpec`. Perform the same action again to create a `podman.ContainerSpec`.
3. In the **Network Name** field, specify the name of the private network that will be created.
4. Click **Save** to create the network.
5. For the created container, go to the **Network** tab and add the name of the network, which will bind the    
containers.
6. [Deploy](/deploy/how-to/deploy-an-application.html) the application to the target environment.
7. Log in to your Podman host and run this command:
    ```bash
    podman network inspect <network_name>
    ```
8. To verify if the network is created with the Podman host, run this command:
    ```bash
    podman network ls
    ```
**Sample Manifest**
```bash
<?xml version="1.0" encoding="UTF-8"?>
<udm.DeploymentPackage version="1.0" application="Test-Network-Spec">
    <application />
    <orchestrator />
    <deployables>
        <podman.NetworkSpec name="/netspec">
            <tags />
            <networkName>sample-newnet2505</networkName>
            <driver>bridge</driver>
            <networkOptions />
        </podman.NetworkSpec>
    </deployables>
    <applicationDependencies />
    <dependencyResolution>LATEST</dependencyResolution>
    <undeployDependencies>false</undeployDependencies>
    <templates />
    <boundTemplates />
</udm.DeploymentPackage>
```

## Map a Podman container port to a Podman host

Port mapping is used to map the host port with the container port.

### Create a port mapper

1. Create a container inside an application with a deployment package.
2. Hover over the created container, click ![Explorer action menu](../../images/menu_three_dots.png) > **New**, and then select **PortSpec**.
3. Enter a name for the application version.
4. In the **Host Port** field, enter the port of the Podman host that will be mapped to the container, the container port, and specify the protocol over which the connection will be established.
5. [Deploy](/deploy/how-to/deploy-an-application.html) the application to the target environment.
6. Log in to your podman host and run this command:
    ```bash
    podman network inspect <network_name>
    ```
7. To verify if the network is created with the podman host, run this command:
    ```bash
    podman network ls
    ```

## Create a podman secret

1. Create an [application](/deploy/how-to/add-a-package-to-xl-deploy.html#create-a-package) and a deployment package.
2. Hover over the deployment package, click ![Explorer action menu](../../images/menu_three_dots.png) > **New**, and then select `podman.SecretSpec`.
3. Enter a name for the service in the **Name** field and specify a **Secret Name** for the Secret.
4. Specify a **Secret** for the Secret value which needs to be stored.
5. Specify a **Driver** for the Secret if required.
6. Hover over the deployment package containing the new `podman.SecretSpec`, click ![Explorer action menu](../../images/menu_three_dots.png) > **Deploy** and select the target environment.
7. Click **Continue** and then click **Deploy** to execute the plan.
8. To check if the secret is created, run this command:
    ```
    podman secret ls
    ```

**Sample Manifest**
```bash
<?xml version="1.0" encoding="UTF-8"?>
<udm.DeploymentPackage version="1.0" application="podapp">
  <application />
  <orchestrator />
  <deployables>
    <podman.SecretSpec name="/secretspec">
      <tags />
      <secretName>secretname</secretName>
      <driver>file</driver>
      <secret>secretvalue</secret>
    </podman.SecretSpec>
  </deployables>
  <applicationDependencies />
  <dependencyResolution>LATEST</dependencyResolution>
  <undeployDependencies>false</undeployDependencies>
  <templates />
  <boundTemplates />
</udm.DeploymentPackage>
```

## Deploy a File to Container in Podman

1. Create an [application](/deploy/how-to/add-a-package-to-xl-deploy.html#create-a-package) and a deployment package.
2. Hover over the deployment package, click ![Explorer action menu](../../images/menu_three_dots.png) > **New**, and then select `podman.File`. Perform the same action again to create a `podman.File`.
3. In the **Name** field, specify the name of the CI that will be created.
4. In the **Choose file**, specify the file location.
5. In the **Target Container**, Specify the Target Container ID.
6. In the **Target Path**, Specify the Target Path inside the Container.
7. Click **Save** to create `podman.File`.
8. [Deploy](/deploy/how-to/deploy-an-application.html) the application to the target environment.
9. To verify if the file is created with the Podman host, go inside the container with bash and verify the file.

**Sample Manifest**
```bash
<?xml version="1.0" encoding="UTF-8"?>
<udm.DeploymentPackage version="1.0" application="podapp">
  <application />
  <orchestrator />
  <deployables>
    <podman.File name="/filetype" file="/filetype/wls-issue.docx">
      <tags />
      <scanPlaceholders>true</scanPlaceholders>
      <preScannedPlaceholders>false</preScannedPlaceholders>
      <placeholders />
      <checksum>225ced63f77e38e436c7c595fbdbc882be239580f892a3cbdf29f1d12b11b0ef</checksum>
      <fileEncodings>
        <entry key=".+\.properties">ISO-8859-1</entry>
      </fileEncodings>
      <isRescanned>false</isRescanned>
      <targetContainer>conatinerId</targetContainer>
      <targetPath>/tmp</targetPath>
    </podman.File>
  </deployables>
  <applicationDependencies />
  <dependencyResolution>LATEST</dependencyResolution>
  <undeployDependencies>false</undeployDependencies>
  <templates />
  <boundTemplates />
</udm.DeploymentPackage>
```

## Deploy a Folder to Container in Podman

1. Create an [application](/deploy/how-to/add-a-package-to-xl-deploy.html#create-a-package) and a deployment package.
2. Hover over the deployment package, click ![Explorer action menu](../../images/menu_three_dots.png) > **New**, and then select `podman.Folder`. Perform the same action again to create a `podman.Folder`.
3. In the **Name** field, specify the name of the CI that will be created.
4. In the **Choose file**, specify the folder location (Folder should be Zipped and uploaded as a File).
5. In the **Target Container**, Specify the Target Container ID.
6. In the **Target Path**, Specify the Target Path inside the Container.
7. Click **Save** to create `podman.Folder`.
8. [Deploy](/deploy/how-to/deploy-an-application.html) the application to the target environment.
9. To verify if the foler is created with the Podman host, go inside the container with bash and verify the folder.

**Sample Manifest**
```bash
<?xml version="1.0" encoding="UTF-8"?>
<udm.DeploymentPackage version="1.0" application="podapp">
  <application />
  <orchestrator />
  <deployables>
    <podman.Folder name="/folderfile" file="/folderfile/podapp-1.0 (5).zip">
      <tags />
      <scanPlaceholders>true</scanPlaceholders>
      <preScannedPlaceholders>false</preScannedPlaceholders>
      <placeholders />
      <checksum>5e7cc41f1f5068f967f70a41ba19d1b9618eecaf778a46fb948a0b4e197bc7f9</checksum>
      <fileEncodings>
        <entry key=".+\.properties">ISO-8859-1</entry>
      </fileEncodings>
      <isRescanned>false</isRescanned>
      <targetContainer>containerID</targetContainer>
      <targetPath>/tmp</targetPath>
    </podman.Folder>
  </deployables>
  <applicationDependencies />
  <dependencyResolution>LATEST</dependencyResolution>
  <undeployDependencies>false</undeployDependencies>
  <templates />
  <boundTemplates />
</udm.DeploymentPackage>
```
