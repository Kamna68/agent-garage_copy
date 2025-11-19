# Working AI Workflows (qwen2:0.5b)

## ✅ Active Workflows

### 1. User Story Creator
**Webhook:** `POST http://localhost:5678/webhook/assistant_on_creating_user_stories`

**Example:**
```bash
curl -X POST http://localhost:5678/webhook/assistant_on_creating_user_stories \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Create a user story for password reset",
    "sessionId": "user-123"
  }'
```

**In Open WebUI:** Just type: "Create a user story for login feature"

---

### 2. Test Data Generator
**Webhook:** `POST http://localhost:5678/webhook/test_data_generator`

**Example:**
```bash
curl -X POST http://localhost:5678/webhook/test_data_generator \
  -H "Content-Type: application/json" \
  -d '{
    "schema": "users: id, name, email, age",
    "recordCount": 5,
    "outputFormat": "JSON"
  }'
```

**In Open WebUI:** "Generate 5 test users with name, email, age"

---

### 3. AI Documentation Generator
**Webhook:** `POST http://localhost:5678/webhook/generate_docs`

**Example:**
```bash
curl -X POST http://localhost:5678/webhook/generate_docs \
  -H "Content-Type: application/json" \
  -d '{
    "code": "def add(a, b): return a + b",
    "type": "legacy_module.py",
    "format": "markdown"
  }'
```

**In Open WebUI:** "Document this code: [paste code here]"

---

## ❌ Inactive Workflows (Require Tool-Calling Models)

These workflows need models that support function calling (like phi3:mini at 2.2GB):
- Manager Agent (orchestrates sub-agents)
- Jira Agent
- User Story Agent  
- Bug Report Agent
- Logfile Agent

**Note:** Due to memory constraints, these are kept inactive. The 3 active workflows provide core SDLC functionality without memory issues.

---

## Open WebUI Integration

Go to http://localhost:3000 and use natural language:

- "Create a user story for shopping cart"
- "Generate test data for products table"
- "Document this Python function"

The workflows will automatically process your requests!
