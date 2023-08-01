# Refer script.yml for clout-init template.
data "template_file" "user_data" {
  template   = file("../scripts/script.yml")
  depends_on = [aws_db_instance.drupal]
  vars = {
    script_path         = "/var/lib/cloud/scripts/per-instance/drupal_composer_install.sh"
    drupal_username     = "${aws_db_instance.drupal.username}"
    drupal_password     = "drupalpwd"
    rds_host            = "${aws_db_instance.drupal.address}"
    port                = "${aws_db_instance.drupal.port}"
    drupal_path         = "/var/www/drupal"
    drupal_public_files = "web/sites/default/files"
    drupal_db_name      = "${aws_db_instance.drupal.db_name}"
  }
}

resource "aws_instance" "drupal" {
  depends_on = [aws_db_instance.drupal, aws_security_group.drupal_ec2, aws_subnet.drupal_a, tls_private_key.drupal, aws_iam_instance_profile.ec2_profile]
  # Image
  ami = data.aws_ami.ubuntu.id
  # Size
  instance_type = var.instance_type
  # Apply SSH key
  key_name = var.key_name
  # Firewall rules
  vpc_security_group_ids = ["${aws_security_group.drupal_ec2.id}"]
  # Put this one in availability zone a
  subnet_id = aws_subnet.drupal_a.id
  # Tag
  tags = {
    Name = "Drupal"
  }
  # User data for configuration.
  user_data = data.template_file.user_data.rendered
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
}
