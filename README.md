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
`The provisioning script will ask for the name of the key-pair, that's needed for ssh access. This key-pair MUST already exist in your AWS account!`

### 2) SSH into the Bastion server
`The following steps have to be ran from within a Bastion server`

### 3) Copy the PEM file (that you've used for SSH in the previous step) into the Bastion server
`You'll need to provide that file to Ansible in the following steps`

`You can simply copy-paste the contents of the PEM file into a new file, that you create on-the-fly on the server`

### 4) Modify the inventory file in `ansible` folder to point to the correct IPs
```bash
cd deployment_scripts/ansible/

vi inventory
```

### 5) Depoy k3s
```bash
cd deployment_scripts/ansible/

ansilbe-playbook -i inventory -l k3s --key-file <path-to-your-key-file> k3s-playbook.yml
```

### 6) Deploy the web app to k3s
```bash
cd web_app/

kubectl apply -f deploy_to_k8s.yml
```

### 7) Deploy prometheus
```bash
cd deployment_scripts/ansible/

ansilbe-playbook -i inventory -l prometheus --key-file <path-to-your-key-file> prometheus-playbook.yml
```
P. S. This playbook would as you for the URL of the deployed webapp

`And don't forget to remove everything after trying out, in order to avoid unexpected charges!!!`

## Closing thoughts

- For this test assignment I made the prometheus server (port 9090) publicly accessable, since that way it's easier to access, but in a real production environment access to it absolutely must be restricted
- The web server is accessible publicly on port 80, as required by the assignment
- In odrer to furfill the static-IP requirement (according to my understanding of it) I've decided to not deploy an EKS Cluster, but rather deploy k3s on an EC2 Instance, to which I've assigned an Elastic IP
- For deployment purposes (with Ansible) port 22 had to be made open on all servers: publicly on a Bastion server and only within the vpc on other two servers
- In order to not expose any additional ports publicly on prometheus and web servers, a Bastion server had to be created
- For managing the infrastructure with terraform I've personally decided to use AWS CloudShell to run the scripts
- For hosting a pre-built Docker Image I've decided to use AWS Public ECR for no particular reason
- The web app itself I've decided to implement in GoLang, because to me it seemed to be the easiest and fastest way to implement a simple example app (with minimal friction)
