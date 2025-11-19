# Quick Start Guide - AgentGarage Training Exercise

This guide will walk you through completing the training exercise step-by-step.

## Prerequisites Checklist

- [ ] Docker and Docker Compose installed
- [ ] At least 8GB RAM available
- [ ] Text editor or IDE
- [ ] Terminal/Command line access
- [ ] Basic understanding of JSON and REST APIs

**Optional but Recommended:**
- [ ] Postman (for API testing with the provided collection)
- [ ] Make (for using Makefile shortcuts)

## Bonus: Quick Setup with Automation

If you have `make` installed, you can use these shortcuts:

```bash
# Copy environment template
make setup

# Start environment
make start

# Test environment
make test

# See all available commands
make help
```

See **CHEATSHEET.md** for more commands and **Makefile** for all automation options.

## Step 1: Environment Setup (15 minutes)

### 1.1 Copy Environment Configuration (Optional)

```bash
cp .env.example .env
# Edit .env if you need custom settings
```

### 1.2 Start the Environment

Choose the command for your system:

**CPU only:**
```bash
docker compose --profile cpu up
```

**NVIDIA GPU:**
```bash
docker compose --profile gpu-nvidia up
```

**AMD GPU (Linux):**
```bash
docker compose --profile gpu-amd up
```

**Mac/Apple Silicon:**
```bash
docker compose up
```

### 1.2 Wait for Initialization

You'll see logs streaming. Wait for this message:
```
Editor is now accessible via: http://localhost:5678/
```

This means n8n is ready! The first startup downloads the LLM model (Llama 3.2), which takes a few minutes.

### 1.3 Verify Services

Open these URLs in your browser:

| Service | URL | Expected Result |
|---------|-----|-----------------|
| n8n | http://localhost:5678 | Registration page (first time) |
| Open WebUI | http://localhost:3000 | Login page |
| Ollama API | http://localhost:11434/api/tags | JSON response with models |

## Step 2: n8n Setup (5 minutes)

### 2.1 Create n8n Account

