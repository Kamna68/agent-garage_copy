# Solution Guide - AgentGarage Training Exercise

This document explains the two sample workflows provided for the training exercise and the concepts behind them.

## Overview

Two complete workflows are provided as learning examples:
1. **Code Review Assistant** - AI-powered code analysis
2. **Gherkin Generator** - User story to BDD test scenarios

Both demonstrate key patterns for building LLM-powered automation in n8n.

---

## Workflow 1: Code Review Assistant

### Purpose
Automatically review code snippets and provide structured feedback on quality, security, and best practices.

### Architecture

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   Webhook   │─────▶│   Ollama    │─────▶│   Format    │─────▶│   Respond   │
│   Trigger   │      │  API Call   │      │   Output    │      │  to Webhook │
└─────────────┘      └─────────────┘      └─────────────┘      └─────────────┘
```

### Node-by-Node Breakdown

#### 1. Webhook - Receive Code
```json
{
  "type": "n8n-nodes-base.webhook",
  "httpMethod": "POST",
  "path": "code_review_assistant",
  "responseMode": "responseNode"
}
```

**What it does:**
- Creates a POST endpoint at `/webhook/code_review_assistant`
- Receives JSON with code and language
- Triggers the workflow

**Expected Input:**
```json
{
  "code": "def add(a,b):\n  return a+b",
  "language": "python"
}
```

#### 2. Call Ollama API
```json
{
  "type": "n8n-nodes-base.httpRequest",
  "method": "POST",
  "url": "http://ollama:11434/api/generate"
}
```

**What it does:**
- Makes HTTP POST to Ollama's generate endpoint
- Sends model name, prompt, and settings
- Returns AI-generated review

**Prompt Structure:**
```
You are an experienced senior software engineer conducting a thorough code review.

Analyze the following code and provide:
1. **Overall Assessment** (Good/Needs Improvement/Poor)
2. **Strengths** - what's done well
3. **Issues** - bugs, security concerns, or problems
4. **Code Quality** - readability, maintainability, style
5. **Suggestions** - specific improvements with examples
6. **Priority** - High/Medium/Low for each issue

Code to review:
```
[actual code]
```

Language: [language]

Provide a structured, professional code review.
```

**Why this prompt works:**
- Clear role definition ("senior software engineer")
- Structured output format (numbered sections)
- Specific categories to cover
- Professional tone requirement

#### 3. Format Response
```json
{
  "type": "n8n-nodes-base.set",
  "assignments": [
    {"name": "review", "value": "={{ $json.response }}"},
    {"name": "original_code", "value": "..."},
    {"name": "language", "value": "..."},
    {"name": "timestamp", "value": "={{ $now.toISO() }}"}
  ]
}
```

**What it does:**
- Extracts AI response from Ollama's JSON
- Adds metadata (original code, language, timestamp)
- Structures output for consistent format

#### 4. Send Review Back
```json
{
  "type": "n8n-nodes-base.respondToWebhook",
  "respondWith": "json",
  "responseBody": "={{ $json }}"
}
```

**What it does:**
- Sends formatted JSON back to webhook caller
- Completes the HTTP request/response cycle

### Key Concepts Demonstrated

#### Direct API Integration
Instead of using n8n's AI Agent node, this workflow shows how to:
- Make raw HTTP requests to Ollama
- Construct JSON payloads manually
- Parse responses yourself

**Benefits:**
- Full control over request/response
- Easier to debug
- Works with any LLM API
- No dependencies on n8n's AI nodes

#### Expression Language
n8n's expression language (`={{ }}`) is used to:
```javascript
// Reference previous node data
{{ $('Webhook - Receive Code').item.json.body.code }}

// Access current node JSON
{{ $json.response }}

// Use helper functions
{{ $now.toISO() }}
{{ $now.format('yyyy-MM-dd') }}
```

#### Error Handling Considerations
Production version should add:
- Input validation (check code is provided)
- Error handling (if Ollama is down)
- Timeout settings
- Rate limiting

### Testing Examples

#### Test 1: Simple Function
```bash
curl -X POST http://localhost:5678/webhook/code_review_assistant \
  -H "Content-Type: application/json" \
  -d '{
    "code": "def add(a,b):\n  return a+b",
    "language": "python"
  }'
