echo "building hcsshim"
Push-Location $env:GOPATH\src\github.com\Microsoft\hcsshim
# this is auto set during install by choco
# set PATH=C:\mingw-w64\x86_64-7.2.0-posix-seh-rt_v5-rev1\mingw64\bin;%PATH%
go build -o "./_output/runhcs.exe" ./cmd/runhcs
Pop-Location

echo "building containerd-cri"
Push-Location $env:GOPATH/src/github.com/containerd/cri
set GOOS=windows 
make
Pop-Location

echo "building containerd"
Push-Location $env:GOPATH/src/github.com/containerd/containerd
set GOOS=windows
make
Pop-Location

echo "get latest version of  crictl tools"
Push-Location $env:GOPATH/src/github.com/kubernetes-sigs/cri-tools
make windows
Pop-Location

echo "copy build binaries to folder"
$binaryPath = "c:\kubebinaries"
mkdir -p $binaryPath\azurecni -ErrorAction SilentlyContinue
mkdir -p $binaryPath\containerd -ErrorAction SilentlyContinue
mkdir -p $binaryPath\kube -ErrorAction SilentlyContinue

echo "copy containerd"
cp $env:GOPATH/src/github.com/containerd/cri/_output/ctr.exe $binaryPath\containerd
cp $env:GOPATH/src/github.com/containerd/cri/_output/containerd.exe $binaryPath\containerd
cp $env:GOPATH/src/github.com/containerd/containerd/bin/containerd-shim-runhcs-v1.exe $binaryPath\containerd
cp $env:GOPATH/src/github.com/Microsoft/hcsshim/_output/runhcs.exe $binaryPath\containerd
cp $env:GOPATH/src/github.com/kubernetes-sigs/cri-tools/_output/crictl.exe $binaryPath\containerd