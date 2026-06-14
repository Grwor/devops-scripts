Terraform AWS Інфраструктура

Що створюється
- Jenkins Master (t3.small) — Apache + Jenkins
- Jenkins Slave (t3.micro) — Java
- Web Server (t3.micro) — Apache + WildFly

Вимоги
- Terraform встановлений
- AWS CLI налаштований (aws configure)

Як створити інфраструктуру
terraform init
terraform plan
terraform apply

Після apply отримаєш IP адреси всіх серверів.

Як видалити інфраструктуру
terraform destroy
