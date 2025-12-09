# Contributing to GitHub Actions Tests

This repository is designed as a testing and learning environment for GitHub Actions workflows. Here's how to make the most of it and contribute improvements.

## Getting Started

1. **Fork the repository** to your own GitHub account
2. **Enable Actions** in your fork (Settings → Actions → General)
3. **Trigger workflows** manually or by pushing commits

## Testing Workflows

### Manual Testing

All workflows can be triggered manually:

1. Go to the **Actions** tab
2. Select a workflow from the left sidebar
3. Click **Run workflow**
4. Choose the branch and click **Run workflow**

### Automatic Testing

Workflows run automatically on:
- Push to main/master branch
- Pull requests to main/master branch

## Adding New Workflows

To add a new test workflow:

1. Create a new YAML file in `.github/workflows/`
2. Follow the naming convention: `*-test.yml` or use a descriptive name
3. Add appropriate triggers (push, pull_request, workflow_dispatch)
4. Include clear job and step names
5. Add comments explaining what the workflow tests
6. Update the README.md to document your workflow

### Workflow Template

```yaml
name: Your Test Name

on:
  push:
    branches: [ main, master ]
  pull_request:
    branches: [ main, master ]
  workflow_dispatch:

jobs:
  your-job-name:
    name: Descriptive Job Name
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Your test step
        run: |
          echo "Your test commands here"
```

## Adding Test Data

### JSON Files

Add JSON files to `test-data/` for testing data processing:

```bash
# Example: Add a new JSON file
cat > test-data/users.json << EOF
{
  "users": [
    {"name": "Alice", "role": "developer"},
    {"name": "Bob", "role": "designer"}
  ]
}
EOF
```

### Text Files

Add text files for testing file operations:

```bash
# Example: Add a log file
cat > test-data/sample.log << EOF
2024-01-01 10:00:00 INFO Application started
2024-01-01 10:00:01 DEBUG Loading configuration
2024-01-01 10:00:02 INFO Server listening on port 8080
EOF
```

## Adding Scripts

### Bash Scripts

Add utility scripts to `scripts/`:

```bash
#!/bin/bash
# scripts/your-script.sh

set -e

echo "Your script logic here"
```

Make them executable:

```bash
chmod +x scripts/your-script.sh
```

### JavaScript/Node Scripts

If testing Node.js in workflows, add scripts to a `js-scripts/` directory:

```javascript
// js-scripts/process-data.js
const fs = require('fs');

const data = JSON.parse(fs.readFileSync('test-data/workflows.json', 'utf8'));
console.log(`Found ${data.workflows.length} workflows`);
```

## Best Practices

### 1. Clear Documentation

- Use descriptive names for jobs and steps
- Add comments explaining complex operations
- Update README.md when adding new features

### 2. Minimal Dependencies

- Use built-in tools when possible (bash, jq, curl)
- Avoid adding unnecessary packages or actions
- Keep the repository lightweight

### 3. Error Handling

- Use `set -e` in bash scripts to exit on error
- Use `continue-on-error: true` for non-critical steps
- Add verification steps after operations

### 4. Testing Variations

Test different scenarios:
- Success cases
- Failure cases (with `continue-on-error`)
- Conditional execution
- Cross-job data passing

### 5. Security

- Never commit secrets or credentials
- Use `${{ secrets.GITHUB_TOKEN }}` for GitHub API access
- Avoid exposing sensitive information in logs

## Workflow Categories

### GitHub Script Workflows

Focus on:
- GitHub API interactions
- Repository data retrieval
- Issue/PR management (read-only recommended)
- Workflow metadata access

### Bash Script Workflows

Focus on:
- File system operations
- Text processing (grep, sed, awk)
- JSON processing (jq)
- System commands
- Script execution

### Mixed Workflows

Focus on:
- Data pipelines (bash → github-script → bash)
- Artifact sharing
- Job dependencies
- Complex multi-step processes

## Common Patterns

### Pattern 1: Data Processing Pipeline

```yaml
jobs:
  prepare:
    # Generate data with bash
  process:
    needs: prepare
    # Process with github-script
  verify:
    needs: process
    # Verify with bash
```

### Pattern 2: Conditional Execution

```yaml
steps:
  - name: Run on main only
    if: github.ref == 'refs/heads/main'
    run: echo "Main branch"
  
  - name: Run on PR only
    if: github.event_name == 'pull_request'
    uses: actions/github-script@v7
    with:
      script: console.log('PR event')
```

### Pattern 3: Artifact Sharing

```yaml
- name: Create artifact
  run: echo "data" > output.txt

- uses: actions/upload-artifact@v4
  with:
    name: my-artifact
    path: output.txt

# In another job:
- uses: actions/download-artifact@v4
  with:
    name: my-artifact
```

## Testing Your Changes

Before submitting changes:

1. **Validate YAML syntax**:
   ```bash
   yamllint .github/workflows/*.yml
   # or
   python3 -c "import yaml; yaml.safe_load(open('.github/workflows/your-file.yml'))"
   ```

2. **Test bash scripts locally**:
   ```bash
   bash -n scripts/your-script.sh  # Syntax check
   ./scripts/your-script.sh        # Run it
   ```

3. **Validate JSON files**:
   ```bash
   jq . test-data/your-file.json
   ```

4. **Run workflows** in your fork before creating a PR

## Troubleshooting

### Workflow not appearing in Actions tab?

- Check YAML syntax errors
- Ensure file is in `.github/workflows/`
- Verify workflow has valid triggers

### Script permission denied?

```bash
chmod +x scripts/your-script.sh
git add scripts/your-script.sh
git commit -m "Make script executable"
```

### JSON parsing errors?

```bash
# Validate JSON
jq . test-data/your-file.json

# Pretty-print JSON
jq . test-data/your-file.json > formatted.json
```

### GitHub API rate limits?

- Use `${{ secrets.GITHUB_TOKEN }}` for authenticated requests
- Add error handling for rate limit responses
- Use `continue-on-error: true` for non-critical API calls

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Workflow Syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
- [github-script Action](https://github.com/actions/github-script)
- [GitHub REST API](https://docs.github.com/en/rest)
- [Bash Reference Manual](https://www.gnu.org/software/bash/manual/)
- [jq Manual](https://stedolan.github.io/jq/manual/)

## Questions or Issues?

- Open an issue to discuss new ideas
- Share your workflow examples
- Report bugs or unexpected behavior
- Suggest improvements to documentation

## License

This is an open testing repository. Use freely for learning and testing purposes.
