# ArgoCD Continuous Delivery Templates

Use the templates to setup Continuous Delivery to Kubernetes using DAI Release and ArgoCD. Add your own flavours of Approval flows and Security scans.

![argocd](images/argocd-continuous-delivery.PNG)

###Prerequisites
1. Two git repositories, one with source code and other with kubernetes manifest files for deployment
1. Kubernetes cluster with ArgoCD setup (https://minikube.sigs.k8s.io/docs/start/ | https://argo-cd.readthedocs.io/en/stable/getting_started/)
1. DAI Release with these three plugins installed
    * xlr-argocd-integration
	* xlr-github-plugin | xlr-gitlab-plugin | xlr-bitbucket-plugin
	* xlr-kubernetes-plugin
1. Setup connections in Release for Argo CD and Github|Gitlab|Bitbucket
1. Import templates from this repository into Release

## Initial Application Setup in Argo

Use this template to setup your application in Argo CD for the first time. 

The template contains tasks to
1. Add a repository connection to ArgoCd
1. Create a project in ArgoCD
1. Create an ArgoCD Application
1. Sync the created application (in Kubernetes to the definition in Git)
1. Get the Sync Status

When you run the release, the template is going to ask you for few inputs like the url of Git Repository containing the manifests, the path of the Manifest file in the repository, Application Name and Project Name. Enter these values and start the Release. The application will be setup in Argo in no time.

## Continuous Delivery

Use this template to setup a continuous delivery to the target kubernetes environment. 

![argocd](images/argocd-continuous-delivery-2.PNG)

### Simple continuous build setup
Configure Github actions or a Jenkins job to perform the following actions whenever there is a change detected in the source code repository
1. Checkout, clean, test and build the source code
1. Build a docker image, give the image a distinct tag like the commit hash, and push it to the central registry
1. Trigger the Continuous Delivery release template 
	* using xl apply for github actions
	* using Release plugin for Jenkins 
1. The template asks for inputs like the new image tag to deploy, the url of the git repository containing manifest and the path of the manifest files in the repository
1. Setup Github actions or the Jenkins job to pass these values when the template is triggered

The template contains tasks to
1. Create a revision branch in the repository with manifest files
1. Clone the revision branch locally
1. Update the new image in the kubernetes manifest file
1. Commmit and push the change
1. Create a pull request
1. Appove the pull request
1. Merge the pull request
1. Sync the application 
1. Get the Sync Status 

Now, whenever a change pushed is pushed to the source code repository, the code is tested, built, wrapped as a docker image and deployed to the target kubernetes environment.

## Environment Promotion

This template is similar to the Continuous Delivery template. The difference is that instead of a continuous build triggering this template, this template is triggered manually with a specific image version, instead of being triggered continuously.

The path of the manifest file to be updated determines the environment to which the image is promoted. 

Enter the input values when prompted and start the Release. The image will be promoted to the specified environment.


