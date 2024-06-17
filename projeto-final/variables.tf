variable "project_name" {
  description = "O nome do projeto baseado no ambiente de execução"
  type        = string
  default     = "willedy-projeto-terraform-pipeline"
}

variable "environment" {
  description = "Variavel do workspace"
  default     = "prd"
}

variable "vpc_cidr" {
  description = "Bloco cidr para a vpc"
  default     = "10.0.0.0/16"
}