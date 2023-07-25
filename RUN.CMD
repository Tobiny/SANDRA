@ECHO OFF

SETLOCAL EnableDelayedExpansion

set JAVAPATH=java
IF EXIST javapath.txt FOR /F "eol=# delims=" %%i IN (javapath.txt) DO SET JAVAPATH=%%i

set VMARGS=

FOR %%f in (
    start.args
    vm-args.txt
    RESOURCE\DEFAULT.INI
    RESOURCE\CDVIEWER.INI
) do (
    IF EXIST %%f FOR /F "eol=# delims=" %%i IN (%%f) DO set VMARGS=!VMARGS! %%i
)

ECHO.%VMARGS% | FIND /I "-Xms">Nul && ECHO OFF || ( set VMARGS=%VMARGS% -Xms1000m )
ECHO.%VMARGS% | FIND /I "-Xmx">Nul && ECHO OFF || ( set VMARGS=%VMARGS% -Xmx1000m )

:START
%JAVAPATH% %VMARGS% -jar plugins/org.eclipse.equinox.launcher-1.5.200.jar -application com.agfa.pacs.login.LoginManager
if %errorlevel% EQU 23 goto START
