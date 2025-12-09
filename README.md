# GitHub Actions Tests

A repository for testing and validating GitHub Actions workflows that use a mix of `github-script` and bash script based jobs.

## Overview

This repository provides a comprehensive testing environment for GitHub Actions workflows, demonstrating:

- **GitHub Script Jobs**: Using the `@actions/github-script` action to interact with the GitHub API
- **Bash Script Jobs**: Running shell commands and scripts in workflow jobs
- **Mixed Workflows**: Combining both github-script and bash operations in complex pipelines
- **Job Dependencies**: Passing data between jobs using outputs
- **Artifacts**: Uploading and downloading artifacts across jobs
- **Conditional Execution**: Running steps based on event types and conditions

## Workflows

### 1. GitHub Script Tests (`github-script-test.yml`)

Tests various operations using the `@actions/github-script` action:

- **Basic GitHub Script Job**: Print repository information, list files, and demonstrate API interactions
- **Advanced GitHub Script Operations**: Get workflow run info, list recent commits, check branch protection
- **GitHub Script with Outputs**: Set job outputs for use in dependent jobs

**Trigger**: Push to main/master, Pull Requests, Manual dispatch

### 2. Bash Script Tests (`bash-script-test.yml`)

Tests various bash scripting operations:

- **Basic Bash Commands**: System information, environment variables, git operations
- **File Operations**: Create/manipulate files, JSON processing with jq, array operations
- **Advanced Bash Scripting**: Conditional logic, functions, error handling, pipelines
- **Bash with Outputs**: Generate and pass outputs to dependent jobs

**Trigger**: Push to main/master, Pull Requests, Manual dispatch

### 3. Mixed Tests (`mixed-test.yml`)

Demonstrates combining github-script and bash in complex workflows:

- **Prepare with Bash → Process with GitHub Script → Verify with Bash**: Multi-stage pipeline
- **Mixed Operations in Single Job**: Alternating between bash and github-script steps
- **Conditional Execution**: Different steps for push vs pull_request events
- **Artifact Passing**: Upload data in bash, download and process in github-script

**Trigger**: Push to main/master, Pull Requests, Manual dispatch

### 4. Demo Workflow (`demo.yml`)

An interactive demo workflow with customizable inputs:

- **Workflow Inputs**: Choose test type (all, github-script, bash, mixed) and custom message
- **Conditional Jobs**: Runs only selected test types
- **Comprehensive Examples**: Shows real-world usage of all workflow types
- **Summary Report**: Displays results from all executed jobs

**Trigger**: Manual dispatch only (with inputs)

## Repository Structure

```
.
├── .github/
│   └── workflows/
│       ├── github-script-test.yml    # GitHub Script workflow examples
│       ├── bash-script-test.yml      # Bash script workflow examples
│       ├── mixed-test.yml            # Mixed workflow examples
│       └── demo.yml                  # Interactive demo workflow
├── test-data/
│   ├── workflows.json                # Sample JSON data
│   └── sample.txt                    # Sample text file
├── scripts/
│   └── test-script.sh                # Sample bash script
├── CONTRIBUTING.md                   # Guide for contributors
└── README.md
```

## Test Data

### `test-data/workflows.json`
Contains metadata about the workflows in this repository, useful for testing JSON processing in both bash (with `jq`) and github-script (with Node.js).

### `test-data/sample.txt`
A sample text file with various content types for testing file operations, grep, and text processing.

### `scripts/test-script.sh`
An executable bash script demonstrating common operations that can be called from workflows.

## Usage

### Running Workflows Manually

All workflows support manual triggering via workflow_dispatch:

1. Go to the **Actions** tab in your repository
2. Select the workflow you want to run
3. Click **Run workflow**
4. Choose the branch and click **Run workflow**

#### Demo Workflow with Inputs

The demo workflow provides interactive options:

1. Go to **Actions** → **Demo Workflow**
2. Click **Run workflow**
3. Choose options:
   - **Test type**: Select 'all', 'github-script', 'bash', or 'mixed'
   - **Custom message**: Enter a message to display in the workflow
4. Click **Run workflow** to start

### Testing Locally

You can test the bash script locally:

```bash
# Make sure the script is executable
chmod +x scripts/test-script.sh

# Run the script
./scripts/test-script.sh arg1 arg2

# Or run it from the repository root
bash scripts/test-script.sh
```

### Testing JSON Processing

Test JSON operations with jq:

```bash
# Install jq if needed
sudo apt-get install jq  # Ubuntu/Debian
brew install jq          # macOS

# Query the workflows.json file
jq '.workflows[] | .name' test-data/workflows.json
jq '.features' test-data/workflows.json
```

## Key Concepts Demonstrated

### 1. Job Outputs

Both workflows demonstrate setting and using job outputs:

**Bash example:**
```yaml
- name: Generate Outputs
  id: set-output
  run: |
    echo "timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")" >> $GITHUB_OUTPUT
    echo "file-count=$(find . -type f | wc -l)" >> $GITHUB_OUTPUT
```

**GitHub Script example:**
```yaml
- name: Set Outputs
  id: set-output
  uses: actions/github-script@v7
  with:
    script: |
      core.setOutput('repo-name', context.repo.repo);
      core.setOutput('commit-count', commits.length);
```

### 2. Artifact Sharing

The mixed workflow shows how to share data between jobs:

```yaml
# Upload in one job
- uses: actions/upload-artifact@v4
  with:
    name: test-data
    path: /tmp/test-data.json

# Download in another job
- uses: actions/download-artifact@v4
  with:
    name: test-data
    path: /tmp
```

### 3. Conditional Execution

Examples of running steps conditionally:

```yaml
- name: Run on Push Only
  if: github.event_name == 'push'
  run: echo "This runs only on push"

- name: Always Run
  if: always()
  run: echo "This always runs"
```

### 4. GitHub API Access

Using github-script to interact with the GitHub API:

```javascript
const { data: commits } = await github.rest.repos.listCommits({
  owner: context.repo.owner,
  repo: context.repo.repo,
  per_page: 5
});
```

## Best Practices Demonstrated

1. **Error Handling**: Using `set -e` in bash scripts and `continue-on-error` in workflows
2. **Logging**: Clear console output with section headers
3. **Modularity**: Separating concerns across different jobs
4. **Reusability**: Using functions in bash scripts
5. **Documentation**: Inline comments and clear step names
6. **Testing**: Verification steps to ensure operations completed successfully

## Extending This Repository

You can extend this repository by:

1. **Adding new workflows**: Create additional `.yml` files in `.github/workflows/`
2. **Adding test data**: Place more sample files in `test-data/`
3. **Creating utility scripts**: Add more bash scripts to `scripts/`
4. **Testing new actions**: Install and test third-party GitHub Actions
5. **Experimenting with triggers**: Try different event triggers (schedule, issue_comment, etc.)

## Troubleshooting

### Workflows not running?

- Check that workflows are enabled in your repository settings
- Ensure you're pushing to the correct branch (main or master)
- Check the Actions tab for error messages

### Permission errors?

- Some GitHub API operations may require additional permissions
- Check the workflow run logs for specific permission errors
- You may need to adjust repository or workflow permissions

### Script execution errors?

- Ensure bash scripts have execute permissions (`chmod +x`)
- Check for syntax errors in scripts
- Verify paths are correct (use absolute paths when needed)

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [github-script Action](https://github.com/actions/github-script)
- [Workflow Syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
- [GitHub REST API](https://docs.github.com/en/rest)

## License

This is a testing repository. Use the workflows and examples freely for your own testing and learning purposes.