
data "aws_ssm_parameter" "ubuntu_24_04" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

data "aws_ami" "ubuntu_ami" {

  most_recent = true
  owners = ["099720109477"]

  filter {
    name   = "image-id"
    values = [data.aws_ssm_parameter.ubuntu_24_04.value]
  }
}


resource "aws_instance" "ubuntu_instance" {

  ami = data.aws_ami.ubuntu_ami.id
  instance_type = "t3.micro"

  subnet_id = aws_subnet.ssm-private-subnet.id

  vpc_security_group_ids = [
    aws_security_group.ssm_sg.id,
    aws_security_group.ssm_http_sg.id
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2_ssm_profile.name

  user_data = <<-EOF
                #!/bin/bash

                apt update
                snap install amazon-ssm-agent --classic

                systemctl enable --now snap.amazon-ssm-agent.amazon-ssm-agent.service

                apt install -y git

                mkdir -p /home/ubuntu/app

              EOF

  tags = {
    Name = "ubuntu-instance"
  }
}