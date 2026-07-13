$files = @('c:\Users\dines\Desktop\rk industry\index.html', 'c:\Users\dines\Desktop\rk industry\rk industry\index.html')

foreach ($file in $files) {
    if (Test-Path $file) {
        $lines = Get-Content $file

        # Add CSS if not present
        $cssAdded = $false
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match '</style>' -and -not $cssAdded) {
                # Check if it's already there
                $contentStr = $lines -join ""
                if ($contentStr -notmatch "\.prod-btn\.coming-soon") {
                    $lines[$i] = "        .prod-btn.coming-soon {
            background: rgba(255, 255, 255, 0.05);
            color: #94a3b8;
            border: 1px dashed #64748b;
            pointer-events: none;
            box-shadow: none;
        }
" + $lines[$i]
                }
                $cssAdded = $true
            }
        }

        # Modify products
        $inRestrictedProduct = $false
        for ($i = 0; $i -lt $lines.Count; $i++) {
            # Find the start of product 3, 4, 5, 6, 7
            if ($lines[$i] -match "onclick="location\.href='product\.html\?id=([2-6])'"") {
                $lines[$i] = $lines[$i] -replace "onclick="location\.href='product\.html\?id=[2-6]'"", "style="cursor: default;""
                $inRestrictedProduct = $true
            }

            if ($inRestrictedProduct -and $lines[$i] -match "<button class="prod-btn">View Details</button>") {
                $lines[$i] = $lines[$i] -replace "<button class="prod-btn">View Details</button>", "<button class="prod-btn coming-soon">Coming Soon</button>"
                $inRestrictedProduct = $false # Reset after modifying the button for this card
            }
        }

        Set-Content $file $lines
    }
}
Write-Output 'Done'
