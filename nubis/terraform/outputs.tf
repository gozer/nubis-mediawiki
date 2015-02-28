output "instance-id" {
    value = "${aws_instance.web_server.id}"
}
output "ip" {
    value = "${aws_instance.web_server.public_ip}"
}
output "elb_cname" {
    value = "http://dualstack.${aws_elb.external.dns_name}/"
}
output "zone_id" {
    value = "${aws_route53_record.www.zone_id}"
}
