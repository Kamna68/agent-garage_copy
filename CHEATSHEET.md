# AgentGarage Quick Reference Cheatsheet

## 🚀 Quick Start Commands

```bash
# Start environment (CPU only)
docker compose --profile cpu up

# Start in background
docker compose --profile cpu up -d

# With Makefile
make start          # Interactive mode
make start-d        # Background mode
```

## 🛠️ Essential Docker Commands

```bash
# Check status
docker compose ps

# View logs
docker compose logs -f              # All services
docker compose logs -f n8n          # n8n only
docker compose logs -f ollama       # Ollama only

# Stop everything
docker compose down

# Stop and remove data
docker compose down -v

# Restart a service
docker compose restart n8n
```

## 🌐 Service URLs

| Service | URL | Purpose |
|---------|-----|---------|
| n8n | http://localhost:5678 | Workflow editor |
| Open WebUI | http://localhost:3000 | Chat interface |
| Ollama API | http://localhost:11434 | LLM API |
| Qdrant | http://localhost:6333 | Vector DB |
| Jira | http://localhost:8080 | Ticket system |

## 🤖 Ollama API Examples

### Generate Text
```bash
curl http://localhost:11434/api/generate -d '{
  "model": "llama3.2",
  "prompt": "Explain recursion in one sentence",
  "stream": false
}'
```

### List Models
```bash
curl http://localhost:11434/api/tags
```

### Pull New Model
```bash
docker compose exec ollama ollama pull codellama
```

### Chat Format
```bash
curl http://localhost:11434/api/chat -d '{
  "model": "llama3.2",
  "messages": [
    {"role": "user", "content": "Why is the sky blue?"}
  ],
  "stream": false
}'
```

## 📝 n8n Workflow Testing

### Code Review Assistant
```bash
curl -X POST http://localhost:5678/webhook/code_review_assistant \
  -H "Content-Type: application/json" \
  -d '{
    "code": "def calculate(x,y):\n  return x+y",
    "language": "python"
  }'
```

### With File Input
```bash
curl -X POST http://localhost:5678/webhook/code_review_assistant \
  -H "Content-Type: application/json" \
  -d "{\"code\": \"$(cat myfile.py)\", \"language\": \"python\"}"
```

### Gherkin Generator
```bash
curl -X POST http://localhost:5678/webhook/gherkin_generator \
  -H "Content-Type: application/json" \
  -d '{
    "userStory": "As a user, I want to reset my password"
  }'
```

### Save to File
```bash
curl -X POST http://localhost:5678/webhook/gherkin_generator \
  -H "Content-Type: application/json" \
  -d '{
    "userStory": "As a user, I want to reset my password",
    "saveToFile": true
  }'
```

## 💡 n8n Expression Language

### Access Previous Node Data
```javascript
// Get data from webhook
{{ $('Webhook').item.json.body.fieldName }}

// Get from any node
{{ $('Node Name').item.json.fieldName }}

// Current node data
{{ $json.fieldName }}

// With fallback
{{ $json.fieldName || 'default value' }}
```

### Built-in Functions
```javascript
// DateTime
{{ $now.toISO() }}                    // "2025-11-19T10:30:00.000Z"
{{ $now.format('yyyy-MM-dd') }}       // "2025-11-19"
{{ $now.format('HH:mm:ss') }}         // "10:30:00"

// String operations
{{ $json.name.toUpperCase() }}
{{ $json.text.toLowerCase() }}
{{ $json.str.length }}

// JSON operations
{{ JSON.stringify($json) }}
{{ JSON.parse($json.stringField) }}

// Math
{{ Math.round($json.value) }}
{{ Math.max(1, 2, 3) }}
```

### Conditionals
```javascript
// Ternary
{{ $json.status === 'active' ? 'Yes' : 'No' }}

// Check existence
{{ $json.field ? $json.field : 'N/A' }}

// Multiple conditions
{{ $json.score > 80 ? 'High' : $json.score > 50 ? 'Medium' : 'Low' }}
```

## 🎯 Prompt Engineering Templates

### Code Review Prompt
```
You are a senior software engineer conducting a code review.

Analyze this code and provide:
1. Overall quality assessment
2. Security issues (with severity)
3. Performance concerns
4. Best practice violations
5. Specific improvement suggestions

Code:
{{ $json.code }}

Language: {{ $json.language }}

Provide structured, actionable feedback.
```

### Documentation Generator
```
You are a technical writer creating API documentation.

Generate comprehensive documentation for this code including:
1. Function/class description
2. Parameters and return types
3. Usage examples
4. Edge cases and errors

Code:
{{ $json.code }}

Format: Markdown with code blocks
```

### Test Case Generator
```
You are a QA engineer creating test scenarios.

Generate test cases for this requirement:
{{ $json.requirement }}

Include:
1. Happy path scenarios
2. Edge cases
3. Error conditions
4. Input validation tests

Format: Gherkin (Given/When/Then)
```

### Bug Report Generator
```
Analyze this error log and create a structured bug report:

Log:
{{ $json.logContent }}

Include:
1. Error summary
2. Root cause analysis
3. Steps to reproduce
4. Suggested fix
5. Priority level

Be specific and actionable.
```

## 🔧 Troubleshooting Quick Fixes

