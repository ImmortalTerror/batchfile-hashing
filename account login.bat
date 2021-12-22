@echo off

@REM Checks for Accounts folder.
if not exist Accounts mkdir Accounts
cd Accounts

@REM Main menu
:start
cls
echo Do you already have an account? (Y/N)
choice /c yn
goto %ERRORLEVEl%



@REM Menu to log into an account.
:1
cls
echo Enter the name of the account you want to log into
set /p name=Name: 

@REM Hashes the name you entered
echo %name%>%temp%\hashinput.tmp
CertUtil -hashfile %temp%\hashinput.tmp sha256 | findstr /v "hash">%temp%\hashoutput.tmp
set /p h_name=<%temp%\hashoutput.tmp

del %temp%\hashinput.tmp
del %temp%\hashoutput.tmp

@REM Checks if the account exists
if not exist %h_name%.dll (
    echo.
    echo Account "%name%" does not exist
    set name=
    set h_name=
    timeout /t 3 >nul
    goto start
)

@REM Sets the stored password to a variable
set /p f_password=<%h_name%.dll

@REM Enter password
echo.
echo Enter account password
set /p password=Password: 

@REM Hashes password
echo %password%>%temp%\hashinput.tmp
CertUtil -hashfile %temp%\hashinput.tmp sha256 | findstr /v "hash">%temp%\hashoutput.tmp
set /p h_password=<%temp%\hashoutput.tmp

del %temp%\hashinput.tmp
del %temp%\hashoutput.tmp

@REM Compares entered password to stored password
if %h_password% NEQ %f_password% (
    echo.
    echo Incorrect password
    set name=
    set h_name=
    set f_password=
    set password=
    set h_password=
    timeout /t 3 >nul
    goto start
)

cls
echo logged into %name%
pause>nul

set name=
set h_name=
set f_password=
set password=
set h_password=
goto :start



@REM Menu to make an account
:2
cls
echo Please enter a new name
set /p n_name=Name: 

@REM Hashes the entered name
echo %n_name%>%temp%\hashinput.tmp
CertUtil -hashfile %temp%\hashinput.tmp sha256 | findstr /v "hash">%temp%\hashoutput.tmp
set /p h_name=<%temp%\hashoutput.tmp

del %temp%\hashinput.tmp
del %temp%\hashoutput.tmp

@REM Checks if the account already exists
if exist %h_name%.dll (
    echo.
    echo Account "%n_name%" already exists
    set n_name=
    set h_name=
    timeout /t 3 >nul
    goto start
)

@REM Enter password
echo.
echo Please enter a new password
set /p n_password=Password: 
set /p c_n_password=Confirm Password: 

@REM Checks if the two passwords match
if "%n_password%" NEQ "%c_n_password%" (
    echo.
    echo Passwords don't match
    set n_name=
    set h_name=
    set n_password=
    set c_n_password=
    timeout /t 3 >nul
    goto start
)

@REM Hashes the password
echo %n_password%>%temp%\hashinput.tmp
CertUtil -hashfile %temp%\hashinput.tmp sha256 | findstr /v "hash">%temp%\hashoutput.tmp
set /p h_password=<%temp%\hashoutput.tmp

del %temp%\hashinput.tmp
del %temp%\hashoutput.tmp

@REM Makes the account file (<hashed name>.dll). hashed password is stored inside
echo %h_password%>%h_name%.dll

@REM Tells you thr account has been made
cls
echo account "%n_name%" created!
set n_name=
set n_password=
set c_n_password=
set h_name=
set h_password=
timeout /t 3 >nul
goto :start