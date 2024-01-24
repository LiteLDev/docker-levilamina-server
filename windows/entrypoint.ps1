if ($null -eq $env:EULA) {
    $env:EULA = "FALSE"
}
if ($null -eq $env:PACKAGES) {
    $env:PACKAGES = ""
}
if ($null -eq $env:VERSION) {
    $env:VERSION = "LATEST"
}

if ($env:EULA.ToUpper() -ne "TRUE") {
    Write-Host "You must accept the Minecraft EULA to run the server."
    Write-Host "Set the environment variable EULA to TRUE to accept it."
    exit 1
}

if (-not (Test-Path "bedrock_server_mod.exe")) {
    if ($env:VERSION -eq "LATEST") {
        .\lip.exe install -y github.com/LiteLDev/LeviLamina
    }
    else {
        .\lip.exe install -y "github.com/LiteLDev/LeviLamina@$env:VERSION"
    }

    if (-not ($env:PACKAGES -eq "")) {
        foreach ($package in -Split $env:PACKAGES) {
            .\lip.exe install -y $package
        }
    }
}

.\bedrock_server_mod.exe
