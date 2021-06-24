:: Remove the following line if you want to debug and check the variables
@ECHO OFF

ECHO Enter a number to choose which cache to clear
ECHO [1]    Memcahed
ECHO [2]    Varnish
ECHO [else] Both

SETLOCAL
SET /p CLEAR_TYPE=
SET CURRENT_USER_UID=1000
SET CURRENT_USER_GID=1001
CALL:check_env_file || GOTO:EOF

:: Flush memcache
IF "%CLEAR_TYPE%" NEQ "2" (
    FOR /f "tokens=*" %%G IN ('docker-compose ps -q memcached') DO (
		ECHO The memcache docker container ID is %%G
		docker exec %%G bash -c "echo flush_all > /dev/tcp/127.0.0.1/11211" || EXIT /B 1
		ECHO Memcache was cleared successfully
	)
)


:: Flush varnish
IF "%CLEAR_TYPE%" NEQ "1" (
    FOR /f "tokens=*" %%G IN ('docker-compose ps -q varnish') DO (
		ECHO The varnish docker container ID is %%G
		docker exec %%G sh -c "varnishadm \"ban req.http.host ~ .\"" || EXIT /B 1
		ECHO Varnish cache was cleared successfully
	)
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
