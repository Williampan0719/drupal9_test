:: Examples: 
::  win_docker.bat start
::  win_docker.bat stop

:: Remove the following line if you want to debug and check the variables
@ECHO OFF

SETLOCAL
SET ACTION=%1
SET CURRENT_DIR=%~dp0%
SET CURRENT_USER_UID=1000
SET CURRENT_USER_GID=1001

cd %CURRENT_DIR%\..\

IF "%ACTION%"=="start" (
	CALL:check_env_file || GOTO:EOF
	docker-compose up -d
) ELSE IF "%ACTION%"=="stop" (
	docker-compose stop
) ELSE IF "%ACTION%"=="down" (
	docker-compose down
) ELSE IF "%ACTION%"=="logs" (
	docker-compose logs
) ELSE (
	ECHO "Usage: win_docker.bat {start|stop|down|logs}"
)
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

    :: Check the environment variables if database is required
	SET DOCKER_SERVICES=
	FOR /f %%G IN ('docker-compose config --services') DO CALL SET DOCKER_SERVICES=%%DOCKER_SERVICES%%,%%G
	
	IF NOT x"%DOCKER_SERVICES:database=%"==x"%DOCKER_SERVICES%" (
		CALL:check_env_variable "%MYSQL_VERSION%" MYSQL_VERSION || EXIT /B 1
		CALL:check_env_variable "%MYSQL_DB_NAME%" MYSQL_DB_NAME || EXIT /B 1
		CALL:check_env_variable "%MYSQL_USER%" MYSQL_USER || EXIT /B 1
		CALL:check_env_variable "%MYSQL_PASSWORD%" MYSQL_PASSWORD || EXIT /B 1
		CALL:check_env_variable "%MYSQL_ROOT_PASSWORD%" MYSQL_ROOT_PASSWORD || EXIT /B 1
	)
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
