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
