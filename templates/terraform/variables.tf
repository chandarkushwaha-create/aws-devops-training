# AWS DevOps Batch 4 - Terraform Variables
# Variable definitions for the infrastructure template

# AWS Configuration
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "aws-devops-batch4"
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "devops-team"
}

variable "cost_center" {
  description = "Cost center for billing"
  type        = string
  default     = "devops-training"
}

# VPC Configuration
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones to use"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "data_subnet_cidrs" {
  description = "CIDR blocks for data subnets"
  type        = list(string)
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use single NAT Gateway for cost optimization"
  type        = bool
  default     = false
}

# Application Configuration
variable "app_port" {
  description = "Port for the application"
  type        = number
  default     = 3000
}

variable "api_port" {
  description = "Port for the API"
  type        = number
  default     = 8000
}

variable "health_check_path" {
  description = "Health check path for the application"
  type        = string
  default     = "/health"
}

variable "app_count" {
  description = "Number of application instances"
  type        = number
  default     = 2
  
  validation {
    condition     = var.app_count >= 1 && var.app_count <= 10
    error_message = "App count must be between 1 and 10."
  }
}

# ECS Configuration
variable "task_cpu" {
  description = "CPU units for ECS task"
  type        = number
  default     = 256
  
  validation {
    condition     = contains([256, 512, 1024, 2048, 4096], var.task_cpu)
    error_message = "Task CPU must be one of: 256, 512, 1024, 2048, 4096."
  }
}

variable "task_memory" {
  description = "Memory for ECS task (MB)"
  type        = number
  default     = 512
  
  validation {
    condition     = contains([512, 1024, 2048, 3072, 4096, 5120, 6144, 7168, 8192], var.task_memory)
    error_message = "Task memory must be one of: 512, 1024, 2048, 3072, 4096, 5120, 6144, 7168, 8192."
  }
}

# Database Configuration
variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
  default     = "changeme123!"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage for RDS (GB)"
  type        = number
  default     = 20
  
  validation {
    condition     = var.db_allocated_storage >= 20 && var.db_allocated_storage <= 65536
    error_message = "DB allocated storage must be between 20 and 65536 GB."
  }
}

variable "db_max_allocated_storage" {
  description = "Maximum allocated storage for RDS (GB)"
  type        = number
  default     = 100
  
  validation {
    condition     = var.db_max_allocated_storage >= var.db_allocated_storage
    error_message = "DB max allocated storage must be greater than or equal to allocated storage."
  }
}

# Redis Configuration
variable "redis_node_type" {
  description = "ElastiCache Redis node type"
  type        = string
  default     = "cache.t3.micro"
}

# SSL Certificate
variable "certificate_arn" {
  description = "ARN of SSL certificate for HTTPS"
  type        = string
  default     = ""
}

# Auto Scaling Configuration
variable "enable_auto_scaling" {
  description = "Enable auto scaling for ECS service"
  type        = bool
  default     = true
}

variable "min_capacity" {
  description = "Minimum capacity for auto scaling"
  type        = number
  default     = 1
  
  validation {
    condition     = var.min_capacity >= 1
    error_message = "Min capacity must be at least 1."
  }
}

variable "max_capacity" {
  description = "Maximum capacity for auto scaling"
  type        = number
  default     = 4
  
  validation {
    condition     = var.max_capacity >= var.min_capacity
    error_message = "Max capacity must be greater than or equal to min capacity."
  }
}

variable "scale_up_threshold" {
  description = "CPU threshold for scaling up"
  type        = number
  default     = 70
  
  validation {
    condition     = var.scale_up_threshold >= 0 && var.scale_up_threshold <= 100
    error_message = "Scale up threshold must be between 0 and 100."
  }
}

variable "scale_down_threshold" {
  description = "CPU threshold for scaling down"
  type        = number
  default     = 30
  
  validation {
    condition     = var.scale_down_threshold >= 0 && var.scale_down_threshold <= 100
    error_message = "Scale down threshold must be between 0 and 100."
  }
}

# Monitoring Configuration
variable "enable_cloudwatch_alarms" {
  description = "Enable CloudWatch alarms"
  type        = bool
  default     = true
}

variable "alarm_email" {
  description = "Email address for CloudWatch alarms"
  type        = string
  default     = "alerts@example.com"
}

# Backup Configuration
variable "enable_backup" {
  description = "Enable backup for RDS"
  type        = bool
  default     = true
}

variable "backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
  
  validation {
    condition     = var.backup_retention_period >= 0 && var.backup_retention_period <= 35
    error_message = "Backup retention period must be between 0 and 35 days."
  }
}

# Security Configuration
variable "enable_vpc_flow_logs" {
  description = "Enable VPC Flow Logs"
  type        = bool
  default     = true
}

variable "enable_cloudtrail" {
  description = "Enable CloudTrail"
  type        = bool
  default     = true
}

variable "enable_guardduty" {
  description = "Enable GuardDuty"
  type        = bool
  default     = false
}

# Tags
variable "additional_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
