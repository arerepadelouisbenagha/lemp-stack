resource "aws_key_pair" "ssh_key" {
  key_name   = "keypair"
  public_key = file(var.pubkey)
}

resource "aws_instance" "wordpress" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.wordpress-sg.id]
  key_name               = aws_key_pair.ssh_key.key_name
  user_data_base64       = data.cloudinit_config.wordpress.rendered
  tags                   = { Name = "wordpress", Env = "dev" }
}