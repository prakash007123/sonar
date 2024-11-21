# setup.ps1

Write-Host "Setting up Git hooks for Windows..."

# Ensure the target .git/hooks directory exists
if (-not (Test-Path -Path ".git\hooks")) {
    Write-Host "Error: .git/hooks directory not found. Ensure you're in the repository root." -ForegroundColor Red
    exit 1
}

# Copy hooks into .git/hooks
Write-Host "Copying post-checkout and post-merge hooks..."
Copy-Item -Path ".git-hooks\post-checkout" -Destination ".git\hooks\post-checkout" -Force
Copy-Item -Path ".git-hooks\post-merge" -Destination ".git\hooks\post-merge" -Force
Copy-Item -Path ".git-hooks\pre-commit" -Destination ".git\hooks\pre-commit" -Force

# Make hooks executable (Git for Windows uses `bash`, so this is informational on Windows)
Write-Host "Making Git hooks executable (if required by your Git client)..."

Write-Host "Git hooks installed successfully." -ForegroundColor Green
