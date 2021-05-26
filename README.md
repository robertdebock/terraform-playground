# Terraform playground

Setup machines to run terraform from.

## Setup

Create an ssh key pair to be login as root.

```shell
ssh-keygen -f ssh_keys/id_rsa
```

Initialize terraform.

```shell
terraform init
```

## Operating

1. Set the `amount` of machines to create in `terraform.tfvars`.
2. Create the machines.

```shell
terraform plan
```

## Login information.

|Parameter|Value     |
|---------|----------|
|username |`username`|
|password |`password`|

3. Destroy the machines.

```shell
terraform destroy
```
