output "web_public_ip" {

  description = "public ip address of the web server"

  value = aws_eip.tutorial_web_eip[0].public_ip

  depends_on = [aws_eip.tutorial_web_eip]

}


output "web_public_dns" {
  description = "public dns of the web server "


  value = aws_eip.tutorial_web_eip[0].public_dns

  depends_on = [aws_eip.tutorial_web_eip]
}



output "database_endpoint" {
  description = "endpoint of the db"
  value       = aws_db_instance.tutorial_database.address
}



output "database_port" {
  description = "port of the db"
  value       = aws_db_instance.tutorial_database.port
}
