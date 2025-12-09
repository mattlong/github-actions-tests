# Quick Reference Guide

## Workflow Overview

| Workflow | Trigger | Purpose | Key Features |
|----------|---------|---------|--------------|
| `github-script-test.yml` | Push, PR, Manual | Test GitHub Script operations | API calls, repo info, commit history |
| `bash-script-test.yml` | Push, PR, Manual | Test Bash operations | File ops, system commands, JSON with jq |
| `mixed-test.yml` | Push, PR, Manual | Test mixed operations | Pipelines, artifacts, cross-job data |
| `demo.yml` | Manual only | Interactive demo | Customizable inputs, conditional execution |

## Common Commands

### Run Test Script Locally
```bash
cd /path/to/github-actions-tests
./scripts/test-script.sh [arg1] [arg2]
```

### Process JSON Data
```bash
# View all workflow names
jq -r '.workflows[].name' test-data/workflows.json

# Count workflows
jq '.workflows | length' test-data/workflows.json

# Get specific workflow details
jq '.workflows[] | select(.name == "github-script-test")' test-data/workflows.json
```

### Search Text Files
```bash
# Search for pattern
grep -i "testing" test-data/sample.txt

# Count lines
wc -l test-data/sample.txt

# Extract key-value pairs
grep "^[A-Z]*=" test-data/sample.txt
```

### Validate Workflows
```bash
# Check YAML syntax
yamllint .github/workflows/*.yml

# Validate with Python
python3 -c "import yaml; yaml.safe_load(open('.github/workflows/demo.yml'))"

# Check bash script syntax
bash -n scripts/test-script.sh
```

## GitHub Actions Context Variables

### Available in all workflows
- `${{ github.repository }}` - Repository name (owner/repo)
- `${{ github.ref }}` - Git ref (refs/heads/branch-name)
- `${{ github.sha }}` - Commit SHA
- `${{ github.actor }}` - User who triggered the workflow
- `${{ github.event_name }}` - Event type (push, pull_request, etc.)
- `${{ github.workflow }}` - Workflow name
- `${{ github.run_id }}` - Unique workflow run ID
- `${{ github.run_number }}` - Run number for this workflow

### In github-script
```javascript
context.repo.owner       // Repository owner
context.repo.repo        // Repository name
context.sha              // Commit SHA
context.ref              // Git ref
context.workflow         // Workflow name
context.job              // Current job name
context.runId            // Workflow run ID
context.actor            // User who triggered
context.eventName        // Event type
context.payload          // Full webhook payload
```

### In bash
```bash
$GITHUB_REPOSITORY       # owner/repo
$GITHUB_REF              # refs/heads/branch
$GITHUB_SHA              # commit SHA
$GITHUB_ACTOR            # username
$GITHUB_WORKFLOW         # workflow name
$GITHUB_RUN_ID           # run ID
$GITHUB_RUN_NUMBER       # run number
$GITHUB_EVENT_NAME       # event type
$GITHUB_WORKSPACE        # workspace directory
```

## Common Patterns

### Set Job Output (Bash)
```yaml
- name: Set output
  id: step-id
  run: |
    echo "key=value" >> $GITHUB_OUTPUT
    echo "count=$(ls | wc -l)" >> $GITHUB_OUTPUT
```

### Set Job Output (GitHub Script)
```yaml
- name: Set output
  id: step-id
  uses: actions/github-script@v7
  with:
    script: |
      core.setOutput('key', 'value');
      core.setOutput('count', 42);
```

### Use Job Output
```yaml
- name: Use output
  run: echo "${{ steps.step-id.outputs.key }}"
  
# In dependent job
needs: job-name
run: echo "${{ needs.job-name.outputs.key }}"
```

### Conditional Steps
```yaml
# Run on push only
- if: github.event_name == 'push'
  run: echo "Push event"

# Run on specific branch
- if: github.ref == 'refs/heads/main'
  run: echo "Main branch"

# Run on PR only
- if: github.event_name == 'pull_request'
  run: echo "Pull request"

# Always run (even if previous steps fail)
- if: always()
  run: echo "Always runs"

# Run on failure
- if: failure()
  run: echo "Previous step failed"
```

### Upload/Download Artifacts
```yaml
# Upload
- uses: actions/upload-artifact@v4.3.3
  with:
    name: my-data
    path: path/to/file.txt

# Download in another job
- uses: actions/download-artifact@v4.1.7
  with:
    name: my-data
    path: ./downloaded
```

### GitHub API with github-script
```javascript
// Get repository
const { data: repo } = await github.rest.repos.get({
  owner: context.repo.owner,
  repo: context.repo.repo
});

// List commits
const { data: commits } = await github.rest.repos.listCommits({
  owner: context.repo.owner,
  repo: context.repo.repo,
  per_page: 10
});

// List workflows
const { data: workflows } = await github.rest.actions.listRepoWorkflows({
  owner: context.repo.owner,
  repo: context.repo.repo
});

// Get workflow run
const { data: run } = await github.rest.actions.getWorkflowRun({
  owner: context.repo.owner,
  repo: context.repo.repo,
  run_id: context.runId
});
```

### File Operations in github-script
```javascript
const fs = require('fs');

// Read file
const content = fs.readFileSync('file.txt', 'utf8');

// Write file
fs.writeFileSync('output.txt', 'content');

// Parse JSON
const data = JSON.parse(fs.readFileSync('data.json', 'utf8'));

// Write JSON
fs.writeFileSync('data.json', JSON.stringify(obj, null, 2));
```

## Troubleshooting

### Workflow not running
- Check triggers match your event (push, PR, etc.)
- Verify YAML syntax is valid
- Check branch names match (main vs master)
- Ensure Actions are enabled in repository settings

### Script errors
- Check file permissions: `chmod +x script.sh`
- Verify paths are correct (absolute vs relative)
- Test scripts locally before committing
- Check exit codes: `echo $?`

### GitHub API errors
- Check rate limits (60/hour unauthenticated, 5000/hour authenticated)
- Use `${{ secrets.GITHUB_TOKEN }}` for authentication
- Handle 404 errors for missing resources
- Use `continue-on-error: true` for optional API calls

### JSON parsing errors
- Validate JSON: `jq . file.json`
- Check for trailing commas
- Verify quotes are correct
- Use online validators

## Resources

- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [github-script Action](https://github.com/actions/github-script)
- [Workflow Syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
- [GitHub REST API](https://docs.github.com/en/rest)
- [jq Manual](https://stedolan.github.io/jq/manual/)
- [Bash Guide](https://mywiki.wooledge.org/BashGuide)

## Examples from This Repository

### Example 1: Simple Bash Command
See: `.github/workflows/bash-script-test.yml` → `basic-bash-commands` job

### Example 2: GitHub API Call
See: `.github/workflows/github-script-test.yml` → `advanced-github-script` job

### Example 3: Job Dependencies
See: `.github/workflows/mixed-test.yml` → `prepare-with-bash` → `process-with-github-script`

### Example 4: Artifact Sharing
See: `.github/workflows/mixed-test.yml` → artifact upload/download pattern

### Example 5: Conditional Execution
See: `.github/workflows/mixed-test.yml` → `conditional-execution` job

### Example 6: Workflow Inputs
See: `.github/workflows/demo.yml` → workflow_dispatch with inputs
