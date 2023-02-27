data "cloudinit_config" "wordpress" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    filename     = "wordpress"
    content = templatefile("../templates/install.sh",

      {
        USERNAME             = var.USERNAME
        CONNECTION           = var.CONNECTION
        DB_USERNAME          = var.DB_USERNAME
        DB_NAME              = var.DB_NAME
        DB_PASSWORD          = var.DB_PASSWORD
        DB_ROOT_PASSWORD     = var.DB_ROOT_PASSWORD
        WORDPRESSDB_PASSWORD = var.WORDPRESSDB_PASSWORD
    })
  }
}