#!/bin/bash

# Sample bash script for GitHub Actions testing
# This script demonstrates common bash operations that can be used in workflows

set -e  # Exit on error

echo "=== GitHub Actions Test Script ==="
echo "Script started at: $(date)"
echo ""

# Function to print section headers
print_section() {
    echo ""
    echo "======================================"
    echo "$1"
    echo "======================================"
}

# Check arguments
print_section "Script Arguments"
if [ $# -eq 0 ]; then
    echo "No arguments provided"
    echo "Usage: $0 [arg1] [arg2] ..."
else
    echo "Arguments received: $#"
    for arg in "$@"; do
        echo "  - $arg"
    done
fi

# Environment information
print_section "Environment Information"
if [ -n "$GITHUB_WORKFLOW" ]; then
    echo "Running in GitHub Actions"
    echo "Workflow: $GITHUB_WORKFLOW"
    echo "Repository: $GITHUB_REPOSITORY"
    echo "Actor: $GITHUB_ACTOR"
else
    echo "Not running in GitHub Actions"
fi

# File operations
print_section "File Operations"
if [ -f "README.md" ]; then
    echo "README.md found"
    line_count=$(wc -l < README.md)
    echo "Lines: $line_count"
else
    echo "README.md not found"
fi

# Test data processing
print_section "Test Data Processing"
test_data_dir="test-data"
if [ -d "$test_data_dir" ]; then
    echo "Test data directory found"
    file_count=$(find "$test_data_dir" -type f | wc -l)
    echo "Files in test-data: $file_count"
    
    if [ -f "$test_data_dir/workflows.json" ]; then
        echo ""
        echo "Processing workflows.json..."
        if command -v jq &> /dev/null; then
            workflow_count=$(jq '.workflows | length' "$test_data_dir/workflows.json")
            echo "Workflows defined: $workflow_count"
        else
            echo "jq not available, skipping JSON processing"
        fi
    fi
else
    echo "Test data directory not found"
fi

# Success message
print_section "Script Completed"
echo "All operations completed successfully"
echo "Finished at: $(date)"
exit 0