```

**Expected Review Points:**
- Missing type hints
- No docstring
- Could use more descriptive names
- No input validation

#### Test 2: Security Issue
```bash
curl -X POST http://localhost:5678/webhook/code_review_assistant \
  -H "Content-Type: application/json" \
  -d '{
    "code": "password = \"admin123\"\ndb.query(\"SELECT * FROM users WHERE id=\" + user_id)",
    "language": "python"
  }'
```

**Expected Review Points:**
- Hardcoded password (HIGH priority)
- SQL injection vulnerability (HIGH priority)
- Use parameterized queries

---

## Workflow 2: Gherkin Generator

### Purpose
Convert user stories into BDD (Behavior-Driven Development) Gherkin format with multiple test scenarios.

### Architecture

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   Webhook   │─────▶│   Ollama    │─────▶│   Format    │─────▶│   Respond   │
│   Trigger   │      │  Generate   │      │   Output    │      │  to Webhook │
└─────────────┘      └─────────────┘      └─────────────┘      └─────────────┘
                                                  │
                                                  ├──────▶ IF saveToFile?
                                                  │              │
                                                  │              ▼
                                                  │      ┌─────────────┐
                                                  │      │ Write File  │
                                                  │      └─────────────┘
                                                  ▼
```

### Node-by-Node Breakdown

#### 1. Webhook - User Story Input
```json
{
  "type": "n8n-nodes-base.webhook",
  "httpMethod": "POST",
  "path": "gherkin_generator"
}
```

**Expected Input:**
```json
{
  "userStory": "As a user, I want to reset my password...",
  "saveToFile": false
}
```

#### 2. Generate Gherkin
```json
{
  "type": "n8n-nodes-base.httpRequest",
  "url": "http://ollama:11434/api/generate"
}
```

**Prompt Structure:**
```
You are a QA Engineer and BDD (Behavior-Driven Development) expert.

Convert the following user story into well-structured Gherkin format 
with comprehensive scenarios.

**User Story:**
[user story text]

**Instructions:**
1. Create a Feature description
2. Include the user story in "As a/I want/So that" format
3. Write at least 2-3 scenarios covering:
   - Happy path (successful flow)
   - Edge cases
   - Error handling
4. Use proper Gherkin syntax:
   - Feature: [description]
   - Scenario: [name]
   - Given [context]
   - When [action]
   - Then [outcome]
   - And [additional steps]
5. Make scenarios specific and testable
6. Include relevant examples where appropriate

Generate complete, professional Gherkin acceptance criteria.
```

**Why this prompt works:**
- Expert role definition (QA + BDD)
- Clear output format (Gherkin syntax)
- Specific coverage requirements
- Examples of syntax elements
- Quality standards (testable, specific)

#### 3. Structure Output
```json
{
  "type": "n8n-nodes-base.set",
  "assignments": [
    {"name": "gherkin", "value": "={{ $json.response }}"},
    {"name": "original_story", "value": "..."},
    {"name": "generated_at", "value": "..."}
  ]
}
```

#### 4. Save to File? (Conditional)
```json
{
  "type": "n8n-nodes-base.if",
  "conditions": [
    {
      "leftValue": "={{ $('Webhook - User Story Input').item.json.body.saveToFile }}",
      "operation": "equals",
      "rightValue": true
    }
  ]
}
```

**What it does:**
- Checks if `saveToFile` parameter is true
- If yes, routes to file writing node
- If no, skips file writing

**Key Concept: Branching Logic**
- TRUE output → Write Feature File
- FALSE output → (unused, could add alternative action)

#### 5. Write Feature File
```json
{
  "type": "n8n-nodes-base.filesReadWrite",
  "operation": "write",
  "fileName": "/data/shared/gherkin_{{ $now.format('yyyy-MM-dd_HHmmss') }}.feature",
  "fileContent": "={{ $('Generate Gherkin').item.json.response }}"
}
```

**What it does:**
- Writes Gherkin content to .feature file
- Uses timestamp in filename for uniqueness
- Saves to shared volume (accessible from host)

