resource "aws_elastic_beanstalk_application" "api_donations_beanstalk" {
  name        = "api-donations"
  description = "API for FATEC's TG"
  depends_on = [
    aws_s3_bucket.api_donations_s3
  ]
}

resource "aws_elastic_beanstalk_environment" "api_donations_prd" {
  name                = "api-donations-prd"
  application         = aws_elastic_beanstalk_application.api_donations_beanstalk.name
  solution_stack_name = "64bit Amazon Linux 2 v3.4.2 running Corretto 17"
  depends_on = [
    aws_elastic_beanstalk_application.api_donations_beanstalk
  ]

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.api_donations_vpc.id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = aws_subnet.api_donations_subnet.id
  }

  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = "t2.micro"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.api_donations_sg.id
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.api_donations_db_sg.id
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DATABASE_URL"
    value     = "jdbc:mysql://${aws_db_instance.api_donations_rds.endpoint}/${aws_db_instance.api_donations_rds.db_name}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DATABASE_USER"
    value     = var.DATABASE_USER
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DATABASE_PASSWORD"
    value     = var.DATABASE_PASSWORD
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SPRING_PROFILES_ACTIVE"
    value     = var.ENVIRONMENT
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PORT"
    value     = var.PORT
  }
}
