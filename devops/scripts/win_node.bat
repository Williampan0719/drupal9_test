:: Examples: 
::  win_node.bat npm install
::  win_node.bat npn run build

:: Remove the following line if you want to debug and check the variables
@ECHO OFF

SETLOCAL
SET CURRENT_DIR=%~dp0%
SET CURRENT_USER_UID=1000
SET CURRENT_USER_GID=1001
CALL:check_env_file || GOTO:EOF

docker run --rm -it ^
    --volume "%CURRENT_DIR%\..\..\%NODE_FOLDER_PATH%":/app ^
    --workdir /app ^
    ciandtchina/node:10-build-tools %*

GOTO:EOF

:: Functions
EXIT /B %ERRORLEVEL%
:check_env_file
    :: Check the existance of the .env file, and read the  them
	SET ENV_FILE_PATH=%CURRENT_DIR%\..\.env
    IF EXIST "%ENV_FILE_PATH%" (
		FOR /f "delims== tokens=1,2" %%G IN (%ENV_FILE_PATH%) DO SET %%G=%%H
	) ELSE (
        ECHO Please make sure your .env file is existed under the devops directoy
		EXIT /B 1
    )

    :: Check the environment variables
	:: Return 1 if any of the required variables are not defined
    CALL:check_env_variable "%COMPOSE_PROJECT_NAME%" COMPOSE_PROJECT_NAME || EXIT /B 1
    CALL:check_env_variable "%PROJECT_KEY%" PROJECT_KEY || EXIT /B 1
    CALL:check_env_variable "%PHP_VERSION%" PHP_VERSION || EXIT /B 1
	EXIT /B 0

:check_env_variable
	SET IS_VAR_EMPTY=FALSE
	IF [%1] == [""] SET IS_VAR_EMPTY=TRUE
	IF [%2] == [] SET IS_VAR_EMPTY=TRUE
	IF "%IS_VAR_EMPTY%" == "TRUE" (
        ECHO %2 must be defined in your .env file
        EXIT /B 1
    )
	EXIT /B 0
