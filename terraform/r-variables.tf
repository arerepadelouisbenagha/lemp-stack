variable "pubkey" {
  description = "Public to server"
  type        = string
  default     = "wordpress.pub"
}

variable "USERNAME" {
  type = string
}

variable "CONNECTION" {
  type = string
}

variable "DB_USERNAME" {
  type = string
}

variable "DB_NAME" {
  type = string
}

variable "DB_PASSWORD" {
  type = string
}

variable "DB_ROOT_PASSWORD" {
  type = string
}

variable "WORDPRESSDB_PASSWORD" {
  type = string
}