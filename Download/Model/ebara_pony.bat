@echo off
chcp 65001 > NUL

start "" https://huggingface.co/tsukihara/xl_model

set SDXL_WEB_UI=%~dp0..\..\SdxlWebUi
pushd %SDXL_WEB_UI%\Model

call %SDXL_WEB_UI%\setup\Download.bat . ebara_pony_1.bakedVAE.safetensorss ^
https://huggingface.co/tsukihara/xl_model/resolve/main/ebara_pony_1.bakedVAE.safetensors
if %errorlevel% neq 0 ( popd & exit /b %errorlevel% )

call %SDXL_WEB_UI%\setup\Download.bat . ebara_pony_1.png ^
https://huggingface.co/tsukihara/xl_model/resolve/main/ebara_pony_1.png
if %errorlevel% neq 0 ( popd & exit /b %errorlevel% )

popd rem %SDXL_WEB_UI%\Model
