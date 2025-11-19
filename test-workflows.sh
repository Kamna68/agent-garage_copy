#!/bin/bash
# Test workflow examples
# Usage: ./test-workflows.sh [code-review|gherkin|all]

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "======================================"
echo "AgentGarage Workflow Test Examples"
echo "======================================"
echo ""

test_code_review() {
    echo -e "${BLUE}Testing Code Review Assistant...${NC}"
    echo ""
    
    echo "Example 1: Simple Python function"
    echo "Request:"
    echo '{
  "code": "def add(a,b):\n  return a+b",
  "language": "python"
}'
    echo ""
    
    curl -X POST http://localhost:5678/webhook/code_review_assistant \
        -H "Content-Type: application/json" \
        -d '{
          "code": "def add(a,b):\n  return a+b",
          "language": "python"
        }' 2>/dev/null | jq '.' || echo "Error: Is the workflow activated in n8n?"
    
    echo ""
    echo "---"
    echo ""
    
    echo "Example 2: Code with security issues"
    echo "Request:"
    echo '{
  "code": "password = \"admin123\"\ndb.query(\"SELECT * FROM users WHERE id=\" + user_id)",
  "language": "python"
}'
    echo ""
    
    curl -X POST http://localhost:5678/webhook/code_review_assistant \
        -H "Content-Type: application/json" \
        -d '{
          "code": "password = \"admin123\"\ndb.query(\"SELECT * FROM users WHERE id=\" + user_id)",
          "language": "python"
        }' 2>/dev/null | jq '.' || echo "Error: Is the workflow activated in n8n?"
    
    echo ""
}

test_gherkin() {
    echo -e "${BLUE}Testing Gherkin Generator...${NC}"
    echo ""
    
    echo "Example 1: Simple user story"
    echo "Request:"
    echo '{
  "userStory": "As a user, I want to reset my password so I can regain access to my account"
}'
    echo ""
    
    curl -X POST http://localhost:5678/webhook/gherkin_generator \
        -H "Content-Type: application/json" \
        -d '{
          "userStory": "As a user, I want to reset my password so I can regain access to my account"
        }' 2>/dev/null | jq '.' || echo "Error: Is the workflow activated in n8n?"
    
    echo ""
    echo "---"
    echo ""
    
    echo "Example 2: With file saving"
    echo "Request:"
    echo '{
  "userStory": "As a customer, I want to add items to my cart so I can buy multiple products",
  "saveToFile": true
}'
    echo ""
    
    curl -X POST http://localhost:5678/webhook/gherkin_generator \
        -H "Content-Type: application/json" \
        -d '{
          "userStory": "As a customer, I want to add items to my cart so I can buy multiple products",
          "saveToFile": true
        }' 2>/dev/null | jq '.' || echo "Error: Is the workflow activated in n8n?"
    
    echo ""
    
    if [ -d "./shared" ]; then
        echo -e "${YELLOW}Generated feature files:${NC}"
        ls -lt ./shared/*.feature 2>/dev/null | head -5 || echo "No .feature files yet"
    fi
    
    echo ""
}

# Main
case "${1:-all}" in
    code-review)
        test_code_review
        ;;
    gherkin)
        test_gherkin
        ;;
    all)
        test_code_review
        echo ""
        echo "======================================"
        echo ""
        test_gherkin
        ;;
    *)
        echo "Usage: $0 [code-review|gherkin|all]"
        echo ""
        echo "Examples:"
        echo "  $0 code-review    # Test Code Review Assistant only"
        echo "  $0 gherkin        # Test Gherkin Generator only"
        echo "  $0 all            # Test both workflows (default)"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}Done!${NC}"
echo ""
echo "Next steps:"
echo "- Open n8n to see execution history"
echo "- Check the shared/ directory for generated files"
echo "- Try modifying the requests above"
echo "- Build your own workflow!"
