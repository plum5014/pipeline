@echo off
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"

rem --- Files
set "ENV=GameQA_ENV.postman_environment.json"
set "COLL_LOGIN=Login_API_Test.postman_collection.json"
set "COLL_RANK=Ranking_API_Test.postman_collection.json"
set "COLL_ITEM=Item_Grant_API_Test.postman_collection.json"
set "OUTDIR=newman"

rem --- Require files
if not exist "%ENV%"          echo [ERROR] Missing %ENV% & goto :fail
if not exist "%COLL_LOGIN%"   echo [ERROR] Missing %COLL_LOGIN% & goto :fail
if not exist "%COLL_RANK%"    echo [ERROR] Missing %COLL_RANK% & goto :fail
if not exist "%COLL_ITEM%"    echo [ERROR] Missing %COLL_ITEM% & goto :fail

rem --- Require newman
where newman >nul 2>&1 || (echo [ERROR] newman not found. Install: npm install -g newman newman-reporter-htmlextra & goto :fail)

if not exist "%OUTDIR%" mkdir "%OUTDIR%"

echo === 1/3: Login ===
call newman run "%COLL_LOGIN%" -e "%ENV%" -r cli,htmlextra --reporter-htmlextra-export "%OUTDIR%\Login_Report.html" --export-environment "%ENV%"
if errorlevel 1 echo [ERROR] Login failed & goto :fail

echo === 2/3: Ranking ===
call newman run "%COLL_RANK%" -e "%ENV%" -r cli,htmlextra --reporter-htmlextra-export "%OUTDIR%\Ranking_Report.html"
if errorlevel 1 echo [ERROR] Ranking failed & goto :fail

echo === 3/3: Item Grant ===
call newman run "%COLL_ITEM%" -e "%ENV%" -r cli,htmlextra --reporter-htmlextra-export "%OUTDIR%\ItemGrant_Report.html"
if errorlevel 1 echo [ERROR] Item Grant failed & goto :fail

echo.
echo [DONE] Reports in "%OUTDIR%": Login_Report.html, Ranking_Report.html, ItemGrant_Report.html
pause
exit /b 0

:fail
echo.
echo [FAILED] See messages above. Make sure mock server is running:  node server.js
pause
exit /b 1
