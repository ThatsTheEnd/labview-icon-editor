@echo on
setlocal
set "VIServerPort=3370"
set "RelativePath=C:\labview-icon-editor\"
set "ModifyIconEditorProjectVI=Tooling\deployment\NIPackage\ModifyProjectDeployLVAddons.vi"
set "ModifyIconEditorProjectVIPath="%RelativePath%%ModifyIconEditorProjectVI%""
set "IconEditorBuildSpec="Editor Packed Library""
set "LabVIEWPath="C:\Program Files\National Instruments\LabVIEW 2021\LabVIEW.exe""

REM Prepare icon editor to use source code
LabVIEWCLI -OperationName RunVI -VIPath "%RelativePath%\Tooling\Prepare LV to Use Icon Editor Source v2.vi" -LabVIEWPath %LabVIEWPath% -PortNumber %VIServerPort% -LogFilePath "C:\Users\Public\CLIlog1.txt" -Verbosity Diagnostic -LogToConsole TRUE

REM Modify the icon editor build spec to deploy to LVAddons
LabVIEWCLI -OperationName RunVI -VIPath %ModifyIconEditorProjectVIPath% "%RelativePath%lv_icon_editor.lvproj" %IconEditorBuildSpec% -LabVIEWPath %LabVIEWPath% -PortNumber %VIServerPort% -LogFilePath "C:\Users\Public\CLIlog1.txt" -Verbosity Diagnostic -LogToConsole TRUE

LabVIEWCLI -OperationName CloseLabVIEW -PortNumber %VIServerPort%

REM Build the packed project library
LabVIEWCLI -OperationName ExecuteBuildSpec -ProjectPath "%RelativePath%lv_icon_editor.lvproj" -LabVIEWPath %LabVIEWPath% -PortNumber %VIServerPort% -LogFilePath "C:\Users\Public\CLIlog2.txt" -Verbosity Detailed -LogToConsole TRUE -TargetName "My Computer" -BuildSpecName %IconEditorBuildSpec%

REM Delete built LVAddon
cd /d C:\Program Files\NI\LVAddons
rmdir /s /q niiconeditor64

echo "All LabVIEW CLI commands completed successfully."
echo "Script finished"
endlocal