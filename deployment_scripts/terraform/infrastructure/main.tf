resource "aws_vpc" "test_assignment_vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "test_assignment_vpc",
        Project = "Test Assignment"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.test_assignment_vpc.id

    tags = {
      "name" = "test_assignment_igw"
      "project" = "Test Assignment"
    }
}

resource "aws_subnet" "test_assignment_subnet" {
    vpc_id = aws_vpc.test_assignment_vpc.id
    count = 2
    cidr_block = cidrsubnet("10.0.2.0/16", 8, count.index)
    availability_zone = join("", ["${var.aws_region}", "${var.availability_zones[count.index]}"])

    tags = {
        Name = "test_assignment_subnet",
        Project = "Test Assignment"
    }    
}

resource "aws_route_table" "test_assignment_route_table" {
    vpc_id = aws_vpc.test_assignment_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
      Name = "test_assignment_route_table"
      Project = "Test Assignment"
    }
}

resource "aws_route_table_association" "test_assignment_route_table_association" {
    route_table_id = aws_route_table.test_assignment_route_table.id
    count = 2
    subnet_id = element(aws_subnet.test_assignment_subnet.*.id, count.index)
    
    depends_on = [ aws_route_table.test_assignment_route_table ]
}

resource "aws_security_group" "test_assignment_sg" {
    name = "allow outside access"
    description = "allow outside access to ec2 instances inside assosiated vpc"
    vpc_id = aws_vpc.test_assignment_vpc.id

    ingress = [
        {
            cidr_blocks = [ element(aws_subnet.test_assignment_subnet.*.cidr_block, 0) ]
            from_port = 9090
            protocol = "tcp"
            to_port = 9090
        },
        {
            cidr_blocks = [ element(aws_subnet.test_assignment_subnet.*.cidr_block, 1) ]
            from_port = 80
            protocol = "tcp"
            to_port = 80
        },
        {
            cidr_blocks = [ aws_subnet.test_assignment_subnet.*.cidr_block ]
            from_port = 22
            protocol = "tcp"
            to_port = 22
        }
    ]

    egress = [
        {
            cidr_blocks = [ "0.0.0.0/0" ]
            protocol = "-1"
            from_port = 0
            to_port = 0
        }
    ]

    tags = {
      "name" = "test_assignment_sg"
      "project" = "Test Assignment"
    }
}

resource "aws_instance" "prometheus_server" {
  ami           = "ami-034568121cfdea9c3"
  instance_type = "t3.micro"
  subnet_id     = element(aws_subnet.test_assignment_subnet.*.id, 0)
  associate_public_ip_address = true
  key_name = "${var.ec2_key_pair_name}"

  tags = {
    Name = "prometheus_server",
    Project = "Test Assignment"
  }
}

resource "aws_instance" "k3s_server" {
    ami           = "ami-034568121cfdea9c3"
    instance_type = "t3.micro"
    subnet_id     = element(aws_subnet.test_assignment_subnet.*.id, 1)
    key_name = "${var.ec2_key_pair_name}"

    tags = {
        Name = "k3s_server",
        Project = "Test Assignment"
    }
}

resource "aws_eip" "k3s_server_eip" {
    domain = "vpc"
    instance = aws_instance.k3s_server.id

    depends_on = [ aws_internet_gateway.igw ]

    tags = {
        Name = "k3s_server_eip",
        Project = "Test Assignment"
    }
}

resource "aws_instance" "bastion_server" {
    ami = "ami-034568121cfdea9c3"
    instance_type = "t3.micro"
    subnet_id = element(aws_subnet.test_assignment_subnet.*.id, 2)
    key_name = "${var.ec2_key_pair_name}"

    tags = {
        Name = "bastion_server",
        Project = "Test Assignment"
    }
}
