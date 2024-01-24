cd C:/Users/ContainerAdministrator/Downloads

# Dowload and install vcruntime2022
wget -O "vc_redist.x64.exe" "https://aka.ms/vs/17/release/vc_redist.x64.exe"
./vc_redist.x64.exe /install /quiet /norestart
rm vc_redist.x64.exe

# Download lip
mkdir -p 'C:/Program Files/Lip'
wget "https://github.com/lippkg/lip/releases/latest/download/lip-windows-amd64.zip"
unzip lip-windows-amd64.zip -d "C:/Program Files/Lip/"
rm lip-windows-amd64.zip