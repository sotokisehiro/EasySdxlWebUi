@echo off
chcp 65001 > NUL

setlocal enabledelayedexpansion
if not exist %~dp0SdxlWebUi\stable-diffusion-webui-forge\ (
	echo call %~dp0SdxlWebUi\setup\Setup-SdxlWebUi-forge.bat
	call %~dp0SdxlWebUi\setup\Setup-SdxlWebUi-forge.bat
	if !errorlevel! neq 0 ( endlocal & exit /b !errorlevel! )
)
if not exist %~dp0SdxlWebUi\venv-forge\ (
	echo call %~dp0SdxlWebUi\setup\Setup-SdxlWebUi-forge.bat
	call %~dp0SdxlWebUi\setup\Setup-SdxlWebUi-forge.bat
	if !errorlevel! neq 0 ( endlocal & exit /b !errorlevel! )
)
endlocal

pushd %~dp0SdxlWebUi\stable-diffusion-webui-forge\

set PYTHON=%~dp0SdxlWebUi\venv-forge\Scripts\python.exe
set VENV_DIR=%~dp0SdxlWebUi\venv-forge
set GIT=
where /Q git
if %ERRORLEVEL% neq 0 ( set GIT=%~dp0SdxlWebUi\setup\lib\PortableGit\bin\git.exe )

set COMMANDLINE_ARGS=--gradio-allowed-path .. %*

%PYTHON% %~dp0SdxlWebUi\setup\update_json.py %~dp0SdxlWebUi\config.json config.json
if %errorlevel% neq 0 ( pause & popd & exit /b %errorlevel% )

%PYTHON% %~dp0SdxlWebUi\setup\update_json.py %~dp0SdxlWebUi\ui-config.json ui-config.json
if %errorlevel% neq 0 ( pause & popd & exit /b %errorlevel% )

@REM style.csv の同期
set SRC_STYLE_PATH=..\stable-diffusion-webui\styles.csv
for %%i in ("%SRC_STYLE_PATH%") do set "SRC_STYLE_DATE=%%~ti"

set DST_STYLE_PATH=styles.csv
for %%i in ("%DST_STYLE_PATH%") do set "DST_STYLE_DATE=%%~ti"

set "DATE_TIME=%DATE:/=-%_%TIME::=-%"
set "DATE_TIME=%DATE_TIME: =0%"
set "DATE_TIME=%DATE_TIME:~0,-3%"
set DST_STYLE_BACKUP_PATH=styles_%DATE_TIME%.csv

setlocal enabledelayedexpansion
if exist %SRC_STYLE_PATH% (
	if exist %DST_STYLE_PATH% (
		if "%SRC_STYLE_DATE%" gtr "%DST_STYLE_DATE%" (
			echo move %DST_STYLE_PATH% %DST_STYLE_BACKUP_PATH%
			move %DST_STYLE_PATH% %DST_STYLE_BACKUP_PATH%
			if !errorlevel! neq 0 ( pause & endlocal & popd & exit /b 1 )

			echo copy %SRC_STYLE_PATH% %DST_STYLE_PATH%
			copy %SRC_STYLE_PATH% %DST_STYLE_PATH%
			if !errorlevel! neq 0 ( pause & endlocal & popd & exit /b 1 )
		)
	) else (
		echo copy %SRC_STYLE_PATH% %DST_STYLE_PATH%
		copy %SRC_STYLE_PATH% %DST_STYLE_PATH%
		if !errorlevel! neq 0 ( pause & endlocal & popd & exit /b 1 )
	)
)
endlocal

echo webui.bat %COMMANDLINE_ARGS%
call webui.bat

popd rem %~dp0SdxlWebUi\stable-diffusion-webui-forge\
