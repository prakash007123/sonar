Write-Host "Validating SonarLint installation..."

# Function to log an error and exit with a failure code
function ExitWithError {
    param([string]$message)
    Write-Host "ERROR: $message"
    exit 1
}

# Function to install SonarLint for the specific IDE
function InstallSonarLint {
    param([string]$ide)

    Write-Host "Attempting to install SonarLint for $ide..."

    switch ($ide.ToLower()) {
        "visualstudio" {
            Write-Host "Visual Studio does not support automated installation for SonarLint. Please install it manually via the Extensions Manager."
            ExitWithError "SonarLint installation failed for Visual Studio. Please install manually SonarLint in your IDE"
        }
        "vscode" {
            if (Get-Command "code" -ErrorAction SilentlyContinue) {
                code --install-extension sonarsource.sonarlint-vscode
                if ($?) {
                    Write-Host "SonarLint successfully installed for VS Code."
                } else {
                    ExitWithError "Failed to install SonarLint for VS Code. Please install manually SonarLint in your IDE"
                }
            } else {
                ExitWithError "VS Code CLI (code) is not available. Please install it manually."
            }
        }
        "intellij" {
            Write-Host "IntelliJ IDEA does not support automated installation for SonarLint. Please install it manually via the Plugins Marketplace."
            ExitWithError "SonarLint installation failed for IntelliJ IDEA. Please install manually SonarLint in your IDE"
        }
        "eclipse" {
            Write-Host "Eclipse does not support automated installation for SonarLint. Please install it manually via the Eclipse Marketplace."
            ExitWithError "SonarLint installation failed for Eclipse. Please install manually SonarLint in your IDE"
        }
        "pycharm" {
            Write-Host "PyCharm does not support automated installation for SonarLint. Please install it manually via the Plugins Marketplace."
            ExitWithError "SonarLint installation failed for PyCharm. Please install manually SonarLint in your IDE"
        }
        "androidstudio" {
            Write-Host "Android Studio does not support automated installation for SonarLint. Please install it manually via the Plugins Marketplace."
            ExitWithError "SonarLint installation failed for Android Studio. Please install manually SonarLint in your IDE"
        }
        "rider" {
            Write-Host "Rider does not support automated installation for SonarLint. Please install it manually via the Plugins Marketplace."
            ExitWithError "SonarLint installation failed for Rider. Please install manually SonarLint in your IDE"
        }
        "netbeans" {
            Write-Host "NetBeans does not support automated installation for SonarLint. Please install it manually via the Plugin Manager."
            ExitWithError "SonarLint installation failed for NetBeans. Please install manually SonarLint in your IDE"
        }
        Default {
            ExitWithError "Unsupported IDE: $ide."
        }
    }
}

# List of supported IDEs and their details
$ideChoices = @{
    "visualstudio"    = @{ Path = "$env:LOCALAPPDATA\Microsoft\VisualStudio"; Pattern = "SonarLint.VisualStudio*" }
    "vscode"          = @{ Path = "$env:USERPROFILE\.vscode\extensions"; Pattern = "sonarsource.sonarlint*" }
    "intellij"        = @{ Path = "$env:APPDATA\JetBrains\IdeaIC*\plugins"; Pattern = "sonarlint*" }
    "eclipse"         = @{ Path = "$env:USERPROFILE\eclipse\plugins"; Pattern = "org.sonarlint.eclipse*" }
    "pycharm"         = @{ Path = "$env:APPDATA\JetBrains\PyCharm*\plugins"; Pattern = "sonarlint*" }
    "androidstudio"   = @{ Path = "$env:APPDATA\Google\AndroidStudio*\plugins"; Pattern = "sonarlint*" }
    "rider"           = @{ Path = "$env:APPDATA\JetBrains\Rider*\plugins"; Pattern = "sonarlint*" }
    "netbeans"        = @{ Path = "$env:USERPROFILE\AppData\Roaming\NetBeans\modules"; Pattern = "sonarlint*" }
}

# Try to automatically detect the IDE based on environment variables or command-line arguments
$selectedIDE = $args[0]

# Check if the IDE argument is passed, else try to detect from environment variables
if (-not $selectedIDE) {
    if ($env:VSCODE_PID) {
        $selectedIDE = "vscode"
    } elseif ($env:IDEA_UI) {
        $selectedIDE = "intellij"
    } elseif ($env:ECLIPSE_HOME) {
        $selectedIDE = "eclipse"
    } elseif ($env:PYCHARM) {
        $selectedIDE = "pycharm"
    } elseif ($env:ANDROID_STUDIO) {
        $selectedIDE = "androidstudio"
    } elseif ($env:RIDER) {
        $selectedIDE = "rider"
    } elseif ($env:NETBEANS_HOME) {
        $selectedIDE = "netbeans"
    } elseif ($env:VisualStudio) {
        $selectedIDE = "visualstudio"
    }
}

# If no IDE is detected, prompt the user to input the IDE
if (-not $selectedIDE) {
    Write-Host "No IDE detected. Please provide the IDE name (e.g., visualstudio, vscode, intellij, eclipse, pycharm, androidstudio, rider, netbeans):"
    $selectedIDE = Read-Host "Enter IDE name"
}

Write-Host "Detected IDE: $selectedIDE"

# Validate if the selected IDE is supported
if (-not $ideChoices.ContainsKey($selectedIDE.ToLower())) {
    ExitWithError "Unsupported IDE: $selectedIDE. Supported IDEs: $(($ideChoices.Keys -join ', '))."
}

# Retrieve the validation details for the selected IDE
$ideDetails = $ideChoices[$selectedIDE.ToLower()]

# Validate SonarLint installation
Write-Host "Checking SonarLint installation for $selectedIDE..."

# Check if SonarLint is installed for the selected IDE by searching for the expected files
$sonarLintInstalled = Get-ChildItem -Path $ideDetails.Path -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Name -like $ideDetails.Pattern }

if (-not $sonarLintInstalled) {
    Write-Host "SonarLint is not installed for $selectedIDE. Installing now..."
    InstallSonarLint $selectedIDE
} else {
    Write-Host "SonarLint is already installed for $selectedIDE."
}
