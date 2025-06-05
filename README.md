# Yii2 PHP App Deployment with Docker Swarm, NGINX & CI/CD

This project demonstrates how to deploy a Yii2 PHP application on an AWS EC2 instance using Docker Swarm and NGINX as a reverse proxy. CI/CD is handled via GitHub Actions, and infrastructure provisioning is automated using Ansible.


## Task 1
* Create project
```bash
composer create-project --prefer-dist yiisoft/yii2-app-basic yii2-app
cd yii2-app
composer install
```
* Run it locally without docker
```bash
php yii serve --port=8080
```
* Now application run on port 8080
* Make requirement file
* Make [Dockerfile](./Dockerfile) with sufficient dependencies
* Use docker build command to build image
```bash
sudo docker build -t faisalkamil/yii2:$version .
```
* Push docker image to dockerhub
```bash
sudo docker push faisalkamil/yii2:$version
```
* ssh to ec2
```bash
ssh -i <key.pem> ubuntu@<sevrer-ip>
```
* Create docker-compose [file](./docker-compose.yaml) for running docker swarm
* Install docker [file](./install-docker.md)
* Initiate docker swarm usinf command
```bash
docker swarm init
```
* Run the below command for starting docker swarm application
    * Docker compose [file](./T1/docker-compose.yaml)
    ```bash
    docker stack deploy -c docker-compose.yaml yii2
    ```
* Install nginx on ec2
```bash
sudo apt update
sudo apt install nginx
sudo systemctl enable nginx --now
```
* Setup config file of nginx (with private ip or 127.0.0.1)
    * Configure [nginx.conf](./nginx.conf) file present in **/etc/nginx/nginx.conf**
    ```bash
    sudo systemctl reload nginx
    ```

## Task 2
* Make a [deploy.yaml](./.github/workflows/deploy.yaml) file in *.github/workflow/deploy.yaml*
* Use github secrets for storing secrets
    * Go to **settings** on that particular repo, then add secrets under **Actions secrets and variables**
    * **EC2_SSH_KEY** : private-key
    * **DOCKER_USERNAME** : *docker_hub_username*
    * **DOCKER_PASSWORD** : *docker_hub_password*
* CI/CD pipeline stages:
    * Checkout the repo
    * Build and tag Docker image as `v1.0.x`
    * Push image to Docker Hub
    * SSH into EC2
    * Update image tag in `docker-compose.yaml`
    * Re-deploy the stack
    * Save the current working tag
    * Rollback automatically if deploy fails


## Task 3
* Use Ansible playbook(s) to automate server provisioning and setup

* Tasks performed:
    * Install Docker and Docker Compose [click-here](./ansible/setup-docker.yaml)
    * Initialize Docker Swarm [click-here](./ansible/initialize-docker-swarm.yaml)
    * Install NGINX, PHP, Git [click-here](./ansible/dependencies.yaml)
    * Set up NGINX reverse proxy configuration [click-here](./ansible/setup-nginx.yaml)
    * Clone repository [click-here](./ansible/clone-repo.yaml)
    * Deploy Docker stack using updated image [click-here](./ansible/deploy-swarm.yaml)



