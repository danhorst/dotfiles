@echo OFF
SET SCRIPT_PATH=C:\Users\%USERNAME%\WSL2
powershell -ExecutionPolicy unrestricted -Command "& { cd '%SCRIPT_PATH%'; .\fix-net.ps1 }" < nul