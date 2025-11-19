# AgentGarage - Makefile for Common Tasks
# Makes it easier to manage the environment without memorizing docker compose commands

.PHONY: help start stop restart logs test test-workflows clean status ps setup

# Default target - show help
.DEFAULT_GOAL := help

# Detect hardware profile
PROFILE ?= cpu

##@ General Commands

help: ## Display this help message
	@echo "AgentGarage - Available Commands"
	@echo "================================="
	@echo ""
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Environment Management

start: ## Start the AgentGarage environment
	@echo "🚀 Starting AgentGarage with $(PROFILE) profile..."
	docker compose --profile $(PROFILE) up

start-d: ## Start in detached mode (background)
	@echo "🚀 Starting AgentGarage in background..."
	docker compose --profile $(PROFILE) up -d

start-gpu: ## Start with NVIDIA GPU support
	@echo "🚀 Starting with NVIDIA GPU..."
	docker compose --profile gpu-nvidia up

start-gpu-d: ## Start with GPU in background
	@echo "🚀 Starting with NVIDIA GPU in background..."
	docker compose --profile gpu-nvidia up -d

stop: ## Stop all containers
	@echo "🛑 Stopping AgentGarage..."
	docker compose down

restart: ## Restart the environment
	@echo "🔄 Restarting AgentGarage..."
	docker compose down
	docker compose --profile $(PROFILE) up

clean: ## Stop and remove all containers, volumes, and networks
	@echo "🧹 Cleaning up everything..."
	@read -p "This will delete all data. Are you sure? [y/N] " -n 1 -r; \
	echo ""; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ Cleanup complete"; \
	else \
		echo "❌ Cleanup cancelled"; \
	fi

##@ Status & Monitoring

status: ## Show status of all services
	@echo "📊 Service Status:"
	@docker compose ps

ps: status ## Alias for status

logs: ## Show logs from all services (follow mode)
	docker compose logs -f

logs-n8n: ## Show n8n logs only
	docker compose logs -f n8n

logs-ollama: ## Show Ollama logs only
	docker compose logs -f ollama

logs-openwebui: ## Show Open WebUI logs only
	docker compose logs -f openwebui

##@ Testing & Validation

test: ## Run environment tests
	@echo "🧪 Testing environment..."
	@./test-environment.sh

test-workflows: ## Test the example workflows
	@echo "🧪 Testing workflows..."
	@./test-workflows.sh

test-code-review: ## Test Code Review Assistant only
	@echo "🧪 Testing Code Review Assistant..."
	@./test-workflows.sh code-review

test-gherkin: ## Test Gherkin Generator only
	@echo "🧪 Testing Gherkin Generator..."
	@./test-workflows.sh gherkin

##@ Ollama Management

ollama-pull: ## Pull a new model (usage: make ollama-pull MODEL=llama3.2)
	@if [ -z "$(MODEL)" ]; then \
		echo "❌ Please specify MODEL. Example: make ollama-pull MODEL=llama3.2"; \
		exit 1; \
	fi
	@echo "📥 Pulling model: $(MODEL)..."
	docker compose exec ollama ollama pull $(MODEL)

ollama-list: ## List available models
	@echo "📋 Available models:"
	@docker compose exec ollama ollama list

ollama-rm: ## Remove a model (usage: make ollama-rm MODEL=llama3.2)
	@if [ -z "$(MODEL)" ]; then \
		echo "❌ Please specify MODEL. Example: make ollama-rm MODEL=llama3.2"; \
		exit 1; \
	fi
	@echo "🗑️  Removing model: $(MODEL)..."
	docker compose exec ollama ollama rm $(MODEL)

ollama-test: ## Test Ollama API
	@echo "🧪 Testing Ollama API..."
	@curl -s http://localhost:11434/api/tags | jq '.' || echo "❌ Ollama not responding"

##@ n8n Management

n8n-backup: ## Backup n8n workflows
	@echo "💾 Backing up n8n workflows..."
	@mkdir -p ./backups/workflows-$$(date +%Y%m%d_%H%M%S)
	@docker compose exec n8n n8n export:workflow --backup --output=/backup/workflows
	@echo "✅ Backup complete"

n8n-reset: ## Reset n8n (WARNING: deletes all workflows and data)
	@echo "⚠️  WARNING: This will delete all n8n workflows and data!"
	@read -p "Are you sure? Type 'yes' to confirm: " confirm; \
	if [ "$$confirm" = "yes" ]; then \
		docker compose down; \
		docker volume rm agent-garage_copy_n8n_storage 2>/dev/null || true; \
		echo "✅ n8n data reset"; \
	else \
		echo "❌ Reset cancelled"; \
	fi

##@ Database Management

db-backup: ## Backup PostgreSQL database
	@echo "💾 Backing up database..."
	@mkdir -p ./backups
	@docker compose exec postgres pg_dump -U $(shell grep POSTGRES_USER .env | cut -d '=' -f2) n8n > ./backups/db-backup-$$(date +%Y%m%d_%H%M%S).sql
	@echo "✅ Database backed up"

