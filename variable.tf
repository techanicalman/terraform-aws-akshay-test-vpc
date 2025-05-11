variable "vpc_config" {
  description = "to get the cidr and name of vpc form user"
  type = object({
    cidr_block = string
    name = string
  })
}

variable "subnet_config" {
  description = "get the cidr and az for subnrt"
  type = map (object({
    cidr_block = string
    az = string
    public = optional( bool ,false)
  }))
} 