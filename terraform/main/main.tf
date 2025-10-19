provider "aws" {
  region = "eu-west-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-server-*"]
  }
  owners = ["099720109477"]
}

resource "aws_vpc" "private_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = "private-vpc" }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.private_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = false

  tags = { Name = "private-subnet" }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.private_vpc.id
  tags   = { Name = "private-rt" }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.private_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "private-sg" }
}

resource "aws_security_group" "redis_sg" {
  vpc_id = aws_vpc.private_vpc.id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.private_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  tags = { Name = "redis-sg" }
}

resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "deploy_key" {
  key_name   = "ec2-deploy-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "aws_elasticache_subnet_group" "private_cache_subnet_group" {
  name       = "private-cache-subnet-group"
  subnet_ids = [aws_subnet.private_subnet.id]
}

resource "aws_elasticache_cluster" "redis_cluster" {
  cluster_id          = "private-redis-cluster"
  engine              = "redis"
  node_type           = "cache.t4g.micro"
  num_cache_nodes     = 1
  parameter_group_name = "default.redis7"
  port                = 6379
  subnet_group_name   = aws_elasticache_subnet_group.private_cache_subnet_group.name
  security_group_ids  = [aws_security_group.redis_sg.id]

  tags = { Name = "private-redis" }
}

resource "aws_instance" "app_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t4g.micro"
  subnet_id                   = aws_subnet.private_subnet.id
  vpc_security_group_ids      = [aws_security_group.private_sg.id]
  key_name                    = aws_key_pair.deploy_key.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              echo "REDIS_HOST=${aws_elasticache_cluster.redis_cluster.cache_nodes[0].address}" >> /etc/environment
              echo "REDIS_PORT=6379" >> /etc/environment
              EOF

  tags = { Name = "private-ec2" }
}

resource "aws_api_gateway_rest_api" "shop_api" {
  name = "private-shop-api"
  endpoint_configuration {
    types = ["PRIVATE"]
  }
}

resource "aws_api_gateway_resource" "scrape" {
  rest_api_id = aws_api_gateway_rest_api.shop_api.id
  parent_id   = aws_api_gateway_rest_api.shop_api.root_resource_id
  path_part   = "scrape"
}

resource "aws_api_gateway_resource" "login" {
  rest_api_id = aws_api_gateway_rest_api.shop_api.id
  parent_id   = aws_api_gateway_rest_api.shop_api.root_resource_id
  path_part   = "login"
}

resource "aws_api_gateway_resource" "dashboard" {
  rest_api_id = aws_api_gateway_rest_api.shop_api.id
  parent_id   = aws_api_gateway_rest_api.shop_api.root_resource_id
  path_part   = "dashboard"
}

resource "aws_api_gateway_method" "root_get" {
  rest_api_id   = aws_api_gateway_rest_api.shop_api.id
  resource_id   = aws_api_gateway_rest_api.shop_api.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "scrape_post" {
  rest_api_id   = aws_api_gateway_rest_api.shop_api.id
  resource_id   = aws_api_gateway_resource.scrape.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "login_get" {
  rest_api_id   = aws_api_gateway_rest_api.shop_api.id
  resource_id   = aws_api_gateway_resource.login.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "dashboard_get" {
  rest_api_id   = aws_api_gateway_rest_api.shop_api.id
  resource_id   = aws_api_gateway_resource.dashboard.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "root_integration" {
  rest_api_id             = aws_api_gateway_rest_api.shop_api.id
  resource_id             = aws_api_gateway_rest_api.shop_api.root_resource_id
  http_method             = aws_api_gateway_method.root_get.http_method
  integration_http_method = "GET"
  type                    = "HTTP"
  uri                     = "http://${aws_instance.app_server.private_ip}/"
}

resource "aws_api_gateway_integration" "scrape_integration" {
  rest_api_id             = aws_api_gateway_rest_api.shop_api.id
  resource_id             = aws_api_gateway_resource.scrape.id
  http_method             = aws_api_gateway_method.scrape_post.http_method
  integration_http_method = "POST"
  type                    = "HTTP"
  uri                     = "http://${aws_instance.app_server.private_ip}/scrape"
}

resource "aws_api_gateway_integration" "login_integration" {
  rest_api_id             = aws_api_gateway_rest_api.shop_api.id
  resource_id             = aws_api_gateway_resource.login.id
  http_method             = aws_api_gateway_method.login_get.http_method
  integration_http_method = "GET"
  type                    = "HTTP"
  uri                     = "http://${aws_instance.app_server.private_ip}/login"
}

resource "aws_api_gateway_integration" "dashboard_integration" {
  rest_api_id             = aws_api_gateway_rest_api.shop_api.id
  resource_id             = aws_api_gateway_resource.dashboard.id
  http_method             = aws_api_gateway_method.dashboard_get.http_method
  integration_http_method = "GET"
  type                    = "HTTP"
  uri                     = "http://${aws_instance.app_server.private_ip}/dashboard"
}

resource "aws_vpc_endpoint" "api_vpce" {
  vpc_id             = aws_vpc.private_vpc.id
  service_name       = "com.amazonaws.eu-west-2.execute-api"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.private_subnet.id]
  security_group_ids = [aws_security_group.private_sg.id]
}

output "redis_endpoint" {
  value = aws_elasticache_cluster.redis_cluster.cache_nodes[0].address
}

output "ec2_id" {
  value = aws_instance.app_server.id
}

output "api_id" {
  value = aws_api_gateway_rest_api.shop_api.id
}

output "private_key_pem" {
  value     = tls_private_key.ec2_key.private_key_pem
  sensitive = true
}

output "ec2_public_ip" {
  value = aws_instance.app_server.public_ip
}