**File path breakdown:**
- `/data/shared/` - Mounted volume in container
- Maps to `./shared/` on host machine
- Files persist after container stops

#### 6. Return Gherkin
Returns JSON response to webhook caller.

### Key Concepts Demonstrated

#### Conditional Workflow
Using IF node for branching:
```
Input → Process → IF condition?
                      ├─ TRUE → Action A
                      └─ FALSE → Action B (or skip)
```

#### File System Operations
```javascript
// Dynamic filename with timestamp
fileName: "gherkin_{{ $now.format('yyyy-MM-dd_HHmmss') }}.feature"

// Result: gherkin_2025-11-19_143055.feature
```

#### Multi-Output Workflows
```
Generate Gherkin
    ├──▶ Structure Output ──▶ Return JSON
    └──▶ Save to File? ──▶ Write .feature file
```

One node's output feeds multiple downstream nodes.

### Testing Examples

#### Test 1: Basic Generation
```bash
curl -X POST http://localhost:5678/webhook/gherkin_generator \
  -H "Content-Type: application/json" \
  -d '{
    "userStory": "As a user, I want to login with email and password so I can access my account"
  }'
```

**Expected Output:**
```gherkin
Feature: User Login
  As a user
  I want to login with email and password
  So I can access my account

Scenario: Successful login
  Given I am on the login page
  When I enter valid email "user@example.com"
  And I enter valid password "SecurePass123"
  And I click the login button
  Then I should be redirected to my dashboard
  And I should see a welcome message

Scenario: Invalid credentials
  Given I am on the login page
  When I enter email "user@example.com"
  And I enter incorrect password "wrong"
  And I click the login button
  Then I should see error "Invalid credentials"
  And I should remain on the login page
```

#### Test 2: Save to File
```bash
curl -X POST http://localhost:5678/webhook/gherkin_generator \
  -H "Content-Type: application/json" \
  -d '{
    "userStory": "As an admin, I want to export user data to CSV",
    "saveToFile": true
  }'
```

**Result:**
- JSON response with Gherkin
- File created: `./shared/gherkin_2025-11-19_143055.feature`

---

## Common Patterns Across Both Workflows

### 1. Webhook-Driven Pattern
```
Webhook → Process → Respond
```
- Synchronous request/response
- Good for APIs and integrations
- Caller waits for result

### 2. Prompt Engineering Structure
```
[Role Definition]
You are a [expert role]

[Task]
[Clear instruction what to do]

[Input]
[Data to process]

[Instructions/Guidelines]
1. Specific requirement
2. Another requirement
3. Format specification

[Quality Statement]
Generate [adjectives describing desired output]
```

### 3. Data Flow Pattern
```javascript
// Access webhook input
$('Webhook').item.json.body.fieldName

// Access previous node output
$('Node Name').item.json.fieldName

// Access current node data
$json.fieldName

// Use built-in functions
$now.toISO()
$now.format('yyyy-MM-dd')
```

### 4. Response Formatting
Always structure outputs with:
- Original input (for reference)
- AI-generated content
- Metadata (timestamp, version, etc.)

---

## Extending the Workflows

### Code Review Assistant Extensions

#### Add Email Notification
```
Format Response ──▶ Send Email (if high-priority issues found)
```

#### Add GitHub Integration
```
Webhook ──▶ Get PR diff from GitHub
        ──▶ Review code
        ──▶ Post comment on PR
```

#### Add File Output
```
Format Response ──▶ Write review to file
                ──▶ Respond to webhook
```

#### Chain Reviews
```
Review Code ──▶ If issues found
            ──▶ Generate fix suggestions
            ──▶ Create refactored version
```

### Gherkin Generator Extensions

#### Add Git Commit
```
Write Feature File ──▶ Git commit
                   ──▶ Push to repository
```

#### Add Validation
```
Webhook ──▶ Validate user story format
        ──▶ If valid: Generate Gherkin
        ──▶ If invalid: Return error with suggestions
```

#### Add Multiple Formats
```
Generate Gherkin ──▶ Convert to:
                 ├─▶ Gherkin (.feature)
                 ├─▶ Markdown (.md)
                 └─▶ Test framework code
```

