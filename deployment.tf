provider "aws" {
  access_key = "PUT ACCESS KEY HERE"
  secret_key = "PUT SECRET KEY HERE"
  region     = "us-east-1"
}

resource "aws_instance" "escsredis" {
  ami           = "PUT AMI ID HERE based on UBUNTU 16.04"
  count         = 3
  instance_type = "t2.micro"
  provisioner "file" {
    source      = "conf/"
    destination = "/home/ubuntu/"

    connection {
        type     = "ssh"
        user     = "ubuntu"
        private_key = "${file("private_key_file.pem")}"
    }
  }
}

resource "null_resource" "escsredis" {
  count = 3

  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = "${file("private_key_file.pem")}"
    host = "${element(aws_instance.escsredis.*.public_ip, count.index)}"
  }

  provisioner "remote-exec" {
    inline = [
      "echo '${element(aws_instance.escsredis.*.private_ip, count.index)}' > /tmp/myip",
      "echo '${join(",", aws_instance.escsredis.*.private_ip)}' > /tmp/nodeips",
      "sudo bash /home/ubuntu/prepareconf.sh"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo bash /home/ubuntu/startservices.sh"
    ]
  }

  provisioner "local-exec" {
    command = "echo '${element(aws_instance.escsredis.*.private_ip, count.index)}' >> /tmp/myip"
  }

  provisioner "local-exec" {
    command = "echo '${join(",", aws_instance.escsredis.*.private_ip)}' > /tmp/nodeips"
  }

  provisioner "local-exec" {
    command = "echo '${join(",", aws_instance.escsredis.*.public_ip)}' > /tmp/publicnodeips"
  }
}
