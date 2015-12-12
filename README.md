# taypo/jenkins docker image

No configuration, package management etc. is needed to add a new Jenkins item, point to a repository over at Bitbucket, make a maven build, and produce either a runnable jar or even better, another docker image that runs the jar.

You can check it out from [dockerhub](https://hub.docker.com/r/taypo/jenkins/).

### Installed Packages
Below packages are pre-installed:

- Java 8 JDK
- Maven 3
- Git
- Mercurial
- Docker

### Features
#### Jenkins Configuration
Jenkins is auto configured to use JDK and Maven installations of the system. Plugins for Git and Mercurial is also installed.

#### SSH Client
Upon first start, the image generates an ssh key pair and prints the public key to the docker console. This is useful if your SCM provider requires public key cryptography for code checkouts. For example you can add this to your Bitbucket repository as a deployment key.

There is also an environment variable `KNOWN_HOSTS`. You can set comma separated list of host names to it, and their fingerprints are added to `~/.ssh/known_hosts`. This prevents your first checkout over ssh asking to add the host, thus blocking Jenkins.


#### Docker *by* Docker
Finally, we want our image to able to build docker images. Instead of using [docker in docker](https://github.com/jpetazzo/dind) we can mount the unix socket file of the host docker deamon to this container, and build our images there. You can read more about how to access host docker, and why it is better than "docker in docker" in [this blog post](http://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/).

### Volumes
There are two volumes that you can mount to host, Jenkins data directory and root's `.ssh` directory.

```language-bash
/var/jenkins_home
/root/.ssh
```

### Running

Basic:
```language-bash
docker run -p 8080:8080 -v taypo/jenkins
```

or with host mounted volumes, docker link and Bitbucket added to known hosts:
```language-bash
docker run -p 8080:8080 \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /home/docker/data/jenkins:/var/jenkins_home \
-v /home/docker/data/jenkins/.ssh:/root/.ssh \
-e KNOWN_HOSTS=bitbucket.org \
taypo/jenkins
```
This will store image data in `/home/docker/data/jenkins`directory of the host.
