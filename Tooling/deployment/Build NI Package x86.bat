@echo off

REM Build the NI Package
cd /d C:\Program Files\National Instruments\Package Builder
nipbcli -o="C:\labview-icon-editor\Tooling\deployment\NIPackage\IconEditorDeployment_x86.pbs" -b=packages -save

echo "Script finished"
exit