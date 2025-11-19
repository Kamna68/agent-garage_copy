# AgentGarage Setup Guide

This guide will help you get the AgentGarage environment up and running for the LLM Workflow training exercise.

## Prerequisites

- Docker and Docker Compose installed on your system
- At least 8GB of RAM available
- 10GB of free disk space
- Basic understanding of Docker and REST APIs

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/twodigits/agent-garage.git
cd agent-garage
```

### 2. Choose Your Setup Profile

Select the appropriate command based on your hardware:

#### For CPU-only systems:
```bash
docker compose --profile cpu up
```

#### For NVIDIA GPU users:
```bash
docker compose --profile gpu-nvidia up
```

#### For AMD GPU users (Linux):
```bash
docker compose --profile gpu-amd up
```

#### For Mac/Apple Silicon users:
```bash
docker compose up
```

### 3. Wait for Initialization

The first startup will take several minutes as Docker:
- Downloads all necessary images
- Initializes databases
- Pulls the Llama 3.2 model
- Sets up n8n workflows

You'll know the system is ready when you see:
```
Editor is now accessible via: http://localhost:5678/
```

## Accessing the Services

Once the containers are running, you can access:

| Service | URL | Credentials |
|---------|-----|-------------|
| **n8n** (Workflow Engine) | http://localhost:5678 | Create account on first visit |
| **Open WebUI** (Chat Interface) | http://localhost:3000 | Email: `admin@test.com`<br>Password: `S2yjzup!3` |
| **Ollama API** | http://localhost:11434 | No auth required |
| **Qdrant** (Vector DB) | http://localhost:6333 | No auth required |
| **Jira** (Optional) | http://localhost:8080 | Setup on first visit |

## Verification Steps

### 1. Verify Ollama is Running

```bash
curl http://localhost:11434/api/tags
```

You should see a JSON response listing available models (including `llama3.2`).

### 2. Test the LLM via API

```bash
curl http://localhost:11434/api/generate -d '{
  "model": "llama3.2",
  "prompt": "Hello, who are you?",
  "stream": false
}'
```

### 3. Access n8n

1. Navigate to http://localhost:5678
2. Create your account (first-time setup)
3. You should see the n8n dashboard with pre-loaded workflows

### 4. Test Open WebUI

1. Navigate to http://localhost:3000
2. Log in with the provided credentials
3. Try a simple chat message to verify the LLM is responding

## Understanding the Architecture

```
┌─────────────────┐
│   Open WebUI    │  (Chat Interface)
│  localhost:3000 │
└────────┬────────┘
         │
         v
┌─────────────────┐
│     Ollama      │  (LLM Runtime)
│  localhost:11434│
└─────────────────┘
         ^
         │
┌────────┴────────┐
│       n8n       │  (Workflow Automation)
│  localhost:5678 │
└─────────────────┘
```

## Environment Configuration

The `.env` file contains important configuration:

```env
# PostgreSQL (used by n8n)
POSTGRES_USER=root
POSTGRES_PASSWORD=password
POSTGRES_DB=n8n

# n8n Security Keys
N8N_ENCRYPTION_KEY=super-secret-key
N8N_USER_MANAGEMENT_JWT_SECRET=even-more-secret

# Jira Integration (optional)
JIRA_PERSONAL_TOKEN=your_personal_access_token
JIRA_PROJECT=project_key
JIRA_USERNAME=your_jira_username
```

## Troubleshooting

### Container won't start
```bash
# Check logs
docker compose logs -f

# Restart specific service
docker compose restart n8n
```

### LLM model not loading
```bash
# Check Ollama logs
docker compose logs ollama

# Manually pull model
docker compose exec ollama ollama pull llama3.2
```

### Port conflicts
If ports 5678, 3000, or 11434 are already in use, you can modify them in `docker-compose.yml`.

### Reset everything
```bash
# Stop and remove all containers and volumes
docker compose down -v

# Start fresh
docker compose --profile cpu up
```

## Changing the LLM Model

To use a different model, edit `docker-compose.yml`:

```yaml
x-init-ollama: &init-ollama
  # ... other config ...
  command:
    - "-c"
    - "sleep 3; ollama pull llama3.2"  # Change to desired model
```

Available models: https://ollama.com/library

## Next Steps

Once your environment is verified and running:
1. Read `EXERCISE.md` for the training exercise details
2. Check `QUICKSTART.md` for step-by-step workflow creation
3. Explore the pre-built workflows in n8n
4. Start building your own SDLC automation!

## Stopping the Environment

```bash
# Stop all containers (data persists)
docker compose down

# Stop and remove all data
docker compose down -v
```

## Getting Help

- n8n Documentation: https://docs.n8n.io
- Ollama Documentation: https://github.com/ollama/ollama
- AgentGarage Issues: https://github.com/twodigits/agent-garage/issues
