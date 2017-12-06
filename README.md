# ecs-deploy
Fully automated AWS ECS deployments, including creation of Docker images, ECS Tasks, Services, Target Groups and Application Load Balancers.

### Installation and usage

#### • Traditional install on Linux:

```shell
# Install
$ cd && rm -rf ecs-deploy && git clone https://github.com/TroyConrad/ecs-deploy.git && cd ecs-deploy && sudo ./install.sh

# Usage
$ ecs-deploy <arguments>
```


#### • Via Docker:

```shell
# Install
$ cd && docker build https://github.com/TroyConrad/ecs-deploy.git

# Usage
$ docker run ecs-deploy <arguments>
```

### Examples

Examples of the two required JSON files are in `examples`.

The `jenkins-script.pl` creates these files on the fly before running ecs-deploy.
