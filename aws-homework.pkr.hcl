packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.2.4"
    }
  }
}

source "amazon-ebs" "amazon-linux-2" {
  ami_name                = "packer-homework-awslinux-2-${local.timestamp}"
  ami_virtualization_type = "hvm"
  ssh_username            = "ec2-user"
  instance_type           = "t2.micro"
  region                  = "eu-central-1"
  tags                    = local.tags
  run_tags                = local.tags

  source_ami_filter {
    filters = {
      name                  = "amzn2-ami-ecs-hvm-2.0.*-x86_64-ebs"
      root-device-type      = "ebs"
      virtualization-type   = "hvm"
      architecture          = var.architecture
    }
    
    most_recent = true
    owners      = ["amazon"]
  }
}

build {
  name = "packer-homework"
  sources = [
    "source.amazon-ebs.amazon-linux-2"
  ]

  provisioner "file" {
    source      = "./html"
    destination = "/tmp"
  }

  provisioner "shell" {
    inline = [
      "sudo amazon-linux-extras install docker",
      "sudo systemctl enable docker",
      "sudo usermod -a -G docker ec2-user",
      "sudo docker run --name nginx -d -p ${var.docker_port}:80 -v /tmp/html:/usr/share/nginx/html --restart always nginx:alpine"
    ]
  }

  post-processor "manifest" {
    output     = var.manifest_file_name
    strip_path = true
  }
}