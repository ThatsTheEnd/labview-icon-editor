REM  Run this batch file in admin mode since C:\Program Files\NI\LVAddon requires admin rights
set "Architecture=64"
set "LVVersion=2021" 
set "RelativePath=C:\labview-icon-editor"
set "BuildSpec=Editor Packed Library"
set "NIPB_Path=%RelativePath%\Tooling\deployment\NIPackage\IconEditorDeployment_x%Architecture%.pbs"
set "Project=%RelativePath%\lv_icon_editor.lvproj"

REM Delete built LVAddon
cd /d C:\Program Files\NI\LVAddons
rmdir /s /q niiconeditor%Architecture%

REM Add localhost flag to LabVIEW INI
g-cli --lv-ver %LVVersion% --arch %Architecture% -v "%RelativePath%\Tooling\deployment\NIPackage\CreateLVINILocalHostKey.vi" -- %RelativePath% 

REM Quit LabVIEW
g-cli --lv-ver %LVVersion% --arch %Architecture% QuitLabVIEW

REM Zips and moves lv_icon.lvlibp as well as LabVIEW Icon API from VI Lib to a different location
g-cli --lv-ver %LVVersion% --arch %Architecture% -v "%RelativePath%\Tooling\PrepareIESource.vi" -- "%Project%" "Editor Packed Library"

REM Quit LabVIEW
g-cli --lv-ver %LVVersion% --arch %Architecture% QuitLabVIEW

REM Build the PPL
g-cli --lv-ver %LVVersion% --arch %Architecture% lvbuildspec -- -v 1.1.1.1 -p "%Project%" -b "%BuildSpec%"

REM Create JSON file on LVAddon
g-cli --lv-ver %LVVersion% --arch %Architecture% -v "%RelativePath%\Tooling\deployment\NIPackage\CreateLVAddonJSONfile.vi"

REM Build NI Package
cd /d C:\Program Files\National Instruments\Package Builder
nipbcli -o="%NIPB_Path%" -b=packages -save

REM Removes token LocalHost.LibraryPaths from LabVIEW.ini
g-cli --lv-ver %LVVersion% --arch %Architecture% -v "%RelativePath%\Tooling\deployment\NIPackage\DestroyLVINILocalHostKey.vi"

REM Quit LabVIEW
g-cli --lv-ver %LVVersion% --arch %Architecture% QuitLabVIEW

REM Delete built LVAddon
REM cd /d C:\Program Files\NI\LVAddons
REM rmdir /s /q niiconeditor%Architecture%

pause
echo "All LabVIEW CLI commands completed successfully."
echo "Script finished"