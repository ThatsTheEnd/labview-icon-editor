@echo off

REM Build the NI Package
cd /d C:\Program Files\National Instruments\Package Builder
nipbcli -o="C:\labview-icon-editor\Tooling\deployment\NIPackage\IconEditorDeployment_x64.pbs" -b=packages -save

echo "Script finished"
exit