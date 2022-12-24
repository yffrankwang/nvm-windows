REM go install github.com/josephspurrier/goversioninfo/cmd/goversioninfo@latest

SET GOARCH=amd64
SET GOOS=windows
SET GO111MODULE=on

SET COMPANY=github.com/yffrankwang
SET PRODUCT=NVM Windows
SET EXENAME=nvm.exe
SET PKG=nvm/ver

FOR /F "tokens=* USEBACKQ" %%i IN (`powershell -Command "Get-Date -date (Get-Date).ToUniversalTime()-uformat %%Y-%%m-%%dT%%H:%%M:%%SZ"`) DO (
	SET BUILD_TIME=%%i
)

SET YEAR=%BUILD_TIME:~0,4%
SET VER_MAJOR=1
SET VER_MINOR=1
SET VER_PATCH=10
SET VERSION=%VER_MAJOR%.%VER_MINOR%.%VER_PATCH%
FOR /F "tokens=* USEBACKQ" %%i IN (`git rev-parse --short HEAD`) DO (
	SET REVISION=%%i
)

SET /A VER_BUILD=0x%REVISION%
SET VER_BUILD=%VER_BUILD:~0,4%

(
echo {
echo 	"FixedFileInfo": {
echo 		"FileVersion": {
echo 			"Major": %VER_MAJOR%,
echo 			"Minor": %VER_MINOR%,
echo 			"Patch": %VER_PATCH%,
echo 			"Build": %VER_BUILD%
echo 		},
echo 		"FileFlagsMask": "3f",
echo 		"FileFlags ": "00",
echo 		"FileOS": "040004",
echo 		"FileType": "01",
echo 		"FileSubType": "00"
echo 	},
echo 	"StringFileInfo": {
echo 		"Comments": "",
echo 		"CompanyName": "%COMPANY%",
echo 		"FileDescription": "%PRODUCT% %VERSION%.%REVISION%",
echo 		"FileVersion": "",
echo 		"InternalName": "",
echo 		"LegalCopyright": "Copyright (c) %YEAR% %COMPANY%, All Rights Reserved",
echo 		"LegalTrademarks": "",
echo 		"OriginalFilename": "%EXENAME%",
echo 		"PrivateBuild": "",
echo 		"ProductName": "%PRODUCT%",
echo 		"ProductVersion": "%VERSION%.%REVISION%",
echo 		"SpecialBuild": ""
echo 	},
echo 	"VarFileInfo": {
echo 		"Translation": {
echo 			"LangID": "0409",
echo 			"CharsetID": "04B0"
echo 		}
echo 	},
echo 	"IconPath": "nodejs.ico",
echo 	"ManifestPath": ""
echo }
) > versioninfo.json

go generate
go build -ldflags "-X %PKG%.Version=%VERSION% -X %PKG%.Revision=%REVISION% -X %PKG%.buildTime=%BUILD_TIME%"
