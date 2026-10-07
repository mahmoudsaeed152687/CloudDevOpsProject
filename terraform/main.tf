module "network" {
  source = "./modules/network"

  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  availability_zone_1 = var.availability_zone_1
  availability_zone_2 = var.availability_zone_2
}


module "server" {
  source = "./modules/server"

  project_name  = var.project_name
  vpc_id        = module.network.vpc_id
  subnet_id     = module.network.public_subnet_ids[0]
  instance_type = "t3.micro"
  key_name      = "ivolve-devops-key"
}


module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
}


module "eks" {
  source = "./modules/eks"

  project_name       = var.project_name
  private_subnet_ids = module.network.private_subnet_ids

  # IMPORTANT
  # We need enough pod capacity for:
  # - EBS CSI Controller
  # - CoreDNS
  # - kube-proxy
  # - VPC CNI
  # - Pod Identity Agent
  # - Application workloads
  node_instance_type = "m7i-flex.large"
}


module "ansible" {
  source = "./modules/ansible"

  project_name  = var.project_name
  vpc_id        = module.network.vpc_id
  subnet_id     = module.network.public_subnet_ids[1]
  instance_type = "t3.micro"
  key_name      = "ivolve-devops-key"
}
