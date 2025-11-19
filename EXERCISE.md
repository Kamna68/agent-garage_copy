# AgentGarage Training Exercise: LLM Workflow with N8N

## 🎯 Objective

In this exercise, you'll set up and explore **AgentGarage** – a lightweight GenAI development environment based on Docker, featuring:

- **A local LLM** (connected via OpenWebUI or direct API)
- **N8N** for workflow orchestration
- **A simple workspace** for experimenting with SDLC-related automations

**The goal:** Build a simple use case from the **Software Development Lifecycle (SDLC)** domain, where N8N interacts with the local LLM.

---

## 🧰 Tech Stack

| Technology | Purpose | Access |
|------------|---------|--------|
| **Local LLM** (Ollama + Llama 3.2) | AI inference engine | http://localhost:11434 |
| **OpenWebUI** | Chat interface for LLM | http://localhost:3000 |
| **N8N** | Workflow automation platform | http://localhost:5678 |
| **PostgreSQL** | Database for n8n | Internal |
| **Qdrant** | Vector database | http://localhost:6333 |
| **Docker Compose** | Container orchestration | CLI |

---

## 🧪 Exercise Task

### Step 1: Environment Setup
1. Clone and start the AgentGarage environment using `docker-compose`
2. Verify all services are running (see `SETUP.md`)

### Step 2: Exploration
1. Access **N8N** via browser and explore the interface
2. Access the **local LLM** via OpenWebUI and test a simple prompt
3. Review the existing sample workflows in n8n

### Step 3: Build Your Workflow
1. Create a new N8N workflow from scratch
2. Design it to communicate with the LLM API
3. Choose your own small **SDLC-related use case**

### Step 4: Test and Document
1. Test your workflow with real inputs
2. Document what it does and how to use it
3. Save/export your workflow

---

## ✅ Requirements

Your N8N workflow **must include**:

- [ ] **At least one API request** to the local LLM (Ollama API)
- [ ] **Clear input mechanism** (Webhook, Manual Trigger, File Input, Schedule, etc.)
- [ ] **Traceable output** (HTTP Response, File Write, Email, etc.)
- [ ] **Prompt engineering** - how N8N "talks" to the LLM
- [ ] **SDLC context** - related to software development lifecycle
- [ ] **Documentation** of your workflow's purpose and usage

### Bonus Points
- Multiple LLM calls in a workflow
- Data transformation between steps
- Error handling
- Integration with other services
- Creative prompt engineering

---

## 💡 Example Use Cases

### 1. Pull Request Description Generator

**Input:** Commit messages or changelog  
**Process:** Send to LLM with prompt template  
**Output:** Clean, human-friendly PR description

**Example:**
```
Input: "fix: null pointer in user service, add validation tests"
Output: 
"## Bug Fix: User Service Null Pointer Exception

This PR addresses a critical null pointer exception in the UserServiceImpl 
class. Added comprehensive validation tests to prevent similar issues.

### Changes
- Added null checks in UserServiceImpl.findUserById()
- Created UserServiceValidationTest with edge cases
- Updated error handling documentation
"
```

---

### 2. Code Review Suggestions

**Input:** Code snippet or git diff  
**Process:** LLM analyzes code for quality, bugs, patterns  
**Output:** Structured review comments

**Example:**
```python
# Input
def calculate_total(items):
    total = 0
    for i in range(len(items)):
        total = total + items[i].price
    return total

# LLM Output
"Review Comments:
✅ Function is clear and works correctly
⚠️ Consider using enumerate() or direct iteration instead of range(len())
⚠️ More Pythonic: return sum(item.price for item in items)
❌ Missing: Type hints, docstring, error handling for empty list
Suggestion: Add type annotations and handle edge cases."
```

---

### 3. User Story to Acceptance Criteria (Gherkin Format)

**Input:** User story in plain text  
**Process:** LLM converts to structured Gherkin format  
**Output:** BDD-style acceptance criteria

**Example:**
```
Input: 
"As a user, I want to change my password so I can secure my account."

Output:
Feature: Password Change
  As a user
  I want to change my password
  So that I can secure my account

Scenario: Successful password change
  Given the user is logged in
  And the user is on the account settings page
  When the user enters their current password
  And the user enters a new valid password
  And the user confirms the new password
  And the user submits the form
  Then the password should be updated
  And a confirmation message should be displayed
  And the user should receive a confirmation email

Scenario: Invalid current password
  Given the user is logged in
  When the user enters an incorrect current password
  Then an error message should be displayed
  And the password should not be changed
```

---

### 4. Commit Message Improver

**Input:** Rough commit message  
**Process:** LLM enhances to follow conventional commits  
**Output:** Well-formatted commit message

---

### 5. Test Case Generator

**Input:** Function description or code  
**Process:** LLM generates test scenarios  
**Output:** Unit test templates

---

### 6. Technical Debt Analyzer

**Input:** Code snippet  
**Process:** LLM identifies technical debt  
**Output:** Refactoring suggestions with priority

---

## 🧠 Learning Goals

After completing this exercise, you will:

- ✅ Understand how to deploy Docker-based LLM environments
- ✅ Know how to integrate N8N with local language models via API
- ✅ Apply prompt engineering to real SDLC workflows
- ✅ Explore automation ideas within your development lifecycle
- ✅ Build reusable workflow templates for your team

---

## 📚 Resources

### N8N Workflow Building
- [N8N Documentation](https://docs.n8n.io)
- [N8N HTTP Request Node](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.httprequest/)
- [N8N Webhook Node](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.webhook/)

### Ollama API
- [Ollama API Documentation](https://github.com/ollama/ollama/blob/main/docs/api.md)
- Endpoint: `POST http://localhost:11434/api/generate`
- Endpoint: `POST http://localhost:11434/api/chat`

### Prompt Engineering
- [OpenAI Prompt Engineering Guide](https://platform.openai.com/docs/guides/prompt-engineering)
- [Anthropic Prompt Library](https://docs.anthropic.com/claude/prompt-library)

---

## 🎓 Submission Guidelines

When you've completed your workflow:

1. **Export your workflow** from N8N (JSON file)
2. **Create a README** explaining:
   - What your workflow does
   - How to use it
   - Example inputs and outputs
   - Any special configuration needed
3. **Test it** and include sample data
4. **Document any challenges** you faced and how you solved them

---

## 🚀 Getting Started

Ready to begin? Follow these steps:

1. Read `SETUP.md` to start the environment
2. Read `QUICKSTART.md` for n8n workflow basics
3. Choose your use case
4. Start building!

**Time Estimate:** 2-4 hours

**Difficulty:** Beginner to Intermediate

---

## 💭 Tips for Success

- **Start simple** - get one API call working first
- **Test incrementally** - use n8n's test/execute feature
- **Read the logs** - n8n shows detailed execution data
- **Iterate on prompts** - your first prompt won't be perfect
- **Use the examples** - the pre-loaded workflows are great references
- **Ask for help** - check the n8n community forum

---

## 🎉 Have Fun!

This exercise is designed to be exploratory and creative. There's no single "right answer" - focus on learning, experimenting, and building something useful for your development workflow!

Good luck! 🚀
