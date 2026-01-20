@echo off
echo Starting Power BI Murder Mystery...
echo.

cd /d "%~dp0"

REM Activate virtual environment and start Flask
call venv\Scripts\activate.bat
python app.py

pause
