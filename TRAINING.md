# AgentGarage LLM Workflow Training - Complete Package

## 📦 What's Included

This training package contains everything you need to learn how to build LLM-powered workflows with n8n and local AI models.

### 📚 Documentation

| File | Purpose | When to Read |
|------|---------|--------------|
| **EXERCISE.md** | Full exercise description and requirements | Start here - understand the goals |
| **SETUP.md** | Environment setup and verification | First - get your system running |
| **QUICKSTART.md** | Step-by-step tutorial | During - hands-on guide |
| **SOLUTION.md** | Detailed technical explanation | After - deep dive into concepts |

### 🛠️ Workflows

Located in `n8n/backup/workflows/`:

1. **1_User_Story_Creator.json** - Pre-existing example workflow
2. **2_Manager_Agent.json** - Multi-agent system example  
3. **3_Code_Review_Assistant.json** - ⭐ Training workflow #1
4. **4_Gherkin_Generator.json** - ⭐ Training workflow #2
5. **5_Commit_Message_Improver.json** - ⭐ Training workflow #3
6. **6_PR_Description_Generator.json** - ⭐ Training workflow #4

### 🎁 Bonus Materials

- **.env.example** - Environment configuration template
- **Makefile** - Task automation (40+ commands)
- **CHEATSHEET.md** - Quick reference guide
- **AgentGarage_Postman_Collection.json** - API testing collection

### 📁 Test Data

Located in `shared/`:

- **example_code_python.py** - Python code with intentional issues
- **example_code_javascript.js** - JavaScript code for review
- **example_code_java.java** - Java code samples
- **example_user_stories.md** - Collection of user stories
- **README.md** - How to use the test data

---

## 🚀 Quick Start (3 Steps)

### 1. Start the Environment
```bash
# Choose based on your hardware
docker compose --profile cpu up              # CPU only
docker compose --profile gpu-nvidia up       # NVIDIA GPU
docker compose up                            # Mac/Apple Silicon
```

### 2. Access n8n
- Open http://localhost:5678
- Create account (first time only)
- Workflows are pre-loaded!

### 3. Test Example Workflow
```bash
# Activate workflow in n8n first, then:
curl -X POST http://localhost:5678/webhook/code_review_assistant \
  -H "Content-Type: application/json" \
  -d '{
    "code": "def add(a,b):\n  return a+b",
    "language": "python"
  }'
```

**Got a response?** You're ready to start! 🎉

---

## 📖 Learning Path

### Phase 1: Setup & Exploration (30 min)
1. Read **EXERCISE.md** - understand the objectives
2. Follow **SETUP.md** - start the environment
3. Verify all services are running
4. Explore the n8n interface

### Phase 2: Learn by Example (45 min)
1. Follow **QUICKSTART.md** steps 1-4
2. Test the Code Review Assistant workflow
3. Test the Gherkin Generator workflow
4. Study the workflow structures

### Phase 3: Build Your Own (90 min)
1. Follow **QUICKSTART.md** step 5
2. Choose your SDLC use case
3. Build the workflow
4. Test and debug
5. Document your work

### Phase 4: Deep Dive (optional)
1. Read **SOLUTION.md** - understand the technical details
2. Modify existing workflows
3. Add advanced features
4. Explore extensions

---

## 🎯 Training Objectives

By the end of this exercise, you will:

✅ Deploy a local LLM environment with Docker  
✅ Build n8n workflows that call LLM APIs  
✅ Design effective prompts for SDLC tasks  
✅ Integrate AI into development workflows  
✅ Test and debug automation workflows  
✅ Understand webhook-driven architectures  

---

## 🧰 Tech Stack

```
┌─────────────────────────────────────┐
│         Open WebUI (Chat)           │
│        http://localhost:3000        │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│      n8n (Workflow Engine)          │
│        http://localhost:5678        │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│    Ollama (LLM - Llama 3.2)         │
│       http://localhost:11434        │
└─────────────────────────────────────┘
```

Additional services:
- **PostgreSQL** - n8n database
- **Qdrant** - Vector database
- **Jira** - Optional ticket system

---

## 💡 Example Use Cases Provided

### 1. Code Review Assistant
**Input:** Code snippet  
**Output:** AI-powered code review with:
- Security analysis
- Quality suggestions
- Best practice recommendations
- Priority ratings

### 2. Gherkin Generator
**Input:** User story  
**Output:** BDD test scenarios with:
- Feature descriptions
- Multiple scenarios
- Given/When/Then format
- Edge case coverage

---

## 🎓 What You'll Learn

### Core Concepts
- Docker container orchestration
- REST API integration
- Webhook-driven workflows
- Prompt engineering
- LLM API patterns

### n8n Skills
- Workflow creation
- Node configuration
- Expression language
- Conditional logic
- File operations
- HTTP requests

