# Configure the Consul provider
provider "consul" {
    address    = "${var.consul}:8500"
    datacenter = "${var.region}"
}

# Consul config outputs
resource "consul_keys" "app_config" {
    datacenter = "${var.region}"

    key {
        name   = "elb_cname"
        path   = "${var.project}/${var.environment}/elb_cname"
        value  = "http://dualstack.${aws_elb.external.dns_name}/"
        delete = "true"
    }
    key {
        name   = "instance-id"
        path   = "${var.project}/${var.environment}/instance-id"
        value  = "${aws_instance.web_server.id}"
        delete = "true"
    }
    key {
        name   = "wgServer"
        path   = "${var.project}/${var.environment}/config/wgServer"
        value  = "http://www.mediawiki.nubis.allizom.org"
        delete = "true"
    }
    key {
        name   = "wgDBserver"
        path   = "${var.project}/${var.environment}/config/wgDBserver"
        value  = "${aws_db_instance.default.address}"
        delete = "true"
    }
    key {
        name   = "wgDBname"
        path   = "${var.project}/${var.environment}/config/wgDBname"
        value  = "${var.project}"
        delete = "true"
    }
    key {
        name   = "wgDBuser"
        path   = "${var.project}/${var.environment}/config/wgDBuser"
        value  = "${var.project}"
        delete = "true"
    }

}

# Configure the AWS Provider
provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region     = "${var.region}"
}

resource "aws_security_group" "inbound_traffic" {
  name        = "${var.project}-${var.environment}-${var.release}.${var.build}-inbound_traffic"
  description = "Allow inbound traffic for ${var.project} in ${var.environment}"

  # Allow port 80 traffic for testing
  # In production all traffic routes through the loaad balancer
  ingress {
      from_port   = 0
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  # Rule allowing ssh access (remove for production)
  ingress {
      from_port   = 0
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  # These rules (8300 & 8303) are for consul communication
  ingress {
      from_port   = 8300
      to_port     = 8303
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port   = 8300
      to_port     = 8303
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a web server
resource "aws_instance" "web_server" {
#    ami = "${consul_keys.app.var.ami}"
    ami = "${lookup(var.amis, var.region)}"

    tags {
        Name = "${var.key_name} ${var.project} web ${var.environment} ${var.release}.${var.build}"
    }

    key_name = "${var.key_name}"

    instance_type = "m3.medium"

    security_groups = [
        "${aws_security_group.inbound_traffic.name}"
    ]

    user_data = "NUBIS_PROJECT=${var.project}\nNUBIS_ENVIRONMENT=${var.environment}\nCONSUL_PUBLIC=1\nCONSUL_DC=${var.region}\nCONSUL_SECRET=${var.consul_secret}\nCONSUL_JOIN=${var.consul}"

}

# Create a migration instance
resource "aws_instance" "migrator" {
    ami = "${lookup(var.amis, var.region)}"

    tags {
        Name = "${var.project} migrator ${var.environment} v${var.release}.${var.build}"
    }

    key_name = "${var.key_name}"

    instance_type = "m3.medium"

    security_groups = [
        "${aws_security_group.inbound_traffic.name}"
    ]

    depends_on = [
        "aws_db_instance.default"
    ]

    provisioner "remote-exec" {
        connection {
            user     = "ubuntu"
            key_file = "${var.key_file}"
        }
        inline = [
            "sudo /usr/local/bin/nubis-migrate",
            "sudo poweroff"
        ]
    }

    user_data = "NUBIS_PROJECT=${var.project}\nNUBIS_ENVIRONMENT=${var.environment}\nCONSUL_PUBLIC=1\nCONSUL_DC=${var.region}\nCONSUL_SECRET=${var.consul_secret}\nCONSUL_JOIN=${var.consul}"
}

resource "aws_db_security_group" "rds_traffic" {
    name = "${var.project}-${var.environment}-${var.release}-${var.build}-rds_traffic"
    description = "Allow rds traffic for ${var.project} in ${var.environment}"

    ingress {
        security_group_owner_id = "579398555466"
        security_group_name = "${aws_security_group.inbound_traffic.name}"
    }
}

resource "aws_db_instance" "default" {
    name              = "${var.project}"
    identifier        = "${var.project}-rds-${var.environment}-${var.release}-${var.build}"
    allocated_storage = 10
    engine            = "mysql"
    engine_version    = "5.6.22"
    instance_class    = "db.t1.micro"
    username          = "${var.project}"
    password          = "provisioner_password"
    security_group_names = ["${aws_db_security_group.rds_traffic.name}"]
}

# Create a new load balancer
resource "aws_elb" "external" {
    name = "${var.project}-elb-${var.environment}-${var.release}-${var.build}"
#    availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c" ]
    availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c" ]

    listener {
        instance_port     = 80
        instance_protocol = "http"
        lb_port           = 80
        lb_protocol       = "http"
    }

    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 3
        target              = "HTTP:80/Special%3AVersion"
        interval            = 30
    }

    instances = ["${aws_instance.web_server.id}"]
    cross_zone_load_balancing = true
}

resource "aws_route53_zone" "primary" {
   name = "${var.project}.${var.dns_zone}"
}

resource "aws_route53_record" "www" {
   zone_id = "${aws_route53_zone.primary.zone_id}"
   name = "www.${aws_route53_zone.primary.name}"
   type = "CNAME"
   ttl = "300"
   records = ["${aws_elb.external.dns_name}"]
}