### Workflow Not Triggering
```bash
# 1. Check if activated
# Look for toggle switch in n8n UI

# 2. Check n8n logs
docker compose logs -f n8n

# 3. Test webhook directly
curl http://localhost:5678/webhook/your-webhook-path
```

### LLM Not Responding
```bash
# 1. Check Ollama is running
curl http://localhost:11434/api/tags

# 2. Check model is loaded
docker compose exec ollama ollama list

# 3. Pull model if missing
docker compose exec ollama ollama pull llama3.2

# 4. Test generation
curl http://localhost:11434/api/generate -d '{
  "model": "llama3.2",
  "prompt": "test",
  "stream": false
}'
```

### Container Won't Start
```bash
# Check logs
docker compose logs [service-name]

# Reset everything
docker compose down -v
docker compose --profile cpu up

# Check ports
netstat -an | grep -E '5678|3000|11434'
```

### Permissions Issues
```bash
# Fix script permissions
chmod +x test-environment.sh test-workflows.sh

# Fix shared directory
chmod -R 755 shared/
```

## 📊 Test & Validation

### Environment Test
```bash
./test-environment.sh
# Or with make
make test
```

### Workflow Tests
```bash
./test-workflows.sh all           # Test all
./test-workflows.sh code-review   # Code review only
./test-workflows.sh gherkin       # Gherkin only
```

### Manual API Tests
```bash
# Test Ollama
curl http://localhost:11434/api/tags | jq '.'

# Test n8n health
curl http://localhost:5678/healthz

# Test PostgreSQL
docker compose exec postgres pg_isready
```

## 💾 Data & Backups

### Backup Workflows
```bash
# Using n8n CLI
docker compose exec n8n n8n export:workflow \
  --backup --output=/backup/workflows

# Using Makefile
make n8n-backup
```

### Backup Database
```bash
# Export database
docker compose exec postgres pg_dump \
  -U root n8n > backup.sql

# Using Makefile
make db-backup
```

### Access Shared Files
```bash
# Files are in ./shared/
ls -la shared/

# Generated .feature files
ls -la shared/*.feature
```

## 🔐 Security Best Practices

```bash
# Generate secure keys
openssl rand -base64 32

# Or with Python
python3 -c "import secrets; print(secrets.token_urlsafe(32))"

# Check .env is not committed
git status | grep .env
# Should show: .env (in .gitignore)
```

## 📈 Performance Tips

```bash
# Check container resource usage
docker stats

# Limit memory (in docker-compose.yml)
deploy:
  resources:
    limits:
      memory: 4G

# Clean up unused images
docker system prune -a

# Check disk usage
docker system df
```

## 🎨 Common Patterns

### Webhook → Process → Respond
```
Webhook Trigger
  ↓
HTTP Request (Ollama)
  ↓
Set/Transform Data
  ↓
Respond to Webhook
```

### Conditional Logic
```
Process Data
  ↓
IF Node (condition)
  ├─ TRUE → Action A
  └─ FALSE → Action B
```

### Multi-Output
```
Generate Data
  ├──→ Output 1 (API response)
  ├──→ Output 2 (File save)
  └──→ Output 3 (Email notification)
```

## 🔄 Workflow Activation

```bash
# Via UI
1. Open workflow in n8n
2. Click "Active" toggle (top right)
3. Should turn green/blue

# Via API
curl -X PATCH http://localhost:5678/api/v1/workflows/{id} \
  -H "Content-Type: application/json" \
  -d '{"active": true}'
```

## 📱 Quick Makefile Reference

```bash
make help              # Show all commands
make start            # Start environment
make test             # Run tests
make logs             # View all logs
make status           # Check service status
make urls             # Show all URLs
make ollama-list      # List models
make clean            # Clean up
make quick-start      # Complete setup
```

## 🆘 Emergency Commands

```bash
# Complete reset
make hard-reset
# Or manually:
docker compose down -v
docker system prune -af --volumes

# Restart just one service
docker compose restart n8n

# Force rebuild
docker compose build --no-cache
docker compose up --force-recreate

# Check what's using ports
lsof -i :5678
lsof -i :11434
```

## 📚 File Locations

```bash
# Workflows
./n8n/backup/workflows/*.json

# Shared files
./shared/

# Logs
./logs/

# Environment config
./.env

# Test data
./shared/example_*.{py,js,java,md}
```

## 🎯 Success Indicators

```bash
# All containers running
docker compose ps
# Should show: n8n, ollama, postgres, qdrant, openwebui

# n8n accessible
curl -s http://localhost:5678 | grep -q "n8n" && echo "✓ n8n OK"

# Ollama responding
curl -s http://localhost:11434/api/tags | jq '.models[0].name'

# Workflows activated
# Check in n8n UI - workflows should have blue/green "Active" badge
```

---

## 💡 Pro Tips

1. **Use `jq`** for JSON formatting: `curl ... | jq '.'`
2. **Makefile shortcuts** save typing: `make start` vs `docker compose --profile cpu up`
3. **Test incrementally** when building workflows
4. **Save often** - n8n auto-saves but export important workflows
5. **Use sticky notes** in workflows for documentation
6. **Name nodes clearly** for easier debugging
7. **Check execution logs** in n8n for detailed debugging

---

**Need more help?** Check:
- `QUICKSTART.md` - Step-by-step tutorial
- `SOLUTION.md` - Technical explanations  
- `make help` - All available commands
