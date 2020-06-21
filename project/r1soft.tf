 resource "null_resource" "mine" {
    triggers = {
        always_run = "${timestamp()}"
    }
    depends_on = ["aws_instance.r1soft"]
    provisioner   "file" {
    connection {
        host        = "aws_instance.r1soft.public_ip"
        type        = "ssh"
        user        = "ec2-user"
        private_key = "${file("~/.ssh/id_rsa")}"
    }
    source = "r1soft.repo"
    destination = "/etc/yum.repos.d"
  },

provisioner   "remote-exec" {
    connection {
        host        = "aws_instance.r1soft.public_ip"
        type        = "ssh"
        user        = "ec2-user"
        private_key = "${file("~/.ssh/id_rsa")}"
    }
    inline = [
      "sudo yum install r1soft-cdp-enterprise-server -y",
      "sudo /etc/init.d/cdp-agent restart",
      "sudo r1soft-setup --user admin --pass redhat --http-port 8080"
    ]
  }
 }