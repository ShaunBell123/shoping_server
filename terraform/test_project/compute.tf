data "aws_ssm_parameter" "ubuntu_24_04" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

data "aws_ami" "ubuntu_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "image-id"
    values = [data.aws_ssm_parameter.ubuntu_24_04.value]
  }
}

resource "aws_instance" "ubuntu_instance" {
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.ssm-private-subnet.id

  vpc_security_group_ids = [
    aws_security_group.ssm_sg.id,
    aws_security_group.ssm_http_sg.id
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2_ssm_profile.name

  user_data = <<-EOF
            #!/bin/bash
            set -e

            echo "Waiting for network..."
            until ping -c1 archive.ubuntu.com &>/dev/null; do
              sleep 5
            done

            echo "Updating system..."
            # Retry apt update in case of temporary mirror issues
            for i in {1..5}; do
              apt update && break || sleep 5
            done

            echo "Installing required packages..."
            apt install -y docker.io git curl docker-compose-plugin

            echo "Starting Docker..."
            systemctl enable --now docker

            echo "Add ubuntu user to docker group..."
            usermod -aG docker ubuntu

            # Ensure Docker Compose can be run by ubuntu user
            chown -R ubuntu:ubuntu /usr/local/lib/docker/cli-plugins 2>/dev/null || true
            mkdir -p /home/ubuntu/.docker
            chown -R ubuntu:ubuntu /home/ubuntu/.docker

            echo "Installing and starting SSM agent..."
            snap install amazon-ssm-agent --classic
            systemctl enable --now snap.amazon-ssm-agent.amazon-ssm-agent.service

            echo "Creating app directory..."
            mkdir -p /home/ubuntu/app
            chown -R ubuntu:ubuntu /home/ubuntu/app
            chmod 755 /home/ubuntu/app

            echo "User data finished."
            EOF

  tags = {
    Name = "ubuntu-instance"
  }
}