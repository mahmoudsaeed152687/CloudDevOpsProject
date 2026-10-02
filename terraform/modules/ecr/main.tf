resource "aws_ecr_repository" "frontend" {
  name = "${var.project_name}-frontend"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.project_name}-frontend"
  }
}

resource "aws_ecr_repository" "auth_service" {
  name = "${var.project_name}-auth-service"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.project_name}-auth-service"
  }
}

resource "aws_ecr_repository" "roadmap_service" {
  name = "${var.project_name}-roadmap-service"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.project_name}-roadmap-service"
  }
}
