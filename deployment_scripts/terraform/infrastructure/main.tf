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
    cidr_block = cidrsubnet("10.0.2.0/8", 8, count.index)
    availability_zone = join("", ["${var.aws_region}", "${var.availability_zones[count.index]}"])

    tags = {
        Name = "test_assignment_subnet",
        Project = "Test Assignment"
    }    
}

resource "aws_instance" "prometheus_server" {
  ami           = "ami-034568121cfdea9c3"
  instance_type = "t3.micro"
  subnet_id     = element(aws_subnet.test_assignment_subnet.*.id, 0)

  tags = {
    Name = "prometheus_server",
    Project = "Test Assignment"
  }
}

resource "aws_instance" "k3s_server" {
    ami           = "ami-034568121cfdea9c3"
    instance_type = "t3.micro"
    subnet_id     = element(aws_subnet.test_assignment_subnet.*.id, 1)

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
