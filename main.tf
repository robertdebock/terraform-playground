# Read the prerequisites details.
data "terraform_remote_state" "default" {
  backend = "local"
  config = {
    path = "./prerequisites/terraform.tfstate"
  }
}

# Make AWS servers.
module "server" {
  count                          = var.amount
  source                         = "robertdebock/instance/aws"
  version                        = "1.7.1"
  instance_name                  = "lab-${count.index}"
  instance_aws_key_pair_id       = data.terraform_remote_state.default.outputs.instance_key_pair_id
  instance_aws_vpc_id            = data.terraform_remote_state.default.outputs.instance_vpc_id
  instance_aws_subnet_id         = data.terraform_remote_state.default.outputs.instance_subnet_id
  instance_aws_security_group_id = data.terraform_remote_state.default.outputs.instance_security_group_id
  instance_user_data_script_file = "myscript.sh"
  instance_root_block_device     = 32
}

# Lookup "adfinis.dev" on AWS.
data "aws_route53_zone" "default" {
  name = "adfinis.dev."
}

# Create A records.
resource "aws_route53_record" "default" {
  count   = var.amount
  zone_id = data.aws_route53_zone.default.zone_id
  name    = "lab-${count.index}"
  type    = "A"
  ttl     = "300"
  records = [module.server[count.index].instance_public_ip]
}
