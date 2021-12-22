@echo off
title sha256 hasher
:start
cls
set /p input=Text: 

@REM VVV Hashing process VVV
@REM Variables: %input% is the text that will be hashed, %output% is the hashed text.
echo %input%>%temp%\hashinput.tmp
CertUtil -hashfile %temp%\hashinput.tmp sha256 | findstr /v "hash">%temp%\hashoutput.tmp
set /p output=<%temp%\hashoutput.tmp

del %temp%\hashinput.tmp
del %temp%\hashoutput.tmp
@REM ^^^ Hashing process ^^^

echo %output%
pause>nul
set input=
set output=
goto :start