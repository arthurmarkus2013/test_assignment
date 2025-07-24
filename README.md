# test_assignment

```bash
aws eks --region $(terraform output -raw aws_region) update-kubeconfig --name $(terraform output -raw eks_cluster_name)
```
