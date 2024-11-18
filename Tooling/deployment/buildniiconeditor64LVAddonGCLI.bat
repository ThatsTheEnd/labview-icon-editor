@echo on
setlocal
set "Architecture=64"
set "RelativePath=C:\labview-icon-editor\"
set "ModifyIconEditorProjectVIPath="%RelativePath%%ModifyIconEditorProjectVI%""
set "IconEditorBuildSpec="Editor Packed Library""
set "LabVIEWPath="C:\Program Files\National Instruments\LabVIEW 2021\LabVIEW.exe""

REM Add localhost flag to LabVIEW INI
g-cli --lv-ver 2021 --arch %Architecture% -v "%RelativePath%Tooling\deployment\NIPackage\CreateLVINILocalHostKey.vi"

REM Prepare labview to use icon editor to use source code
g-cli --lv-ver 2021 --arch %Architecture% -v "%RelativePath%Tooling\PrepareIESource.vi"

REM Quit LabVIEW
g-cli --lv-ver 2021 --arch %Architecture% QuitLabVIEW

REM Build the PPL
g-cli --lv-ver 2021 --arch %Architecture% lvbuildspec -- -v 1.1.1.1 -p "%RelativePath%lv_icon_editor.lvproj" -b "Editor Packed Library"

REM Create JSON file on LVAddon
g-cli --lv-ver 2021 --arch %Architecture% -v "%RelativePath%Tooling\deployment\NIPackage\CreateLVAddonJSONfile.vi"

REM Removes token LocalHost.LibraryPaths from LabVIEW.ini
g-cli --lv-ver 2021 --arch %Architecture% -v "%RelativePath%Tooling\deployment\NIPackage\DestroyLVINILocalHostKey.vi"

g-cli --lv-ver 2021 --arch %Architecture% QuitLabVIEW

pause
echo "All LabVIEW CLI commands completed successfully."
echo "Script finished"

endlocal