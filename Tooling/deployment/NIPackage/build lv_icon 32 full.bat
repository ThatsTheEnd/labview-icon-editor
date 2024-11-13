@echo on
REM Modify the icon editor build spec to deploy to LVAddons
LabVIEWCLI -OperationName RunVI -VIPath "C:\labview-icon-editor\Tooling\deployment\NIPackage\Modify icon editor project to deploy to LVAddons.vi" "C:\labview-icon-editor\lv_icon_editor.lvproj" "Editor Packed Library" -LabVIEWPath "C:\Program Files (x86)\National Instruments\LabVIEW 2021\LabVIEW.exe" -PortNumber 3363 -LogFilePath "C:\Users\Public\CLIlog1.txt" -Verbosity Detailed -LogToConsole TRUE
REM Build the packed project library
LabVIEWCLI -OperationName ExecuteBuildSpec -ProjectPath "C:\labview-icon-editor\lv_icon_editor.lvproj" -LabVIEWPath "C:\Program Files (x86)\National Instruments\LabVIEW 2021\LabVIEW.exe" -PortNumber 3363 -LogFilePath "C:\Users\Public\CLIlog2.txt" -Verbosity Detailed -LogToConsole TRUE -TargetName "My Computer" -BuildSpecName "Editor Packed Library"
REM Create the JSON file on LVAddons folder
LabVIEWCLI -OperationName RunVI -VIPath "C:\labview-icon-editor\Tooling\deployment\NIPackage\Create LVAddon JSON file.vi" -LabVIEWPath "C:\Program Files (x86)\National Instruments\LabVIEW 2021\LabVIEW.exe" -PortNumber 3363 -LogFilePath "C:\Users\Public\CLIlog3.txt" -Verbosity Detailed -LogToConsole TRUE
REM Build the NI Package
cd /d C:\Program Files\National Instruments\Package Builder
nipbcli -o="C:\labview-icon-editor\Tooling\deployment\NIPackage\LVAddonIE_x86.pbs" -b=packages
echo "All LabVIEW CLI commands completed successfully."