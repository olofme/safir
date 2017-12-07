rem ----------------------------------------------------------
rem SAFIR - Thermal_2D gestartet von GID
rem ----------------------------------------------------------
rem OutputFile: %1.txt
rem ErrorFile: %1.err
rem if NOT %SAFIR_DIR%=="" goto L1
set SAFIR_DIR = C:\SAFIR2011
:L1 echo SAFIR_DIR = %SAFIR_DIR%
rem
set GID_DIR = %3
rem
del %1.in
del %1.out
del %1.txt
del %1.log
del %1.tem

del %1-1.in
del %1-1.out
del %1-1.txt
del %1-1.log
del %1-1.t0r
del %1-1.tor

del %1.flavia.msh
del %1.flavia.res
rem
set FixPath = %GiD_DIR%
set ResPath = %GiD_DIR%
set FixTemPath = %GiD_DIR%
rem
echo GiD started Data-converter .DAT to .IN > %1.txt
rem 
%FixPath%\Thermal2dfix.exe %1 >> %1.txt
echo Safir started .tem-run, IN-file %1 >> %1.txt
echo %1 > infile
%SAFIR_DIR%\safir2011.exe < infile >> %1.txt
echo Safir finished .tem-run >> %1.txt
rem
if not exist %1-1.in goto Lres
rem
echo Safir started .tor-run, IN-file %1-1 >> %1.txt
echo %1-1 > infile
%SAFIR_DIR%\safir2011.exe < infile >> %1.txt
echo Safir finished .tor-run >> %1.txt
rem
:Lres
%FixTemPath%\fix4tem.exe %1 >> %1.txt
rem
%ResPath%\Thermal2dres.exe %1 >> %1.txt
if not exist %2\%1.flavia.res echo "No .out-file or results in .out-file found" >> %2\%1.err
echo Postprocessor Data generated >> %1.txt
rem
rem SAFIR Ende --------------------------------------------------
