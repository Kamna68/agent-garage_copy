# Test Data for AgentGarage Workflows

This directory contains example files for testing the training workflows.

## Files

### Code Examples
- `example_code_python.py` - Python code with various issues for code review
- `example_code_javascript.js` - JavaScript code with common problems
- `example_code_java.java` - Java code samples

### User Stories
- `example_user_stories.md` - Collection of user stories for Gherkin generation

## How to Use

### Testing Code Review Assistant

```bash
# Using curl with Python code
curl -X POST http://localhost:5678/webhook/code_review_assistant \
  -H "Content-Type: application/json" \
  -d "{\"code\": \"$(cat shared/example_code_python.py | sed 's/"/\\"/g' | tr '\n' ' ')\", \"language\": \"python\"}"

# Simple inline example
curl -X POST http://localhost:5678/webhook/code_review_assistant \
  -H "Content-Type: application/json" \
  -d '{
    "code": "def add(a,b):\n  return a+b",
    "language": "python"
  }'
```

### Testing Gherkin Generator

```bash
# Simple example
curl -X POST http://localhost:5678/webhook/gherkin_generator \
  -H "Content-Type: application/json" \
  -d '{
    "userStory": "As a user, I want to reset my password so I can regain access to my account"
  }'

# With file saving
curl -X POST http://localhost:5678/webhook/gherkin_generator \
  -H "Content-Type: application/json" \
  -d '{
    "userStory": "As a customer, I want to add items to cart so I can buy multiple products",
    "saveToFile": true
  }'
```

## Common Issues in Code Examples

The example code files intentionally contain common problems:

### Python (`example_code_python.py`)
- ❌ Storing passwords in plain text
- ❌ Using `range(len())` instead of enumerate or direct iteration
- ❌ Missing error handling
- ❌ Missing type hints
- ❌ No input validation

### JavaScript (`example_code_javascript.js`)
- ❌ Using `var` instead of `const`/`let`
- ❌ Using `==` instead of `===`
- ❌ Insecure random token generation
- ❌ Missing error handling for async operations
- ❌ No password hashing

### Java (`example_code_java.java`)
- ❌ Plain text password storage
- ❌ Using indexed loops instead of enhanced for-loops
- ❌ Weak random number generation for tokens
- ❌ No null checks
- ❌ Missing encapsulation

These are perfect for testing AI-powered code review!

## Expected Outputs

### Code Review
The AI should identify:
- Security issues (password storage, weak tokens)
- Code quality improvements (better loops, type safety)
- Missing error handling
- Best practice violations

### Gherkin
The AI should generate:
- Feature description
- Multiple scenarios (happy path, edge cases, errors)
- Proper Given/When/Then structure
- Testable acceptance criteria

## Tips

- Start with simple examples
- Try different programming languages
- Modify the code to see how reviews change
- Experiment with different user story formats
