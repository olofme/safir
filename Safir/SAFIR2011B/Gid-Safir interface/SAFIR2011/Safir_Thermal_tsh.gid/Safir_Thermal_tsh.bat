rem ----------------------------------------------------------
rem SAFIR - Shell_Temp gestartet von GID
rem ----------------------------------------------------------
rem OutputFile: %1.txt
rem ErrorFile: %1.err
rem
if NOT %SAFIR_DIR%=="" goto L1
set SAFIR_DIR = C:\SAFIR2011
:L1 echo SAFIR_DIR = %SAFIR_DIR%
set GID_DIR = %3
rem
del %1.in
del %1.out
del %1.tsh
del %1.flavia.msh
del %1.flavia.res
rem
set FixPath = %GiD_DIR%
set ResPath = %GiD_DIR%
set FixTshPath = %GiD_DIR%
rem
rem set FixPath = %GiD_DIR%\Thermal2dfix\Debug
rem set ResPath = %GiD_DIR%\Thermal2dres\Debug
rem set FixTshPath = %GiD_DIR%\fix4tsh\Debug
rem
echo FixPath = %FixPath%
echo ResPath = %ResPath%
echo FixTshPath = %FixTshPath%
rem
echo GiD started Data-converter .DAT to .IN > %1.
rem 
%FixPath%\Thermal2dfix.exe %1 >> %1.log
type %1.in >> %1.log
echo Safir started .tem-run, IN-file %1 >> %1.txt
echo %1 > infile
%SAFIR_DIR%\safir2011.exe < infile >> %1.txt
echo Safir finished .tem-run >> %1.log
rem
%FixTshPath%\fix4tsh.exe %1 >> %1.log
rem
%ResPath%\Thermal2dres.exe %1 >> %1.txt
if not exist %2\%1.flavia.res echo "Program failed" >> %2\%1.err
echo Postprocessor Data generated >> %1.log
rem
rem SAFIR Ende ----------------------------------------------
