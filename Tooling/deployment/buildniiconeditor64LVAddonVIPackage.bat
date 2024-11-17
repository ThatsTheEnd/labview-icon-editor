@echo on
setlocal
set "VIServerPort=3370"
set "RelativePath=C:\labview-icon-editor\"
set "ModifyIconEditorProjectVI=Tooling\deployment\NIPackage\ModifyProjectDeployLVAddons.vi"
set "ModifyIconEditorProjectVIPath="%RelativePath%%ModifyIconEditorProjectVI%""
set "IconEditorBuildSpec="Editor Packed Library""
set "LabVIEWPath="C:\Program Files\National Instruments\LabVIEW 2021\LabVIEW.exe""

REM Delete built LVAddon
cd LabVIEW CLI
dir
REM Create INI token localhost.LibraryPath on LabVIEW.ini that points to the development folder
LabVIEWCLI -OperationName RunVI -VIPath "%RelativePath%Tooling\deployment\NIPackage\CreateLVINILocalHostKey.vi" -LabVIEWPath %LabVIEWPath% -PortNumber %VIServerPort% -LogFilePath "C:\Users\Public\CLIlog1.txt" -Verbosity Diagnostic -LogToConsole TRUE

LabVIEWCLI -OperationName CloseLabVIEW -PortNumber %VIServerPort%

REM Prepare labview to use icon editor to use source code
LabVIEWCLI -OperationName RunVI -VIPath "%RelativePath%\Tooling\Prepare LV to Use Icon Editor Source v2.vi" -LabVIEWPath %LabVIEWPath% -PortNumber %VIServerPort% -LogFilePath "C:\Users\Public\CLIlog2.txt" -Verbosity Diagnostic -LogToConsole TRUE

REM Modify the icon editor build spec to deploy to LVAddons
LabVIEWCLI -OperationName RunVI -VIPath %ModifyIconEditorProjectVIPath% "%RelativePath%lv_icon_editor.lvproj" %IconEditorBuildSpec% -LabVIEWPath %LabVIEWPath% -PortNumber %VIServerPort% -LogFilePath "C:\Users\Public\CLIlog3.txt" -Verbosity Diagnostic -LogToConsole TRUE

LabVIEWCLI -OperationName CloseLabVIEW -PortNumber %VIServerPort%

REM Build the PPL
LabVIEWCLI -OperationName ExecuteBuildSpec -ProjectPath "%RelativePath%lv_icon_editor.lvproj" -LabVIEWPath %LabVIEWPath% -PortNumber %VIServerPort% -LogFilePath "C:\Users\Public\CLIlog4.txt" -Verbosity Detailed -LogToConsole TRUE -TargetName "My Computer" -BuildSpecName %IconEditorBuildSpec%

REM Create JSON file on LVAddon

LabVIEWCLI -OperationName RunVI -VIPath "%RelativePath%Tooling\deployment\NIPackage\CreateLVAddonJSONfile.vi" -LabVIEWPath %LabVIEWPath% -PortNumber %VIServerPort% -LogFilePath "C:\Users\Public\CLIlog5.txt" -Verbosity Diagnostic -LogToConsole TRUE

LabVIEWCLI -OperationName CloseLabVIEW -PortNumber %VIServerPort%

echo "All LabVIEW CLI commands completed successfully."
echo "Script finished"

endlocal