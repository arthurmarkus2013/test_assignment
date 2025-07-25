# test_assignment

## Step-by-step instructions

### 1) Build your own docker image (Optional)
```bash
docker build . -t simple-web-app
```

### 2) Log into AWS ECR with Docker (optional)
```bash
aws ecr get-login-password --region <your_region> | docker login --username AWS --password-stdin <your_account_id>.dkr.ecr.<your_region>.amazonaws.com
```
or
```bash
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws
```

### 3) Push your docker image to AWS ECR (optional)
```bash
docker tag <your_image_id> <your_account_id>.dkr.ecr.region.amazonaws.com/<your_repository_name>:<your_tag>

docker tag <your_image_id> <your_account_id>.dkr.ecr.region.amazonaws.com/<your_repository_name>:<your_tag>
```
or
```bash
docker tag <your_image_id> public.ecr.aws/<your_registry_alias>/<your_repository_name>

docker push public.ecr.aws/<your_registry_alias>/<your_repository_name>
```

`If you decided to use your own docker image, then you have tȯmodify the deploy_to_k8s.yml file and set the image field to point to your custom image`

`P. S. The remaining steps always assume, that you're located in the root of the repo`

### 4) Provision the infrastructure
```bash
cd deployment_scripts/terraform/infrastructure/

terraform init
terraform apply
```
P. S. Make note of the scripts output

### 5) Modify the inventory file in `ansible` folder to point ti the correct IPs

### 6) Depoy k3s
```bash
cd deployment_scripts/ansible/

ansilbe-playbook -i inventory -l k3s k3s-playbook.yml
```

### 7) Deploy the web app to k3s
```bash
cd web_app/

kubectl apply -f deploy_to_k8s.yml
```

### 8) Deploy prometheus
```bash
cd deployment_scripts/ansible/

ansilbe-playbook -i inventory -l prometheus prometheus-playbook.yml
```
P. S. This playbook would as you for the URL of the deployed webapp

`And don't forget to remove everything after trying out, in order to avoid unexpected charges!!!`
