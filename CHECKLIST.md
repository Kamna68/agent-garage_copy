# AgentGarage Training Exercise - Completion Checklist

Use this checklist to track your progress through the training exercise.

## 📋 Pre-Exercise Setup

### Environment Preparation
- [ ] Docker and Docker Compose installed
- [ ] At least 8GB RAM available
- [ ] 10GB free disk space
- [ ] Stable internet connection (for initial download)
- [ ] Text editor installed
- [ ] Terminal/command line access
- [ ] Basic understanding of JSON and REST APIs

### Documentation Review
- [ ] Read `TRAINING.md` - Overview
- [ ] Read `EXERCISE.md` - Requirements
- [ ] Skim `SETUP.md` - Installation guide
- [ ] Bookmark `QUICKSTART.md` for reference

---

## 🚀 Phase 1: Environment Setup (30 min)

### Start the Environment
- [ ] Cloned repository (if needed)
- [ ] Reviewed `docker-compose.yml`
- [ ] Started containers with appropriate profile
- [ ] Waited for "Editor is now accessible" message
- [ ] All containers running: `docker compose ps`

### Service Verification
- [ ] n8n accessible at http://localhost:5678
- [ ] Open WebUI accessible at http://localhost:3000
- [ ] Ollama API responding at http://localhost:11434
- [ ] Created n8n account (first time)
- [ ] Logged into Open WebUI (if testing)
- [ ] Ran `./test-environment.sh` successfully

### Ollama Testing
- [ ] Verified Llama 3.2 model loaded
- [ ] Tested generation API with curl
- [ ] Received coherent response from LLM

---

## 📚 Phase 2: Learn by Example (45 min)

### Explore n8n Interface
- [ ] Familiarized with n8n dashboard
- [ ] Located pre-loaded workflows
- [ ] Understand the canvas interface
- [ ] Opened and viewed workflow nodes
- [ ] Read sticky note documentation in workflows

### Code Review Assistant Workflow
- [ ] Opened "3 Code Review Assistant" workflow
- [ ] Read all sticky notes and documentation
- [ ] Understood the workflow structure
- [ ] Activated the workflow (toggle on)
- [ ] Tested with simple code example
- [ ] Tested with code containing issues
- [ ] Reviewed the execution results in n8n
- [ ] Understood the prompt engineering used

### Gherkin Generator Workflow
- [ ] Opened "4 Gherkin Generator" workflow
- [ ] Read all sticky notes and documentation
- [ ] Understood conditional logic (IF node)
- [ ] Activated the workflow
- [ ] Tested with simple user story
- [ ] Tested with `saveToFile: true`
- [ ] Found generated .feature file in shared/
- [ ] Reviewed execution results

### Run Test Scripts
- [ ] Executed `./test-workflows.sh all`
- [ ] Verified both workflows work
- [ ] Examined JSON responses
- [ ] Checked for generated files

---

## 🛠️ Phase 3: Build Your Own (90 min)

### Planning
- [ ] Chose SDLC use case
- [ ] Defined input format
- [ ] Designed expected output
- [ ] Sketched workflow structure on paper/whiteboard
- [ ] Planned prompt structure

### Workflow Creation
- [ ] Created new workflow in n8n
- [ ] Named workflow appropriately
- [ ] Added Webhook trigger node
- [ ] Configured webhook path
- [ ] Added HTTP Request node for Ollama
- [ ] Configured Ollama API endpoint
- [ ] Added Respond to Webhook node
- [ ] Connected all nodes

### Prompt Engineering
- [ ] Defined clear role for AI
- [ ] Wrote task description
- [ ] Specified input format
- [ ] Listed detailed instructions
- [ ] Defined output format
- [ ] Added quality requirements
- [ ] Tested prompt with variations

### Testing & Debugging
- [ ] Activated workflow
- [ ] Created test curl command
- [ ] Sent first test request
- [ ] Reviewed execution in n8n
- [ ] Checked node outputs
- [ ] Fixed any errors
- [ ] Tested with edge cases
- [ ] Verified output quality
- [ ] Refined prompt based on results

### Enhancement (Optional)
- [ ] Added conditional logic
- [ ] Implemented file output
- [ ] Added data transformation
- [ ] Included error handling
- [ ] Chained multiple LLM calls
- [ ] Integrated with other services

---

## 📝 Phase 4: Documentation (15 min)

### Document Your Workflow
- [ ] Created README for your workflow
- [ ] Explained purpose and use case
- [ ] Provided example input/output
- [ ] Documented curl commands
- [ ] Described prompt design choices
- [ ] Listed test cases tried
- [ ] Noted any challenges and solutions

### Export & Share
- [ ] Exported workflow JSON from n8n
- [ ] Saved to appropriate directory
- [ ] Added descriptive filename
- [ ] Tested import of exported workflow
- [ ] Prepared to share with team/instructor

