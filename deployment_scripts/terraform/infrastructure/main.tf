resource "aws_vpc" "test_assignment_vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "test_assignment_vpc",
        Project = "Test Assignment"
    }
}

resource "aws_subnet" "test_assignment_subnet" {
    vpc_id = aws_vpc.test_assignment_vpc.id
    count = 3
    cidr_block = cidrsubnet("10.0.2.0/24", 8, count.index)
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

resource "aws_iam_role" "eks_cluster_role" {
    name = "test_assignment_eks_cluster_role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = [
                    "sts:AssumeRole"
                ]
                Effect = "Allow"
                Principal = {
                    Service = "eks.amazonaws.com"
                }
            },
        ]
    })

    tags = {
      "name" = "test_assignment_eks_cluster_role",
      "project" = "Test Assignment"
    }
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_eks_cluster" "eks_cluster" {
    name = "test_assignment_cluster"
    role_arn = aws_iam_role.eks_cluster_role.arn
    version = "1.33"

    vpc_config {
        subnet_ids = aws_subnet.test_assignment_subnet.*.id
    }

    depends_on = [ aws_iam_role_policy_attachment.cluster_policy ]

    tags = {
        Name = "test_assignment_cluster",
        Project = "Test Assignment"
    }    
}

resource "aws_iam_role" "eks_node_role" {
    name = "eks_node_role"

    assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }]
  })
    
    tags = {
      "name" = "test_assignment_eks_node_role",
      "project" = "Test Assignment"
    }
}

resource "aws_iam_role_policy_attachment" "node_policy" {
    for_each = toset([
        "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
        "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    ])

    policy_arn = each.value
    role = aws_iam_role.eks_node_role.name

    depends_on = [ aws_iam_role.eks_node_role ]
}

resource "aws_eks_node_group" "cluster_node_group" {
    cluster_name = aws_eks_cluster.eks_cluster.name
    node_role_arn = aws_iam_role.eks_node_role.arn
    node_group_name = "test_assignment_node_group"

    subnet_ids = aws_subnet.test_assignment_subnet.*.id

    scaling_config {
        desired_size = 1
        max_size = 1
        min_size = 1
    }

    instance_types = [ "t3.micro" ]
    
    depends_on = [ aws_eks_cluster.eks_cluster ]
    
    tags = {
        Name = "test_assignment_node_group",
        Project = "Test Assignment"
    }
}
