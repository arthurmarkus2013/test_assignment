# test_assignment

## Step-by-step instructions

`If you decided to use your own docker image, then you have tȯmodify the deploy_to_k8s.yml file and set the image field to point to your custom image`

`P. S. The following steps always assume, that you're located in the root of the repo`

### 1) Provision the infrastructure
```bash
cd deployment_scripts/terraform/infrastructure/

terraform init
terraform apply
```
P. S. Make note of the scripts output

### 2) Modify the inventory file in `ansible` folder to point ti the correct IPs

### 3) Depoy k3s
```bash
cd deployment_scripts/ansible/

ansilbe-playbook -i inventory -l k3s k3s-playbook.yml
```

### 4) Deploy the web app to k3s
```bash
cd web_app/

kubectl apply -f deploy_to_k8s.yml
```

### 5) Deploy prometheus
```bash
cd deployment_scripts/ansible/

ansilbe-playbook -i inventory -l prometheus prometheus-playbook.yml
```
P. S. This playbook would as you for the URL of the deployed webapp

`And don't forget to remove everything after trying out, in order to avoid unexpected charges!!!`