db-shell: ## Open PostgreSQL shell
	@echo "🐘 Opening PostgreSQL shell..."
	@docker compose exec postgres psql -U $(shell grep POSTGRES_USER .env | cut -d '=' -f2) -d n8n

##@ Development

shell-n8n: ## Open shell in n8n container
	@docker compose exec n8n /bin/sh

shell-ollama: ## Open shell in Ollama container
	@docker compose exec ollama /bin/bash

shell-postgres: ## Open shell in PostgreSQL container
	@docker compose exec postgres /bin/bash

##@ URLs & Access

urls: ## Show all service URLs
	@echo ""
	@echo "🌐 Service URLs:"
	@echo "================================="
	@echo "n8n:          http://localhost:5678"
	@echo "Open WebUI:   http://localhost:3000"
	@echo "Ollama API:   http://localhost:11434"
	@echo "Qdrant:       http://localhost:6333"
	@echo "Jira:         http://localhost:8080"
	@echo ""

open-n8n: ## Open n8n in browser
	@echo "🌐 Opening n8n..."
	@open http://localhost:5678 2>/dev/null || xdg-open http://localhost:5678 2>/dev/null || echo "Please open: http://localhost:5678"

open-webui: ## Open WebUI in browser
	@echo "🌐 Opening Open WebUI..."
	@open http://localhost:3000 2>/dev/null || xdg-open http://localhost:3000 2>/dev/null || echo "Please open: http://localhost:3000"

##@ Setup & Configuration

setup: ## Initial setup (copy .env.example to .env)
	@if [ -f .env ]; then \
		echo "⚠️  .env file already exists!"; \
		read -p "Overwrite? [y/N] " -n 1 -r; \
		echo ""; \
		if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
			cp .env.example .env; \
			echo "✅ .env file created. Please edit it with your values."; \
		fi; \
	else \
		cp .env.example .env; \
		echo "✅ .env file created. Please edit it with your values."; \
	fi

check-env: ## Verify .env file exists
	@if [ ! -f .env ]; then \
		echo "❌ .env file not found!"; \
		echo "Run: make setup"; \
		exit 1; \
	else \
		echo "✅ .env file exists"; \
	fi

generate-keys: ## Generate secure random keys for .env
	@echo "🔑 Generating secure keys..."
	@echo ""
	@echo "N8N_ENCRYPTION_KEY:"
	@openssl rand -base64 32
	@echo ""
	@echo "N8N_USER_MANAGEMENT_JWT_SECRET:"
	@openssl rand -base64 32
	@echo ""
	@echo "Copy these to your .env file"

##@ Quick Actions

quick-start: setup check-env start-d test urls ## Complete setup and start (recommended for first time)
	@echo ""
	@echo "✅ AgentGarage is running!"
	@echo "Next steps:"
	@echo "  1. Open n8n: http://localhost:5678"
	@echo "  2. Read QUICKSTART.md"
	@echo ""

##@ Documentation

docs: ## Open documentation in browser
	@echo "📚 Documentation files:"
	@echo "  START_HERE.md   - Quick start"
	@echo "  TRAINING.md     - Overview"
	@echo "  QUICKSTART.md   - Step-by-step guide"
	@echo "  SETUP.md        - Setup details"
	@echo "  SOLUTION.md     - Technical deep dive"

##@ Troubleshooting

fix-permissions: ## Fix file permissions
	@echo "🔧 Fixing permissions..."
	@chmod +x test-environment.sh test-workflows.sh
	@echo "✅ Permissions fixed"

rebuild: ## Rebuild all containers
	@echo "🔨 Rebuilding containers..."
	docker compose build --no-cache
	docker compose --profile $(PROFILE) up

hard-reset: ## Nuclear option - remove everything and start fresh
	@echo "☢️  WARNING: This will delete EVERYTHING!"
	@read -p "Are you absolutely sure? Type 'DELETE' to confirm: " confirm; \
	if [ "$$confirm" = "DELETE" ]; then \
		docker compose down -v; \
		docker system prune -af --volumes; \
		echo "✅ Complete reset done. Run 'make quick-start' to begin again."; \
	else \
		echo "❌ Reset cancelled"; \
	fi

##@ Examples

example-curl: ## Show example curl commands
	@echo "📋 Example curl commands:"
	@echo ""
	@echo "Code Review:"
	@echo 'curl -X POST http://localhost:5678/webhook/code_review_assistant \'
	@echo '  -H "Content-Type: application/json" \'
	@echo '  -d '"'"'{"code": "def add(a,b):\\n  return a+b", "language": "python"}'"'"''
	@echo ""
	@echo "Gherkin Generator:"
	@echo 'curl -X POST http://localhost:5678/webhook/gherkin_generator \'
	@echo '  -H "Content-Type: application/json" \'
	@echo '  -d '"'"'{"userStory": "As a user, I want to login"}'"'"''
	@echo ""

# Platform-specific settings
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    OPEN_CMD = open
else
    OPEN_CMD = xdg-open
endif
