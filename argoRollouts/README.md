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
   creates a namespace 'guestbook-canary'
1. kubectl apply -f guestbook-canary-service.yaml -n guestbook-canary
   creates two services 'guestbook-stable' and 'guestbook-canary'
1. kubectl apply -f guestbook-canary-rollout.yaml -n guestbook-canary
   creates a rollout with canary strategy, replica set of 5 pods with image guestbook:blue
1. kubectl apply -f redis.yaml -n guestbook-canary
   creates a redis pod and service
1. linkerd viz dashboard &
   dashboard shows the pods and trafic split between the two services, canary and stable under the guestbook-canary namespace
1. kubectl get service guestbook-stable -n guestbook-canary
   to view the application in browser <external-ip>:8080/index.html

## Update Canary Rollout with a new Image

1. kubectl argo rollouts set image guestbook-canary-rollout guestbook-container=xldevdocker/guestbook:green -n guestbook-canary
   updates 20% of pods in guestbook-canary-rollout with new image
1. check the linkerd dashboard for trafic split to reflect 20(weight of first step) in the canary service
1. kubectl argo rollouts promote guestbook-canary-rollout -n guestbook-canary
   executes the rest of the update steps
1. kubectl argo rollouts promote guestbook-canary-rollout -n guestbook-canary
   updates the final set of pods with the new image

## Initial BlueGreen Rollout Setup in K8s

1. kubectl create namespace guestbook-bluegreen
   creates a namespace 'guestbook-bluegreen'
1. kubectl apply -f guestbook-bluegreen-service.yaml -n guestbook-bluegreen
   creates two services 'guestbook-bluegreen-active' and 'guestbook-bluegreen-preview'
1. kubectl apply -f guestbook-bluegreen-rollout.yaml -n guestbook-bluegreen
   creates a rollout with bluegreen strategy, replica set of 2 pods with image guestbook:blue
1. kubectl apply -f redis.yaml -n guestbook-bluegreen
   creates a redis pod and service
1. linkerd viz dashboard &
   dashboard shows the pods created
1. kubectl get service guestbook-bluegreen-active -n guestbook-bluegreen
   to view the application in browser <external-ip>:8080/index.html

## Update BlueGreen Rollout with a new Image

1. kubectl argo rollouts set image guestbook-bluegreen-rollout guestbook-container=xldevdocker/guestbook:green -n guestbook-bluegreen
   Creates pods with the new image and exposes the application through the preview service
1. kubectl get service guestbook-bluegreen-preview -n guestbook-blue
   to view the preview service application in browser <external-ip>:8080/index.html
1. kubectl argo rollouts promote guestbook-bluegreen-rollout -n guestbook-bluegreen
   promotes the preview service to live and terminates the old pods
1. kubectl get service guestbook-bluegreen-active -n guestbook-bluegreen
   to view the application in browser <external-ip>:8080/index.html

## Rollout new revisions

1. Setup connections in Release for the Unix host with kubectl, and the Kubernetes clusters, one for Canary and the other for BlueGreen (Specify the created namespaces).
1. Import templates from <link> into DAI Release
1. setup environment variables for canary rollout
	* canary-container: 
	....
	
Run the template and complete the promotion of image

*** To be continued after argo rollout tasks are modified to take in kubernetes connection itself