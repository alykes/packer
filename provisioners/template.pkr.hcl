data "amazon-ami" "globoticket" {
  filters = {
    virtualization-type = "hvm"
    name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
    root-device-type    = "ebs"
  }
  owners      = ["099720109477"]
  most_recent = true
}

data "amazon-secretsmanager" "globoticket-live" {
  name = "Globoticket-live"
  key  = "SECRET_ARTIST_NAME"
}

source "amazon-ebs" "globoticket" {
  ssh_username                          = "ubuntu"
  ami_name                              = "globoticket-${uuidv4()}"
  source_ami                            = data.amazon-ami.globoticket.id
  instance_type                         = "t3.micro"
  temporary_security_group_source_cidrs = ["wfh_ip/32"]
}


build {
  sources = ["source.amazon-ebs.globoticket"]

  provisioner "file" {
    source      = "config/nginx.service"
    destination = "/tmp/"
  }

  provisioner "file" {
    source      = "config/nginx.conf"
    destination = "/tmp/"
  }

  provisioner "file" {
    source      = "globoticket-asset-bundle"
    destination = "/tmp/"
  }

  provisioner "shell" {
    execute_command = "sudo -S env {{ .Vars }} {{ .Path }}"
    inline = [
      "mkdir -p /var/globoticket",
      "mv /tmp/nginx.conf /var/globoticket/",
      "mv /tmp/nginx.service /etc/systemd/system/nginx.service",
      "mv /tmp/globoticket_assets/** /var/globoticket"
    ]
  }

  provisioner "shell" {
    execute_command  = "sudo -S env {{ .Vars }} {{ .Path }}"
    environment_vars = ["SECRET_ARTIST_NAME=${data.amazon-secretsmanager.globoticket-live.value}"]
    script           = "scripts/build_nginx_webapp.sh"
  }

}