---

## 🎓 Phase 5: Deep Dive (Optional)

### Technical Understanding
- [ ] Read `SOLUTION.md` completely
- [ ] Understood webhook-driven pattern
- [ ] Grasped expression language usage
- [ ] Reviewed prompt engineering best practices
- [ ] Studied error handling approaches
- [ ] Explored extension possibilities

### Advanced Exploration
- [ ] Modified existing workflow prompts
- [ ] Experimented with different models
- [ ] Added multiple output formats
- [ ] Built workflow with branching logic
- [ ] Created reusable sub-workflows
- [ ] Integrated with external services

---

## ✅ Final Verification

### Competency Checklist
- [ ] Can start AgentGarage environment
- [ ] Can navigate n8n interface confidently
- [ ] Understand webhook-based workflows
- [ ] Can call Ollama API directly
- [ ] Know how to use n8n expression language
- [ ] Can design effective prompts
- [ ] Can debug workflow executions
- [ ] Understand conditional logic in workflows
- [ ] Can export and import workflows

### Deliverables
- [ ] At least one working workflow created
- [ ] Workflow documented with README
- [ ] Test examples provided
- [ ] Workflow JSON exported
- [ ] Challenges and learnings documented

---

## 🎉 Success Criteria

You have successfully completed the training when:

✅ **Technical Skills**
- Can build a workflow from scratch
- Successfully integrate with LLM API
- Design prompts that produce quality output
- Debug and fix workflow issues independently

✅ **Understanding**
- Explain how the workflows work
- Describe the role of each node
- Understand the data flow
- Know when to use different patterns

✅ **Practical Application**
- Built a real SDLC use case
- Tested with multiple examples
- Refined based on results
- Documented for others to use

---

## 📊 Self-Assessment

Rate yourself (1-5, 5 being highest):

**Technical Skills**
- [ ] Docker/Docker Compose: ___/5
- [ ] n8n workflow creation: ___/5
- [ ] REST API integration: ___/5
- [ ] Prompt engineering: ___/5
- [ ] Debugging workflows: ___/5

**Conceptual Understanding**
- [ ] LLM API patterns: ___/5
- [ ] Webhook architecture: ___/5
- [ ] Conditional logic: ___/5
- [ ] Data transformation: ___/5
- [ ] SDLC automation: ___/5

**Confidence Level**
- [ ] Can build new workflows independently: ___/5
- [ ] Can troubleshoot issues: ___/5
- [ ] Can explain to others: ___/5
- [ ] Ready to use in projects: ___/5

---

## 🚀 Next Steps

Based on completion, choose your path:

### If you scored mostly 4-5:
- [ ] Build advanced multi-agent workflows
- [ ] Integrate with your team's tools
- [ ] Create custom n8n nodes
- [ ] Mentor others through the exercise
- [ ] Contribute workflows to community

### If you scored mostly 3:
- [ ] Build 2-3 more workflows for practice
- [ ] Review `SOLUTION.md` again
- [ ] Join n8n community discussions
- [ ] Experiment with different use cases
- [ ] Try different LLM models

### If you scored mostly 1-2:
- [ ] Repeat the exercise with instructor help
- [ ] Focus on one workflow at a time
- [ ] Review basic Docker/API concepts
- [ ] Study the example workflows in detail
- [ ] Ask questions in community forums

---

## 📝 Feedback & Reflection

### What worked well?
- 
- 
- 

### What was challenging?
- 
- 
- 

### What would you change?
- 
- 
- 

### What additional examples would help?
- 
- 
- 

### How will you use this in your work?
- 
- 
- 

---

## 🎯 Bonus Challenges

Completed the basics? Try these:

- [ ] **PR Review Bot** - Automatically review pull requests
- [ ] **Commit Message Validator** - Check and improve commit messages
- [ ] **Test Generator** - Generate unit tests from code
- [ ] **Documentation Generator** - Create API docs from code
- [ ] **Multi-Agent System** - Build coordinated agent workflow
- [ ] **Scheduled Automation** - Add cron triggers
- [ ] **Email Integration** - Send results via email
- [ ] **Slack Integration** - Post to Slack channels
- [ ] **Database Integration** - Store results in PostgreSQL
- [ ] **Custom Metrics** - Track workflow performance

---

## ✨ Congratulations!

If you've checked most items above, you've successfully completed the AgentGarage training exercise!

You now have the foundation to:
- Build LLM-powered automation workflows
- Integrate AI into development processes
- Design effective prompts for specific tasks
- Debug and optimize workflows
- Experiment with new AI use cases

**Keep building, keep learning!** 🚀

---

**Date Completed:** _______________

**Instructor/Reviewer Signature:** _______________

**Notes:**
