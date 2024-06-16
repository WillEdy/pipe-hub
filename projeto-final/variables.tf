variable "region" {
  type    = string
  default = "us-east-1"
}

variable "aws_access_key" {
  description = "Access Key ID da AWS"
  type        = string
}

variable "aws_secret_key" {
  description = "Secret Access Key da AWS"
  type        = string
}

variable "project_name" {
  description = "O nome do projeto baseado no ambiente de execução"
  type        = string
  default     = "willedy-projeto-terraform"
}

variable "environment" {
  description = "Variavel do workspace"
  default     = "prd"
}

variable "vpc_cidr" {
  description = "Bloco cidr para a vpc"
  default     = "10.0.0.0/16"
}