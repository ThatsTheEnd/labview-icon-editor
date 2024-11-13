@echo on
setlocal
set "VIServerPort=3363"
set "RelativePath=C:\labview-icon-editor\"
set "ModifyIconEditorProjectVI=Tooling\deployment\NIPackage\ModifyProjectDeployLVAddons.vi"
set "CreateLVAddonJsonFileVI=Tooling\deployment\NIPackage\CreateLVAddonJSONFile.vi"
set "CreateLVAddonJsonFileVIPath="%RelativePath%%CreateLVAddonJsonFileVI%""
set "ModifyIconEditorProjectVIPath="%RelativePath%%ModifyIconEditorProjectVI%""
set "IconEditorBuildSpec="Editor Packed Library""
set "IconEditorNIPMBuildSpec="%RelativePath%Tooling\deployment\NIPackage\LVAddonIE_x86.pbs""
set "LabVIEWPath="C:\Program Files (x86)\National Instruments\LabVIEW 2021\LabVIEW.exe""

REM Modify the icon editor build spec to deploy to LVAddons
LabVIEWCLI -OperationName RunVI -VIPath %ModifyIconEditorProjectVIPath% "%RelativePath%lv_icon_editor.lvproj" %IconEditorBuildSpec% -LabVIEWPath %LabVIEWPath% -PortNumber %VIServerPort% -LogFilePath "C:\Users\Public\CLIlog1.txt" -Verbosity Diagnostic -LogToConsole TRUE

REM Build the packed project library
LabVIEWCLI -OperationName ExecuteBuildSpec -ProjectPath "%RelativePath%lv_icon_editor.lvproj" -LabVIEWPath %LabVIEWPath% -PortNumber %VIServerPort% -LogFilePath "C:\Users\Public\CLIlog2.txt" -Verbosity Detailed -LogToConsole TRUE -TargetName "My Computer" -BuildSpecName %IconEditorBuildSpec%

REM Create the JSON file on LVAddons folder
LabVIEWCLI -OperationName RunVI -VIPath %CreateLVAddonJsonFileVIPath% -LabVIEWPath %LabVIEWPath% -PortNumber %VIServerPort% -LogFilePath "C:\Users\Public\CLIlog3.txt" -Verbosity Detailed -LogToConsole TRUE
)

REM Build the NI Package
cd /d C:\Program Files\National Instruments\Package Builder
nipbcli -o=%IconEditorNIPMBuildSpec% -b=packages

echo "All LabVIEW CLI commands completed successfully."
echo "Script finished"
pause
endlocal