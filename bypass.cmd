@echo off
curl -L -o C:\Windows\Panther\unattend.xml https://mxioi.uk/unattend.xml
%WINDIR%\System32\Sysprep\Sysprep.exe /oobe /unattend:C:\Windows\Panther\unattend.xml /reboot
