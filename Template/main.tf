resource "aws_launch_template" "your_eks_launch_template" {
  name = "fabric-dev-template"

  # vpc_security_group_ids = [var.your_security_group.id, aws_eks_cluster.your-eks-cluster.vpc_config[0].cluster_security_group_id]

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 20
      volume_type = "gp3"
    }
  }

  image_id = "ami-0ebf01230aca0c60f"
  instance_type = "t3.large"
  # user_data = ""

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "fabric-dev"
      Environment = "dev"
    }
  }
}