# ArgoRollout using Release, EKS and Linkerd

Use the templates and manifests to perform bluegreen and canary deployments.


## Prerequisites

1. Kubernetes cluster (EKS Workshop - https://www.eksworkshop.com/) 
2. AWS Load Balancer Controller (https://www.eksworkshop.com/beginner/180_fargate/prerequisites-for-alb/)
3. Linkerd (https://linkerd.io/2.11/getting-started/)
4. Argo rollouts setup in the EKS cluster(https://argoproj.github.io/argo-rollouts/) and argo rollouts kubectl plugin installed in a Unix host.
5. DAI Release with xlr-argo-rollouts-integration installed

## Initial Canary Rollout Setup in K8s

1. kubectl create namespace guestbook-canary
   <br/>&rarr; creates a namespace 'guestbook-canary'
1. kubectl apply -f https://raw.githubusercontent.com/xebialabs-community/howto/master/argoRollouts/manifests/guestbook-canary-service.yaml -n guestbook-canary
   <br/>&rarr; creates two services 'guestbook-stable' and 'guestbook-canary'
1. kubectl apply -f https://raw.githubusercontent.com/xebialabs-community/howto/master/argoRollouts/manifests/guestbook-canary-rollout.yaml -n guestbook-canary
   <br/>&rarr; creates a rollout with canary strategy, replica set of 5 pods with image guestbook:blue
1. kubectl apply -f https://raw.githubusercontent.com/xebialabs-community/howto/master/argoRollouts/manifests/redis.yaml -n guestbook-canary
   <br/>&rarr; creates a redis pod and service
1. linkerd viz dashboard &
   <br/>&rarr; dashboard shows the pods and trafic split between the two services, canary and stable under the guestbook-canary namespace
1. kubectl get service guestbook-stable -n guestbook-canary
   <br/>&rarr; to view the application in browser <external-ip>:8080/index.html

## Update Canary Rollout with a new Image Manually

1. kubectl argo rollouts set image guestbook-canary-rollout guestbook-container=xldevdocker/guestbook:green -n guestbook-canary
   <br/>&rarr; updates 20% of pods in guestbook-canary-rollout with new image
1. check the linkerd dashboard for trafic split to reflect 20(weight of first step) in the canary service
1. kubectl argo rollouts promote guestbook-canary-rollout -n guestbook-canary
   <br/>&rarr; executes the rest of the update steps
1. kubectl argo rollouts promote guestbook-canary-rollout -n guestbook-canary
   <br/>&rarr; updates the final set of pods with the new image
   
## Rollout new revisions using Canary

1. In Release, create Unix host connection. Specify a host which has the following
    * kubectl installed and confiured to connect to the desired cluster
    * kubectl argo rollouts plugin installed
1. Create Kubectl Argo Rollouts connection and specify the kubectl path, namespace as guestbook-canary and other fields or if required. 
   <br/>System defaults from the unix host will be picked where not specified.
1. Import the template for Canary deployment from [here](https://github.com/xebialabs-community/howto/raw/master/argoRollouts/templates/Argo%20Rollouts_%20Canary%20Deployment.xlr)
1. Create the following global variables in Release
    * canary.rollout-name - guestbook-canary-rollout
    * canary.container-name- guestbook-container
    * canary.current-image - xldevdocker/guestbook:blue
1. Make sure that the rollout tasks in the template have the 'Rollout Config' and 'Host' selected.
1. To update a new image, create New Release, specify the new image xldevdocker/guestbook:green and start it. 
1. Assign and complete manual tasks where required. Choose to promote or abort rollout as desired.

## Initial BlueGreen Rollout Setup in K8s

1. kubectl create namespace guestbook-bluegreen
   <br/>&rarr; creates a namespace 'guestbook-bluegreen'
1. kubectl apply -f https://raw.githubusercontent.com/xebialabs-community/howto/master/argoRollouts/manifests/guestbook-bluegreen-service.yaml -n guestbook-bluegreen
   <br/>&rarr; creates two services 'guestbook-bluegreen-active' and 'guestbook-bluegreen-preview'
1. kubectl apply -f https://raw.githubusercontent.com/xebialabs-community/howto/master/argoRollouts/manifests/guestbook-bluegreen-rollout.yaml -n guestbook-bluegreen
   <br/>&rarr; creates a rollout with bluegreen strategy, replica set of 2 pods with image guestbook:blue
1. kubectl apply -f https://raw.githubusercontent.com/xebialabs-community/howto/master/argoRollouts/manifests/redis.yaml -n guestbook-bluegreen
   <br/>&rarr; creates a redis pod and service
1. linkerd viz dashboard &
   <br/>&rarr; dashboard shows the pods created
1. kubectl get service guestbook-bluegreen-active -n guestbook-bluegreen
   <br/>&rarr; to view the application in browser <external-ip>:8080/index.html

## Update BlueGreen Rollout with a new Image Manually

1. kubectl argo rollouts set image guestbook-bluegreen-rollout guestbook-container=xldevdocker/guestbook:green -n guestbook-bluegreen
   <br/>&rarr; Creates pods with the new image and exposes the application through the preview service
1. kubectl get service guestbook-bluegreen-preview -n guestbook-blue
   <br/>&rarr; to view the preview service application in browser <external-ip>:8080/index.html
1. kubectl argo rollouts promote guestbook-bluegreen-rollout -n guestbook-bluegreen
   <br/>&rarr; promotes the preview service to live and terminates the old pods
1. kubectl get service guestbook-bluegreen-active -n guestbook-bluegreen
   <br/>&rarr; to view the application in browser <external-ip>:8080/index.html

## Rollout new revisions using BlueGreen

This is pretty similar to the canary template
1. In Release, create Unix host connection. Specify a host which has the following
    * kubectl installed and confiured to connect to the desired cluster
    * kubectl argo rollouts plugin installed
1. Create Kubectl Argo Rollouts connection and specify the kubectl path, namespace as guestbook-bluegreen and other fields or if required. 
   <br/>System defaults from the unix host will be picked where not specified.
1. Import the template for BlueGreen deployment found  [here](https://github.com/xebialabs-community/howto/raw/master/argoRollouts/templates/Argo%20Rollouts_%20BlueGreen%20Deployment.xlr)
1. Create the following global variables in Release
    * bluegreen.rollout-name - guestbook-canary-rollout
    * bluegreen.container-name- guestbook-container
    * bluegreen.current-image - xldevdocker/guestbook:blue
1. Make sure that the rollout tasks in the template have the 'Rollout Config' and 'Host' selected.
1. To update a new image, create New Release, specify the new image xldevdocker/guestbook:green and start it. 
1. Assign and complete manual tasks where required. Choose to promote or abort rollout as desired.
