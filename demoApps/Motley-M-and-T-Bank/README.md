# Motley M & T Bank Demo

## Introduction

For this demo we have the *Motley M & T Bank* Appliction.  This application is a WAR file that we can deploy to any J2EE container.  This demo also provides some yaml files that can be customized to connect to an EC2 instance running Linux and Tomcat.

## Instructions

To run this demo you will need to tell Deploy about some infrastructure that you have Tomcat running on.  The example worked through assumes you have created this infrastructure in AWS EC2, but any server with Tomcat will do.  You will need to make changes for your environment.

Steps:
1. For your server get a copy of the public key and copy it into `yaml/artifacts/ssh-key.pem`
2. Edit the `yaml/xebialabs/values.xlvals` for the proper `user` and `publicIP`
3. Run the `./startDemo.sh` script to start the demo container

This will setup the infrastructure for you.  If you have different infrastructure you might need to either edit the yaml files or go to the *Deploy* UI and make changes

Add the application:
1. Run the `./build.sh` script
2. Login to the *Deploy* UI [http://localhost:4516](http://localhost:4516)
