# IMA setup

resource "aws_iam_role" "ec2_ssm_role" {
  name = "EC2SSMRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_ssm_policy" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "EC2SSMProfile"
  role = aws_iam_role.ec2_ssm_role.name
}

resource "aws_security_group" "ssm_http_sg" {
  name        = "ssm-http-security-group"
  description = "Allow HTTP access from the VPC"
  vpc_id      = aws_vpc.ssm_vpc.id

   # INGRESS: Defines inbound rules allowing access to port 80 (HTTP)

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allows outbound traffic to ANY destination
  }
}

# Security Group for SSM (Port 443) - Used for AWS Systems Manager (SSM) agent communication
resource "aws_security_group" "ssm_sg" {
  name        = "ssm-security-group"               
  description = "Allow SSM access from the internet"
  vpc_id      = aws_vpc.ssm_vpc.id

  # INGRESS: Defines inbound rules allowing access to port 443 (HTTPS for SSM communication)
  ingress {
    description = "Allow SSM from anywhere" 
    from_port   = 443                       
    to_port     = 443                       
    protocol    = "tcp"                     
    cidr_blocks = ["0.0.0.0/0"]             # WARNING: Allows traffic from ANY IP address (highly insecure!)
  }

  # EGRESS: Allows all outbound traffic (default open rule)
  egress {
    from_port   = 0             
    to_port     = 0             
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allows outbound traffic to ANY destination
  }
}