#!/bin/bash
# AgentGarage Training - Quick Test Script
# Tests all components to verify the environment is working

set -e  # Exit on any error

echo "======================================"
echo "AgentGarage Environment Test Script"
echo "======================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Helper function for test results
test_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓ PASS${NC} - $2"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗ FAIL${NC} - $2"
        ((TESTS_FAILED++))
    fi
}

echo "Testing AgentGarage components..."
echo ""

# Test 1: Check if Docker is running
echo "1. Checking Docker..."
if docker info > /dev/null 2>&1; then
    test_result 0 "Docker is running"
else
    test_result 1 "Docker is not running"
    echo "  → Please start Docker and try again"
    exit 1
fi

# Test 2: Check if containers are running
echo ""
echo "2. Checking containers..."
EXPECTED_CONTAINERS="n8n ollama postgres qdrant openwebui"
for container in $EXPECTED_CONTAINERS; do
    if docker compose ps | grep -q "$container"; then
        test_result 0 "$container container is running"
    else
        test_result 1 "$container container is not running"
    fi
done

# Test 3: Check Ollama API
echo ""
echo "3. Testing Ollama API..."
if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
    test_result 0 "Ollama API is accessible"
    
    # Check if llama3.2 model exists
    if curl -s http://localhost:11434/api/tags | grep -q "llama3.2"; then
        test_result 0 "Llama 3.2 model is available"
    else
        test_result 1 "Llama 3.2 model not found"
        echo "  → Run: docker compose exec ollama ollama pull llama3.2"
    fi
else
    test_result 1 "Ollama API is not accessible"
fi

# Test 4: Check n8n
echo ""
echo "4. Testing n8n..."
if curl -s http://localhost:5678 > /dev/null 2>&1; then
    test_result 0 "n8n web interface is accessible"
else
    test_result 1 "n8n web interface is not accessible"
fi

# Test 5: Check Open WebUI
echo ""
echo "5. Testing Open WebUI..."
if curl -s http://localhost:3000 > /dev/null 2>&1; then
    test_result 0 "Open WebUI is accessible"
else
    test_result 1 "Open WebUI is not accessible"
fi

# Test 6: Check Qdrant
echo ""
echo "6. Testing Qdrant..."
if curl -s http://localhost:6333 > /dev/null 2>&1; then
    test_result 0 "Qdrant is accessible"
else
    test_result 1 "Qdrant is not accessible"
fi

# Test 7: Test LLM inference
echo ""
echo "7. Testing LLM inference..."
RESPONSE=$(curl -s -X POST http://localhost:11434/api/generate \
    -d '{"model": "llama3.2", "prompt": "Say hello", "stream": false}' \
    2>/dev/null)

if echo "$RESPONSE" | grep -q "response"; then
    test_result 0 "LLM can generate responses"
    echo "  → Sample response: $(echo $RESPONSE | grep -o '"response":"[^"]*"' | head -c 60)..."
else
    test_result 1 "LLM inference failed"
fi

# Test 8: Check shared directory
echo ""
echo "8. Testing shared directory..."
if [ -d "./shared" ]; then
    test_result 0 "Shared directory exists"
    
    if [ -f "./shared/example_code_python.py" ]; then
        test_result 0 "Example test files found"
    else
        test_result 1 "Example test files not found"
    fi
else
    test_result 1 "Shared directory not found"
fi

# Test 9: Check workflow files
echo ""
echo "9. Testing n8n workflows..."
if [ -f "./n8n/backup/workflows/3_Code_Review_Assistant.json" ]; then
    test_result 0 "Code Review Assistant workflow found"
else
    test_result 1 "Code Review Assistant workflow not found"
fi

if [ -f "./n8n/backup/workflows/4_Gherkin_Generator.json" ]; then
    test_result 0 "Gherkin Generator workflow found"
else
    test_result 1 "Gherkin Generator workflow not found"
fi

# Summary
echo ""
echo "======================================"
echo "Test Summary"
echo "======================================"
echo -e "Tests Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests Failed: ${RED}$TESTS_FAILED${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed!${NC}"
    echo ""
    echo "Your AgentGarage environment is ready!"
    echo ""
    echo "Next steps:"
    echo "1. Open n8n: http://localhost:5678"
    echo "2. Read QUICKSTART.md for the tutorial"
    echo "3. Try the example workflows"
    echo ""
    echo "Test a workflow with:"
    echo "  curl -X POST http://localhost:5678/webhook/code_review_assistant \\"
    echo "    -H \"Content-Type: application/json\" \\"
    echo "    -d '{\"code\": \"def add(a,b):\\n  return a+b\", \"language\": \"python\"}'"
    exit 0
else
    echo -e "${RED}✗ Some tests failed${NC}"
    echo ""
    echo "Common fixes:"
    echo "1. Make sure all containers are running: docker compose ps"
    echo "2. Check logs: docker compose logs [service-name]"
    echo "3. Restart environment: docker compose down && docker compose --profile cpu up"
    echo ""
    exit 1
fi
