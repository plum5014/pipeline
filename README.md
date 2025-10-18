# Game QA Training Kit (Windows + Jenkins + Postman) — v2

This kit provides a ready-to-use environment for API testing practice using **Postman/Newman** and **Jenkins**, with a **Mock Game API** server.

## Contents
- `GameQA_ENV.postman_environment.json` — Postman environment with variables
- `Login_API_Test.postman_collection.json` — login flow to fetch auth token
- `Ranking_API_Test.postman_collection.json` — ranking API verification
- `Item_Grant_API_Test.postman_collection.json` — item grant verification
- `Jenkinsfile` — pipeline to run Newman and archive HTML reports (exports env after Login)
- `Test_Case_Template.xlsx` — test case spreadsheet
- `Bug_Report_Template.md` — structured bug report template
- `server.js`, `package.json` — mock API server (Express)
- `run_all_tests.bat` — one-click Newman runner (exports env after Login)

## Quick Start

### 1) Run Mock Server
```bash
npm install
node server.js
```
Server runs on `http://localhost:3000`

### 2) Import Postman Files
- Import `GameQA_ENV.postman_environment.json`
- Import each `*_API_Test.postman_collection.json`
- Run **Login - obtain token** (or use the batch script) to set `auth_token`

### 3) Run via Newman (local, without Jenkins)
```bash
npm install -g newman newman-reporter-htmlextra
run_all_tests.bat
```
HTML reports appear in `newman` folder.

### 4) Run in Jenkins
- Create a Pipeline job pointing at these files.
- Ensure **Global Tool Configuration > NodeJS** includes a tool named `nodejs`.
- Build — reports will be archived as artifacts under `newman/*.html`.