### AI/LLM Skills
- Prompt design
- Role definition
- Output structuring
- Quality control
- Use case selection

---

## 📊 Difficulty Levels

### Beginner Tasks
- Run existing workflows
- Modify prompts
- Change output formats
- Test with different inputs

### Intermediate Tasks
- Create new workflows from scratch
- Add conditional logic
- Integrate file operations
- Chain multiple steps

### Advanced Tasks
- Build multi-agent systems
- Add error handling
- Implement caching
- Create reusable templates

---

## 🔧 Troubleshooting

### Common Issues

**Environment won't start:**
```bash
docker compose down -v
docker compose --profile cpu up
```

**Workflows not visible:**
- Check browser cache, refresh page
- Verify n8n import completed: `docker compose logs n8n-import`

**LLM not responding:**
```bash
curl http://localhost:11434/api/tags
docker compose logs ollama
```

**Webhook not triggering:**
- Ensure workflow is ACTIVATED (toggle at top)
- Check webhook path matches curl URL

### Getting Help
1. Check the relevant .md documentation
2. Review n8n execution logs (click on nodes)
3. Check Docker logs: `docker compose logs [service]`
4. Consult n8n community: https://community.n8n.io

---

## 📂 Project Structure

```
agent-garage_copy/
├── EXERCISE.md              # Training exercise description
├── SETUP.md                 # Environment setup guide
├── QUICKSTART.md            # Step-by-step tutorial
├── SOLUTION.md              # Technical deep dive
├── TRAINING.md              # This file - overview
│
├── docker-compose.yml       # Container orchestration
├── .env                     # Environment configuration
│
├── n8n/
│   └── backup/
│       ├── workflows/       # n8n workflow JSON files
│       │   ├── 3_Code_Review_Assistant.json
│       │   └── 4_Gherkin_Generator.json
│       └── credentials/     # n8n credentials
│
├── shared/                  # Test data and outputs
│   ├── example_code_python.py
│   ├── example_code_javascript.js
│   ├── example_user_stories.md
│   └── README.md
│
├── openwebui/              # Open WebUI data
├── logs/                   # Log files
└── readme_images/          # Documentation images
```

---

## 🎉 Success Metrics

You've successfully completed the exercise when you can:

- [x] Start the environment without errors
- [x] Access all web interfaces
- [x] Run both example workflows successfully
- [x] Create your own workflow from scratch
- [x] Get meaningful LLM responses
- [x] Understand the workflow patterns
- [x] Document your solution

---

## 🚀 What's Next?

After completing this training:

### Immediate Next Steps
1. **Experiment** - Modify the example workflows
2. **Combine** - Chain multiple workflows together
3. **Integrate** - Add GitHub, Slack, or email nodes
4. **Share** - Export and share your workflows

### Advanced Projects
1. **CI/CD Integration** - Automate code review in pull requests
2. **Documentation Generator** - Auto-generate API docs
3. **Test Automation** - Generate and run tests from stories
4. **Multi-Agent System** - Build complex agent coordination

### Explore More
- Try different LLM models (see Ollama library)
- Build custom n8n nodes
- Integrate with your team's tools
- Contribute workflows to community

---

## 📞 Support & Resources

### Documentation
- [n8n Docs](https://docs.n8n.io)
- [Ollama Docs](https://github.com/ollama/ollama/blob/main/docs/api.md)
- [AgentGarage Repo](https://github.com/twodigits/agent-garage)

### Community
- [n8n Community](https://community.n8n.io)
- [n8n Discord](https://discord.gg/n8n)

### Learning
- [n8n YouTube](https://www.youtube.com/@n8n-io)
- [Prompt Engineering Guide](https://platform.openai.com/docs/guides/prompt-engineering)

---

## 📝 Feedback

This is a training exercise designed for hands-on learning. Your feedback helps improve it:

- What worked well?
- What was confusing?
- What additional examples would help?
- What use cases would you like to see?

---

## 🎯 Training Tips

### For Self-Learners
- Take your time, don't rush
- Test each step before moving on
- Make mistakes - that's how you learn
- Keep notes of what you discover

### For Instructors
- Allow 3-4 hours for complete exercise
- Encourage experimentation
- Have students share their workflows
- Discuss prompt engineering choices
- Live-code challenging parts

### For Teams
- Pair program the workflow building
- Compare different approaches
- Build a shared workflow library
- Document your team's patterns

---

## ⚖️ License

This training exercise extends the AgentGarage project:
- Licensed under Apache 2.0
- Free to use, modify, and share
- No warranty - educational purposes

---

## 🙏 Acknowledgments

Built on top of:
- **AgentGarage** by twodigits
- **n8n** - Workflow automation platform
- **Ollama** - Local LLM runtime
- **Open WebUI** - Chat interface

---

**Ready to begin?** Start with **EXERCISE.md** and **SETUP.md**!

Good luck and have fun building! 🚀
