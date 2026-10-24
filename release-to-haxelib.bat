@echo off
setlocal
rem Build an isolated package first; never delete a previous release candidate.
powershell -NoProfile -File "%~dp0build-release.ps1"
if errorlevel 1 exit /b 1
rem Publishing is an explicit second action. Submit the printed ZIP when ready:
rem haxelib submit "release\vision-VERSION-TIMESTAMP.zip"
