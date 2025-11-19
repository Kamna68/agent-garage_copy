# 🚀 AgentGarage Training - Quick Reference

## Start Here!

**New to this project?** Read this 2-minute guide first.

---

## What is This?

A complete training package to learn **LLM workflow automation** using:
- 🤖 **Local AI** (Llama 3.2 via Ollama)
- 🔄 **n8n** (workflow automation)
- 🐳 **Docker** (containerized environment)

**Perfect for:** Developers, DevOps, QA engineers learning AI automation

---

## 3-Step Quick Start

### 1️⃣ Start Environment (5 min)
```bash
# Choose based on your hardware:
docker compose --profile cpu up              # CPU only
docker compose --profile gpu-nvidia up       # NVIDIA GPU
docker compose up                            # Mac
```

Wait for: `Editor is now accessible via: http://localhost:5678/`

### 2️⃣ Access n8n (2 min)
1. Open http://localhost:5678
2. Create account (any email works)
3. Workflows are pre-loaded!

### 3️⃣ Test Workflow (1 min)
```bash
# Activate "3 Code Review Assistant" in n8n first, then:
curl -X POST http://localhost:5678/webhook/code_review_assistant \
  -H "Content-Type: application/json" \
  -d '{"code": "def add(a,b):\n  return a+b", "language": "python"}'
```

**Got JSON response?** ✅ You're ready!

---

## 📖 Documentation Guide

| Read This | When | Time |
|-----------|------|------|
| **[TRAINING.md](TRAINING.md)** | First - Overview | 5 min |
| **[SETUP.md](SETUP.md)** | To install | 10 min |
| **[EXERCISE.md](EXERCISE.md)** | Understand goals | 10 min |
| **[QUICKSTART.md](QUICKSTART.md)** | During exercise | 2-4 hrs |
| **[SOLUTION.md](SOLUTION.md)** | After completing | 30 min |
| **[CHECKLIST.md](CHECKLIST.md)** | Track progress | Ongoing |

---

## 🛠️ What You'll Build

### Example 1: Code Review Assistant
**Input:** Code snippet  
**Output:** AI-powered review with security/quality analysis

### Example 2: Gherkin Generator  
**Input:** User story  
**Output:** BDD test scenarios

### Your Own Workflow
**Input:** Your choice  
**Output:** Your SDLC automation

---

## 🎯 Learning Path

```
📚 Read Docs (30 min)
   ↓
🔧 Setup Environment (30 min)
   ↓
👀 Explore Examples (45 min)
   ↓
🏗️ Build Your Own (90 min)
   ↓
📝 Document It (15 min)
   ↓
🎉 Done! (3-4 hours total)
```

---

## 🚨 Quick Troubleshooting

**Problem:** Containers won't start  
**Fix:** `docker compose down -v && docker compose --profile cpu up`

**Problem:** Workflow doesn't trigger  
**Fix:** Check workflow is ACTIVATED (toggle in n8n)

**Problem:** LLM not responding  
**Fix:** `docker compose exec ollama ollama pull llama3.2`

**Problem:** Need help  
**Fix:** Run `./test-environment.sh` for diagnostics

---

## 📁 Key Files

```
📦 agent-garage_copy/
│
├── 📖 TRAINING.md              ← Start here!
├── 📖 SETUP.md                 ← Installation
├── 📖 QUICKSTART.md            ← Tutorial
├── 📖 SOLUTION.md              ← Deep dive
│
├── 🛠️ n8n/backup/workflows/
│   ├── 3_Code_Review_Assistant.json
│   └── 4_Gherkin_Generator.json
│
├── 📁 shared/
│   ├── example_code_python.py
│   ├── example_code_javascript.js
│   └── example_user_stories.md
│
└── 🔧 test-*.sh               ← Test scripts
```

---

## ⚡ Quick Commands

```bash
# Start environment
docker compose --profile cpu up

# Check status
docker compose ps

# Test environment
./test-environment.sh

# Test workflows
./test-workflows.sh

# View logs
docker compose logs -f n8n

# Stop everything
docker compose down
```

---

## 🎓 After Completion

You'll be able to:
- ✅ Build LLM-powered workflows
- ✅ Integrate AI into dev processes
- ✅ Design effective prompts
- ✅ Automate SDLC tasks

---

## 📞 Need Help?

1. Check [SETUP.md](SETUP.md) troubleshooting section
2. Run `./test-environment.sh` for diagnostics
3. Read [SOLUTION.md](SOLUTION.md) for technical details
4. Visit [n8n Community](https://community.n8n.io)

---

## 🎉 Ready to Start?

1. **Read:** [TRAINING.md](TRAINING.md) (5 min overview)
2. **Setup:** Follow [SETUP.md](SETUP.md) (start containers)
3. **Learn:** Work through [QUICKSTART.md](QUICKSTART.md)
4. **Build:** Create your own workflow
5. **Celebrate:** You're an LLM workflow automation expert! 🚀

---

**Time Required:** 2-4 hours  
**Difficulty:** Beginner to Intermediate  
**Prerequisites:** Docker, basic REST API knowledge

**Let's get started!** 🎯