1. Go to http://localhost:5678
2. Fill in the registration form (any email works, it's local only)
3. Click "Get Started"

### 2.2 Explore Pre-loaded Workflows

You should see several workflows:
- **1 User Story Creator** - Simple example workflow
- **2 Manager Agent** - Multi-agent system
- **3 Code Review Assistant** - Training workflow #1
- **4 Gherkin Generator** - Training workflow #2

### 2.3 Understand the Interface

- **Left sidebar:** Node palette (drag & drop)
- **Center canvas:** Workflow editor
- **Right panel:** Node settings
- **Top right:** Execute/Activate buttons

## Step 3: Test Ollama (5 minutes)

### 3.1 Test via curl

```bash
curl http://localhost:11434/api/generate -d '{
  "model": "llama3.2",
  "prompt": "Say hello in 5 words",
  "stream": false
}'
```

Expected: JSON response with `"response"` field containing AI-generated text.

### 3.2 Test via Open WebUI (Optional)

1. Go to http://localhost:3000
2. Login: `admin@test.com` / `S2yjzup!3`
3. Type a message and verify you get a response

## Step 4: Explore Example Workflows (15 minutes)

### 4.1 Code Review Assistant

1. In n8n, click on **"3 Code Review Assistant"**
2. Read the workflow documentation (Sticky Notes)
3. Click **"Activate"** toggle (top right)
4. Test it:

```bash
curl -X POST http://localhost:5678/webhook/code_review_assistant \
  -H "Content-Type: application/json" \
  -d '{
    "code": "def add(x,y):\n  return x+y",
    "language": "python"
  }'
```

5. Check the response - you should get an AI code review!

### 4.2 Gherkin Generator

1. Click on **"4 Gherkin Generator"**
2. Read the documentation
3. Activate the workflow
4. Test it:

```bash
curl -X POST http://localhost:5678/webhook/gherkin_generator \
  -H "Content-Type: application/json" \
  -d '{
    "userStory": "As a user, I want to login with email and password so I can access my account"
  }'
```

## Step 5: Build Your Own Workflow (60-90 minutes)

Now it's your turn! Create a workflow for an SDLC use case.

### 5.1 Choose Your Use Case

Pick one (or create your own):

**Option A: Commit Message Improver**
- Input: Rough commit message
- Output: Conventional Commits formatted message

**Option B: Test Case Generator**
- Input: Function description
- Output: Unit test scenarios

**Option C: PR Description Generator**
- Input: Git diff or commit list
- Output: Formatted PR description

**Option D: Your Own Idea!**

### 5.2 Create New Workflow

1. In n8n, click **"Add workflow"** (+ button)
2. Name it (e.g., "My SDLC Workflow")

### 5.3 Build the Workflow

#### Minimum Required Nodes:

**1. Webhook (Trigger)**
```
Node: Webhook
Settings:
- HTTP Method: POST
- Path: my_workflow_name
- Response Mode: "Using 'Respond to Webhook' node"
```

**2. HTTP Request (Call Ollama)**
```
Node: HTTP Request
Settings:
- Method: POST
- URL: http://ollama:11434/api/generate
- Body:
  {
    "model": "llama3.2:latest",
    "prompt": "Your prompt here with {{ $('Webhook').item.json.body.input }}",
    "stream": false
  }
```

**3. Respond to Webhook**
```
Node: Respond to Webhook
Settings:
- Respond With: JSON
- Response Body: {{ $json.response }}
```

### 5.4 Connect the Nodes

1. Drag from Webhook output to HTTP Request input
2. Drag from HTTP Request output to Respond to Webhook input

### 5.5 Configure the Prompt

This is the most important part! Edit the HTTP Request node's prompt parameter.

**Example prompt structure:**
```
You are a [role].

Task: [what to do]

Input:
{{ $('Webhook').item.json.body.yourInputField }}

Instructions:
1. [instruction 1]
2. [instruction 2]
3. [instruction 3]

Output format: [describe desired format]
```

### 5.6 Test Your Workflow

1. Click **"Activate"** toggle
2. Click **"Test workflow"** button
3. Use curl to send a test request:

```bash
curl -X POST http://localhost:5678/webhook/my_workflow_name \
  -H "Content-Type: application/json" \
  -d '{
    "yourInputField": "test data"
  }'
```

### 5.7 Debug if Needed

- Click on nodes to see their output
- Check the **"Executions"** tab for history
- Look for error messages in node details
- Verify JSON syntax in prompts

## Step 6: Enhance Your Workflow (Optional - 30 minutes)

Add more features:

### Add File Output

Use **"Write Binary File"** or **"Files - Read/Write"** node:
```
File Path: /data/shared/output_{{ $now.format('yyyyMMdd_HHmmss') }}.txt
Content: {{ $json.response }}
```

### Add Conditional Logic

Use **"IF"** node to branch based on conditions:
```
Condition: {{ $json.response.length }} > 100
True: Send to file
False: Return directly
```

### Add Error Handling

Use **"Error Trigger"** node to catch failures and send notifications.

### Chain Multiple LLM Calls

Use output from one LLM call as input to another.

## Step 7: Document Your Work (15 minutes)

Create a README for your workflow:

```markdown
# My Workflow Name

## Purpose
[What it does]

## How to Use
[curl example]

## Input Format
[JSON schema]

## Output Format
[Example response]

## Prompt Engineering
[Explain your prompt design]

## Testing
[Test cases you tried]
```

## Step 8: Export and Share (5 minutes)

1. In n8n workflow view, click "..." menu
2. Select "Download"
3. Save the JSON file
4. Share with your team or submit for review!

## Troubleshooting

### Workflow doesn't trigger
- Check workflow is **activated** (toggle on)
- Verify webhook URL path is correct
- Check logs: `docker compose logs n8n`

### LLM not responding
- Verify Ollama is running: `docker compose ps`
- Check model is loaded: `curl http://localhost:11434/api/tags`
- Pull model manually: `docker compose exec ollama ollama pull llama3.2`

### Empty or error response
- Check HTTP Request node configuration
- Verify JSON syntax in prompt
- Look at node execution data for error messages

### Port conflicts
- Check if ports 5678, 3000, 11434 are free
- Modify `docker-compose.yml` if needed

## Learning Resources

- **n8n Docs:** https://docs.n8n.io
- **Ollama API:** https://github.com/ollama/ollama/blob/main/docs/api.md
- **Prompt Engineering:** https://platform.openai.com/docs/guides/prompt-engineering

## Tips for Success

✅ **Start simple** - Get one API call working first  
✅ **Test incrementally** - Use n8n's execution viewer  
✅ **Iterate prompts** - Your first prompt won't be perfect  
✅ **Use examples** - Reference the provided workflows  
✅ **Read errors carefully** - They usually tell you exactly what's wrong  

## What's Next?

After completing this exercise, try:

1. **Integrate with real tools** - Add GitHub, Jira, Slack nodes
2. **Build a multi-agent system** - Like the Manager Agent example
3. **Add a database** - Store workflow results in PostgreSQL
4. **Schedule workflows** - Use Cron triggers for automation
5. **Explore more LLMs** - Try different Ollama models

## Need Help?

- Check the example workflows for patterns
- Read `SOLUTION.md` for detailed explanations
- Review n8n community forum
- Ask your instructor/team

---

## Completion Checklist

- [ ] Environment running successfully
- [ ] Tested both example workflows
- [ ] Created your own workflow
- [ ] Successfully called Ollama API
- [ ] Designed effective prompts
- [ ] Tested with real data
- [ ] Documented your workflow
- [ ] Exported workflow JSON

**Congratulations!** You've completed the AgentGarage training exercise! 🎉

You now know how to:
- Deploy local LLM environments
- Build n8n automation workflows
- Integrate AI into SDLC processes
- Design prompts for specific tasks
- Test and debug workflows

Keep experimenting and building! 🚀
