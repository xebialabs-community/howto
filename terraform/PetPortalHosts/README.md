# PetPortalHosts

[![](http://img.youtube.com/vi/zaveYy86v7I/0.jpg)](http://www.youtube.com/watch?v=zaveYy86v7I "How to: Deploy to AWS EC2 Using Digital.ai Deploy and Terraform")
[http://www.youtube.com/watch?v=zaveYy86v7I](http://www.youtube.com/watch?v=zaveYy86v7I)

## Setup

1. Create `secrets.xlvals` and add necessary properties (see [xebialabs/secrets.xlvals.md](xebialabs/secrets.xlvals.md))
1. Update `values.xlvals` with variables that work for you (see [xebialabs/values.xlvals](xebialabs/values.xlvals.md))
1. Copy your public key from AWA to `xebialabs/ssh-key/ssh-key.pem`
1. Run `./startDemo.sh`
1. Wait for *Digital.ai Deploy* to finish starting (`docker-compose logs -f xl-deploy` look for the point your browser line)
1. Run `./build.sh`
1. Login in to *Digital.ai Deploy* and deploy the *PetPortalHosts/servers* Application to the *aws_terraform* Environment
1. Check the connections to make sure everything worked
1. Edit the *TEST* environment and add the following:
  * Infrastructure/aws/TEST/webserver/apache
  * Infrastructure/aws/TEST/appserver/jboss
  * Infrastructure/aws/TEST/appserver/mysqldb
1. Deploy the *PetPorta/1.0.0* App to the *TEST* environment
1. Get the webserver address from the *Webserver* overthere host and open the URL
