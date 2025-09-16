<#
    This PowerShell script safely cleans up build artifacts (bin and obj folders) in a .NET project.

    How to run:
    .\cleanup-build-artifacts.ps1          # Normal mode, asks for confirmation
    .\cleanup-build-artifacts.ps1 -Force   # Skip confirmation and delete immediately
#>

param(
    [switch]$Force
)

# Start logging
$startTime = Get-Date
Write-Host "=== Cleanup build artifacts started ==="
Write-Host "Start time: $startTime`n"

# Find all 'bin' and 'obj' folders, excluding anything inside .git
$foldersToDelete = Get-ChildItem -Path . -Directory -Recurse |
    Where-Object {
        ($_.Name -in "bin","obj") -and (-not ($_.FullName -like "*\.git*"))
    }

if ($foldersToDelete.Count -eq 0) {
    Write-Host "No folders to delete."
} else {
    Write-Host "Folders to be deleted:"
    $foldersToDelete | ForEach-Object { Write-Host $_.FullName }

    $delete = $false

    if ($Force) {
        $delete = $true
        Write-Host "`nForce switch detected. Deleting without confirmation..."
    } else {
        # Ask for confirmation before deletion
        $confirmation = Read-Host "`nDo you want to delete these folders? (Y/N)"
        if ($confirmation -match "^[Yy]$") {
            $delete = $true
        } else {
            Write-Host "Deletion cancelled by user."
        }
    }

    if ($delete) {
        foreach ($folder in $foldersToDelete) {
            Write-Host "Deleting: $($folder.FullName)"
            Remove-Item $folder.FullName -Recurse -Force
        }
        Write-Host "`nDeletion completed. Total folders deleted: $($foldersToDelete.Count)"
    }
}

# End logging
$endTime = Get-Date
Write-Host "`n=== Cleanup build artifacts finished ==="
Write-Host "End time: $endTime"
