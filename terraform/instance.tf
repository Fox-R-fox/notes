provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "devops_instance" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.medium"
  key_name      = "my-key"

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y docker.io kubectl
              systemctl start docker
              systemctl enable docker
              curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
              echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
              apt-get update
              apt-get install -y jenkins
              systemctl start jenkins
              systemctl enable jenkins
              EOF

  tags = {
    Name = "DevOps-Instance"
  }
}