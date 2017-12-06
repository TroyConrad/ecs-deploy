# ecs-deploy
Fully automated AWS ECS deployments, including creation of Docker images, ECS Tasks, Services, Target Groups and Application Load Balancers.

Installation and usage:

- Traditional install on Linux:

# Install

$ cd && rm -rf ecs-deploy && git clone https://github.com/TroyConrad/ecs-deploy.git && cd ecs-deploy && sudo ./install.sh
 
# Usage

$ ecs-deploy <arguements>

- Via Docker:

# Install

$ cd && docker build https://github.com/TroyConrad/ecs-deploy.git

# Usage

$ docker run ecs-deploy <arguements>

