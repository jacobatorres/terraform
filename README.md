# terraform
Terraform code for my pet projects.

Steps:
1. Create this repo (done)
2. Set up AWS account, ie get credentials there by going to IAM, saving data
3. Put the creds in the correct place in local (in the aws profile). 
4. You can now create terraform code as usual (tfi; tfp; tfa). Note the structure.

```
├── modules
│ ├── lambda
│ └── vpc
├── project1
│ └── main.tf
└── project2
  └── main.tf
```
