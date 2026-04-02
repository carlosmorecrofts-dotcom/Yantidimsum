# ============================================================
# DY Dimsum Skills Pack Installer
# Installs 10 specialized skills for Indonesian food business
# ============================================================

Write-Host ""
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "  DY DIMSUM - Skills Pack Installer" -ForegroundColor Yellow
Write-Host "  10 Skills for Food Business Success" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""

# Step 1: Clone the repo (if not already cloned)
$repoUrl = "https://github.com/carlosmorecrofts-dotcom/Yantidimsum.git"
$cloneDir = "$env:USERPROFILE\Yantidimsum"

if (Test-Path $cloneDir) {
    Write-Host "[OK] Repo already exists at $cloneDir" -ForegroundColor Green
    Write-Host "     Pulling latest changes..." -ForegroundColor Gray
    Push-Location $cloneDir
    git pull origin main 2>$null
    Pop-Location
} else {
    Write-Host "[>>] Cloning repo..." -ForegroundColor Cyan
    git clone $repoUrl $cloneDir
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Failed to clone repo. Check your git setup." -ForegroundColor Red
        exit 1
    }
    Write-Host "[OK] Repo cloned to $cloneDir" -ForegroundColor Green
}

# Step 2: Set paths
$skillsSource = Join-Path $cloneDir "skills-pack"
$skillsDest = "$env:USERPROFILE\.claude\skills"

# Check source exists
if (-not (Test-Path $skillsSource)) {
    Write-Host "[ERROR] Skills pack not found at $skillsSource" -ForegroundColor Red
    exit 1
}

# Create destination if needed
if (-not (Test-Path $skillsDest)) {
    New-Item -ItemType Directory -Force -Path $skillsDest | Out-Null
    Write-Host "[OK] Created skills directory: $skillsDest" -ForegroundColor Green
}

# Step 3: Install each skill
Write-Host ""
Write-Host "Installing skills..." -ForegroundColor Cyan
Write-Host ""

$installed = 0
$skipped = 0

Get-ChildItem -Path $skillsSource -Directory | ForEach-Object {
    $skillName = $_.Name
    $skillFile = Join-Path $_.FullName "SKILL.md"
    $destFolder = Join-Path $skillsDest $skillName
    $destFile = Join-Path $destFolder "SKILL.md"

    if (Test-Path $skillFile) {
        # Create skill directory
        New-Item -ItemType Directory -Force -Path $destFolder | Out-Null

        # Check if skill already exists
        if (Test-Path $destFile) {
            $sourceHash = (Get-FileHash $skillFile -Algorithm MD5).Hash
            $destHash = (Get-FileHash $destFile -Algorithm MD5).Hash
            if ($sourceHash -eq $destHash) {
                Write-Host "  [=] $skillName (already up-to-date)" -ForegroundColor DarkGray
                $skipped++
                return
            }
        }

        # Copy skill
        Copy-Item $skillFile -Destination $destFile -Force
        Write-Host "  [+] $skillName" -ForegroundColor Green
        $installed++
    }
}

# Step 4: Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "  Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Installed: $installed skills" -ForegroundColor Green
if ($skipped -gt 0) {
    Write-Host "  Skipped:   $skipped (already up-to-date)" -ForegroundColor DarkGray
}
Write-Host ""
Write-Host "  Skills installed:" -ForegroundColor White
Write-Host "  1. dim-sum-business-planner    - Business plans & SWOT" -ForegroundColor Gray
Write-Host "  2. indonesian-food-brand       - Logo & brand identity" -ForegroundColor Gray
Write-Host "  3. medan-market-researcher     - Market analysis" -ForegroundColor Gray
Write-Host "  4. food-delivery-optimizer     - GoFood/GrabFood strategy" -ForegroundColor Gray
Write-Host "  5. halal-certification-guide   - Halal/PIRT/BPOM permits" -ForegroundColor Gray
Write-Host "  6. food-social-media           - Instagram/TikTok strategy" -ForegroundColor Gray
Write-Host "  7. cloud-kitchen-ops           - Kitchen setup & workflows" -ForegroundColor Gray
Write-Host "  8. frozen-food-ecommerce       - Tokopedia/Shopee selling" -ForegroundColor Gray
Write-Host "  9. food-photography-content    - Website & visual content" -ForegroundColor Gray
Write-Host " 10. indonesian-food-financial   - Financial projections" -ForegroundColor Gray
Write-Host ""
Write-Host "  Restart Claude Code to activate skills." -ForegroundColor Yellow
Write-Host ""
