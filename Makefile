SHELL := /bin/bash
.PHONY: help

help: ## show this help dynamically
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@egrep "^(.+)\:\ ##\ (.+)" ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

build: ## build the docker container
	docker compose build

up: ## start the docker container
	docker compose up --wait

down: ## stop the docker container
	docker compose down

restart: ## restart the docker container
	docker compose restart

status: ## show the status of the docker container
	docker compose ps

cert: ## create a trust self-signed certificate
	mkcert -install -key-file certs/dev.local.key.pem -cert-file certs/dev.local.crt.pem dev.local '*.dev.local' 127.0.0.1 ::1
