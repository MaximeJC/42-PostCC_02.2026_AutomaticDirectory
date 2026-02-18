# ----------------------------------------------------------------
#
#                     ADPackageInstallor.ps1
#
# ----------------------------------------------------------------

# Install AD DS and dependencies
Install-WindowsFeature -name AD-Domain-Services -IncludeManagementTools

# Install DNS and dependencies
Install-WindowsFeature -Name DNS -IncludeManagementTools
