#!/usr/bin/env powershell
#requires -RunAsAdministrator
#requires -Version 5.0

$AppsToBeUninstalled = @(
    'Microsoft.3DBuilder'
    'Microsoft.WindowsFeedbackHub'
    'Microsoft.MicrosoftOfficeHub'
    'Microsoft.MicrosoftSolitaireCollection*'
    'Microsoft.BingFinance'
    'Microsoft.BingNews'
    'Microsoft.SkypeApp'
    'Microsoft.BingSports'
    'Microsoft.Office.Sway'
    'Microsoft.XboxApp'
    'Microsoft.MicrosoftStickyNotes'
    'Microsoft.ConnectivityStore'
    'Microsoft.CommsPhone'
    'Microsoft.WindowsPhone'
    'Microsoft.OneConnect'
    'Microsoft.People'
    'Microsoft.Appconnector'
    'Microsoft.Getstarted'
    'Microsoft.WindowsMaps'
    'Microsoft.ZuneMusic'
    'Microsoft.Freshpaint'
    'Flipboard.Flipboard'
    '9E2F88E3.Twitter'
    'king.com.CandyCrushSodaSaga'
    'Drawboard.DrawboardPDF'
    'Facebook.Facebook'
)

foreach ($App in $AppsToBeUninstalled) {
    Get-AppxPackage -AllUsers -Name "$App" | Remove-AppxPackage -Confirm:$false
    Get-AppxProvisionedPackage -Online | Where DisplayName -EQ "$App" | Remove-AppxProvisionedPackage -Online
}