#### Add Test Scaffolding
```
Generate Gherkin ──▶ Create test framework files
                 ├─▶ Python pytest
                 ├─▶ JavaScript Cucumber
                 └─▶ Java JUnit
```

---

## Performance Considerations

### Response Times
- Ollama API: 2-10 seconds (depends on prompt complexity)
- Simple prompts: ~2-3 seconds
- Complex analysis: ~5-10 seconds

### Optimization Tips

1. **Prompt Length**
   - Shorter prompts = faster response
   - But don't sacrifice clarity

2. **Model Selection**
   - Smaller models (7B params) = faster
   - Larger models (70B params) = better quality

3. **Streaming**
   - Set `"stream": true` for progressive output
   - Better UX for long responses

4. **Caching**
   - Cache common reviews
   - Store user story → Gherkin mappings

---

## Debugging Tips

### Check Node Execution Data
1. Click on any node
2. View "Output" tab
3. See exact JSON data

### Common Issues

#### Empty Response
```javascript
// Check if this returns data:
{{ $json }}

// If empty, LLM may not have responded
// Check Ollama logs:
docker compose logs ollama
```

#### Expression Errors
```javascript
// Wrong:
{{ $json.response.text }}  // if response.text doesn't exist

// Better:
{{ $json.response || 'No response' }}  // with fallback
```

#### Webhook Not Triggering
- Ensure workflow is ACTIVATED
- Check webhook URL is correct
- Verify Content-Type header

### Test with Execute Node
1. Click "Test workflow" button
2. Click on Webhook node
3. Click "Listen for test event"
4. Send curl request
5. See execution in real-time

---

## Security Considerations

### Production Checklist

- [ ] Add authentication to webhooks
- [ ] Validate all inputs
- [ ] Sanitize code before review (remove secrets)
- [ ] Rate limit requests
- [ ] Add timeout to LLM calls
- [ ] Log all requests for audit
- [ ] Use environment variables for sensitive config
- [ ] Implement HTTPS for webhooks

### Input Validation Example
```javascript
// Add validation node before LLM call
IF {{ $json.body.code }} is empty
  → Return error "Code required"
IF {{ $json.body.code.length }} > 10000
  → Return error "Code too large"
```

---

## Best Practices Summary

### ✅ DO
- Use clear, specific prompts
- Structure your workflows logically
- Add documentation (sticky notes)
- Test incrementally
- Handle errors gracefully
- Use expressions for dynamic data
- Name nodes descriptively

### ❌ DON'T
- Hardcode values (use expressions)
- Skip error handling
- Make prompts too vague
- Forget to activate workflows
- Ignore response times
- Skip input validation

---

## Learning Progression

### Beginner
1. Run example workflows as-is
2. Modify prompts
3. Change input/output formats
4. Add sticky notes with documentation

### Intermediate
5. Add conditional logic (IF nodes)
6. Integrate with external services
7. Add file operations
8. Chain multiple LLM calls

### Advanced
9. Build multi-agent systems
10. Add error recovery
11. Implement caching
12. Create reusable sub-workflows
13. Add monitoring and alerts

---

## Additional Resources

### n8n Documentation
- [HTTP Request Node](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.httprequest/)
- [Webhook Node](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.webhook/)
- [Expression Language](https://docs.n8n.io/code-examples/expressions/)
- [IF Node](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.if/)

### Ollama
- [API Documentation](https://github.com/ollama/ollama/blob/main/docs/api.md)
- [Model Library](https://ollama.com/library)
- [Best Practices](https://github.com/ollama/ollama/blob/main/docs/faq.md)

### Prompt Engineering
- [OpenAI Guide](https://platform.openai.com/docs/guides/prompt-engineering)
- [Anthropic Techniques](https://docs.anthropic.com/claude/docs/prompt-engineering)

---

## Conclusion

These two workflows demonstrate the fundamental patterns for building LLM-powered automation:

1. **Input** via webhook or trigger
2. **Process** with LLM API
3. **Transform** the response
4. **Output** via API, file, or notification

Master these patterns, and you can build any SDLC automation workflow!

**Next Steps:**
- Modify these workflows
- Create your own use case
- Combine multiple patterns
- Share with your team

Happy automating! 🚀
