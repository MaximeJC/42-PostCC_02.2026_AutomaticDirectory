# ----------------------------------------------------------------
#
#                     ADPackageInstallor.ps1
#
# ----------------------------------------------------------------

Try {
    # Install AD DS and dependencies
    Install-WindowsFeature -name AD-Domain-Services -IncludeManagementTools

    # Install DNS and dependencies
    Install-WindowsFeature -Name DNS -IncludeManagementTools
}
Catch {
    Write-Host "Error message:" -ForegroundColor Red
    Write-Host $_.Exception.Message

    Write-Host "`nFull exception details:" -ForegroundColor Yellow
    Write-Host $_.Exception.ToString()

    Write-Host "`nStack trace:"
    Write-Host $_.ScriptStackTrace
}


