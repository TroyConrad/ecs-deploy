#!/usr/bin/perl

$VERSION = '1.0.1'; # Modified 05Dec2017 by Troy Conrad <troy.conrad@mirumagency.com>

require "/opt/ecs-deploy/ecs-deploy-lib.pl";

#####################################
######### GENERAL SETTINGS ##########
#####################################

$VERBOSE = 1; # 1 = more verbose logging

$awsAccountID = '<your-aws-account-number>';

#####################################
######### PROJECT SETTINGS ##########
#####################################

print "Compiling data...\n";

#
##
### Deploy Info ###

$projectName = 'example-project'; # name of project.
# Basis of docker image, task and service name and CloudWatch log group name.

# Determines NODE_ENV value, docker image/task/service names,
# CloudWatch group, load balancer names AND docker task count
$environmentType = 'prd'; # prd, stg, qa, dev

# Determines range of port numbers used to expose containers on ECS host
$hostPortPrefix  = 01; # 10-650 MUST BE UNIQUE PER PROJECT

$deployInfo->{url} = "http://project.example.com/"; # deploy URL for Route 53 and notification messages

$deployInfo->{project}->{clientCode} = 'CODE'; # string value for resource tagging
$deployInfo->{project}->{jobNumber} = '1234'; # string value for resource tagging

$deployInfo->{ecs}->{clusterName} = 'example-clustername'; # ECS cluster to deploy to
$deployInfo->{ecs}->{instanceIds} = 'i-1234567890abcdef1 i-1234567890abcdef2 i-1234567890abcdef3';


# Path AWS health check will use to determine instance health
$deployInfo->{alb}->{healthCheckPath}  = '/'; # HTTP GET MUST return 200

$deployInfo->{alb}->{securityGroups} = 'sg-123abc01 sg-123abc02';
$deployInfo->{alb}->{subnets} = 'subnet-123abc03 subnet-123abc02 subnet-123abc03';
$deployInfo->{alb}->{vpcID} = 'vpc-123abc01'; # AWS VPC ID

$deployInfo->{build}->{dockerFilePath} = 'Dockerfile'; # path to Dockerfile in workspace root

#
##
### Docker Task Info ###

$buildNumber	= $ENV{'BUILD_NUMBER'} || 'N/A';	# get Jenkins build number

$envSettings = getEnvironmentSettings($environmentType);

($nodeEnv,$nameSuffix,$hostPortSuffix,$taskCount) = @{$envSettings};

$deployName = $projectName.$nameSuffix;
$hostPort = $hostPortPrefix.$hostPortSuffix;

# JSON string of properties of docker container(s) in task
$taskDefJSON = <<END_OF_DATA;
{
  "networkMode": "bridge",
  "containerDefinitions": [
    {
      "environment": [
        {
          "name": "NODE_ENV",
          "value": "production"
        },
        {
          "name": "JENKINS_BUILD",
          "value": "$buildNumber"
        }
      ],
      "portMappings": [
        {
          "hostPort": $hostPort,
          "containerPort": 8080,
          "protocol": "tcp"
        }
      ],        
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "$projectName",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "$environmentType"
        }
      },
      "essential": true,
      "name": "$deployName",
      "image": "$awsAccountID.dkr.ecr.us-east-1.amazonaws.com/$deployName:latest",
      "memoryReservation": 512
    }
  ],
  "family": "$deployName"
}
END_OF_DATA

#####################################
############ MAIN SCRIPT ############
#####################################

print "Creating JSON files...\n";

use JSON::PP;

# init a JSON<->Perl converter object
$json = JSON::PP->new->ascii->canonical->pretty->allow_nonref;

$deployInfo->{project}->{name} = $projectName;

$deployInfo->{environmentType} = $environmentType;

# create JSON string of deploy info
$deployInfoJSON = $json->encode($deployInfo);

print "\nDeploy Info:\n$deployInfoJSON\n";

writeFile('deployInfo.json',$deployInfoJSON);

print "Task Definition:\n$taskDefJSON\n\n";

writeFile('taskDefinition.json',$taskDefJSON);

print "Running ecs-deploy...\n";

$deployCmd = "ecs-deploy -v $VERBOSE -d deployInfo.json -t taskDefinition.json";

# run deploy
if ( system($deployCmd) == 0 )
{
  print "Build script complete!\n\n";
}
else
{
  print "An error occured running ecs-deploy.\n";
  exit 1; # exit indicating error
}
