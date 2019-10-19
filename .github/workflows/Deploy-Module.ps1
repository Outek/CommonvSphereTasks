Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

$releaseNotes = $env:RELEASE_NOTES
$moduleVersion = ($env:RELEASE_VERSION) -replace "v",""
Write-Host "ModuleVersion: $moduleVersion"

$manifestPath = Resolve-Path -Path "*\CommonvSphereTasks.psd1"

Update-ModuleManifest -ReleaseNotes $releaseNotes -Path $manifestPath.Path -ModuleVersion $moduleVersion #-Verbose

$moduleFilePath = Resolve-Path -Path "*\CommonvSphereTasks.psm1"

$modulePath = Split-Path -Parent $moduleFilePath

$nuGetApiKey = $env:PSGALLERY_TOKEN

try{
    Publish-Module -Path $modulePath -NuGetApiKey $nuGetApiKey -ErrorAction Stop -Force #-Debug
    Write-Host "The CommonvSphereTasks Module Version $moduleVersion has been Published to the PowerShell Gallery!"
}
catch {
    throw $_
}