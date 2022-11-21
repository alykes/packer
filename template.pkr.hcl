source "amazon-ebs" "globoticket" {
  ssh_username  = "ubuntu"
  ami_name      = "globoticket-${uuidv4()}"
  source_ami    = "ami-09a5c873bc79530d9"
  instance_type = "t3.micro"
  temporary_security_group_source_cidrs = ["wfh_ip/32"]
}

build {
  sources = ["source.amazon-ebs.globoticket"]
}

