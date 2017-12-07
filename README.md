# ecs-deploy
Fully automated AWS ECS deployments, including creation of Docker images, ECS Tasks, Services, Target Groups and Application Load Balancers.

### Overview

1. Create an ECS cluster in your AWS account. It should have at least two instances, preferably in different AZs.
2. Create an IAM user full permissions for all ECS, ECR and ELB actions.
3. Create a Linux-hosted webservice that listens for HTTP connections on port 8080.
4. Create an associated Dockerfile that runs the service and exposes the port. (See examples/.)
5. Add the source and Dockerfile to a Git repo.
6. Create the AWS CLI credentials file (Docker) or install and configure the AWS CLI (traditional install).
7. Create the required task definition file, which describes the ECS task to be created. (See examples/.)
8. Create the required deploy info file, which contains all deployment settings. (See examples/.)directory.)
9. Run ecs-deploy -c /path/to/aws-creds -d /path/to/deployInfo.json -t /path/to/taskDefinition.json

ecs-deploy will:
- Create the Docker ECR repo
- Build the Docker image
- Tag the Docker image and push it to the ECR repo
- Create an ECS task for the Docker image
- Create an ECS service (highly-availible by default)
- Deploy the service to the ECS cluster
- Create a target group and register the service’s tasks
- Create an application load balancer (ALB)
- Associate the target group with a HTTP:80 listener on the ALB

When complete, the ALB's DNS name is provided.

Add it to Route 53, etc. for custom domain support. Add an HTTPS listener to the ALB for SSL support.

**All actions are idempotent and all deployments are zero-downtime by default.**

### Installation and usage

#### • Traditional install (Linux only):

```shell
# Install the AWS CLI and either configure it with creds for an IAM user or pass the creds file using the option -c.
# (See http://docs.aws.amazon.com/cli/latest/userguide/installing.html)

# Install ecs-deploy.
$ cd && rm -rf ecs-deploy && git clone https://github.com/TroyConrad/ecs-deploy.git && cd ecs-deploy && sudo ./install.sh

# Create deployInfo, taskDefinition and optionally awsCreds files, and place into a single directory.
# (See examples directory)

# Perform a deploy
$ ecs-deploy [-c awsCreds] -d deployInfo.json -t taskDefinition.json
```


#### • Via Docker (Linux, macOS or Windows):

```shell
# Install Docker
# https://docs.docker.com/engine/installation/

# Build the ecs-deploy docker image
$ docker build https://github.com/TroyConrad/ecs-deploy.git

# Create deployInfo, taskDefinition and awsCreds files, and place into a single (e.g. $PWD) directory.
# (See examples directory)

# Usage
$ docker run -rm -v "$PWD":/data ecs-deploy -c /data/awsCreds -d /data/deployInfo.json -t /data/taskDefinition.json
```

### Examples

Examples of the two required JSON files are in `examples`.

The `jenkins-script.pl` creates these files on the fly before running ecs-deploy.