
.PHONY: up destroy

up:
	bash fetch_ips.sh
	terraform init
	terraform apply -var-file=dynamic_ips.tfvars.json -auto-approve

destroy:
	terraform destroy -var-file=dynamic_ips.tfvars.json -auto-approve
